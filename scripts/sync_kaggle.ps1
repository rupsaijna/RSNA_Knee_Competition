# Sync the local notebook to Kaggle and pull outputs back, without downloading
# the competition data locally (it is mounted on Kaggle at run time).
#
# Usage:
#   powershell -File scripts\sync_kaggle.ps1 push      # copy notebook + push to Kaggle (starts a run)
#   powershell -File scripts\sync_kaggle.ps1 pull      # fetch submission.csv into out\
#   powershell -File scripts\sync_kaggle.ps1 status    # show kernel run status
#   powershell -File scripts\sync_kaggle.ps1 list      # list your kernels

param(
    [ValidateSet("push", "pull", "status", "list")]
    [string]$Action = "push",
    [string]$Kernel = "rupsajina/rsna-knee-cpu-baseline"
)

$ErrorActionPreference = "Stop"

$Root    = Split-Path -Parent $PSScriptRoot
$KagDir  = Join-Path $Root "kaggle"
$OutDir  = Join-Path $Root "out"
$Notebook = Join-Path $Root "rsna_knee_cpu_baseline.ipynb"

switch ($Action) {
    "push" {
        if (-not (Test-Path $Notebook)) { throw "Notebook not found: $Notebook" }
        Copy-Item -Force $Notebook (Join-Path $KagDir "rsna_knee_cpu_baseline.ipynb")
        Write-Host "Pushing $Kernel ..." -ForegroundColor Cyan
        kaggle kernels push -p $KagDir
    }
    "pull" {
        New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
        Write-Host "Pulling output of $Kernel into $OutDir" -ForegroundColor Cyan
        kaggle kernels output -k $Kernel -p $OutDir --file-pattern "submission.*" -o
    }
    "status" {
        kaggle kernels status $Kernel
    }
    "list" {
        kaggle kernels list --user rupsajina --sort-by dateRun --page-size 10
    }
}
