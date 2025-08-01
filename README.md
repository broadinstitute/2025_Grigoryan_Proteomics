# Repository for Cell Painting + proteomics OASIS manuscript

This repository contains all of the code for the OASIS manuscript on paired Cell Painting and secreted protein data for 37 compounds.

## Environments

There is a separate environment in each of the analysis folders (00.data_processing_exploration, 02.dose_response, etc). We managed environments with [uv](https://docs.astral.sh/uv/getting-started/installation/), but you should be able to use any package manager with the requirements.txt file.

To install and activate a new environment - using the first analysis module as an example:

```bash
cd ./00.data_processing_exploration
./install_env.sh
source oasis-prot-proc/bin/activate
```

To install a new package with uv: `uv pip install pkg-name`. To add newly installed packages to the dependency file: `uv pip freeze > requirements.txt`.
