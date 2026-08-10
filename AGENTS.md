# Project conventions

- Major rewrites of the notebook/pipeline must go into a **new file** (e.g. a versioned `*.ipynb` or `*.py`), never overwrite the existing `rsna_knee_cpu_baseline.ipynb`.
- The build script and sim harness live under the user's temp workspace (`C:\Users\Trshant\AppData\Local\Temp\opencode`) for local iteration; the committed artifact is the notebook in this repo.
