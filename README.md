## Miniforge With Python environment automatic installation tool

This tool mainly provides the following functions:

1. Check whether Python has been installed on the user system (but it does not yet have the environment version checking function, you can implement it yourself if necessary), and print out the Python version information;
2. If the Python environment is not installed:
     - Check whether the conda (forge) environment has been installed, and create a Python environment (env) through the conda command to test whether the function is good (judge based on the printed information);
     - If the Conda environment is not installed, install the corresponding latest version of miniforge according to the system type, and then create and test the Python environment;

This tool can be easily integrated into other code libraries as a pre-installation tool for target user programs that rely on the Python environment. However, currently this tool does not include dependent installation of Python libraries and needs to be managed by yourself (such as using pip, source code library setup, etc. ).

The currently supported environments are as follows:

- Windows x86_64
- Linux x86_64/arm64
- MacOS Intel x86_64/Apple M1/M2 arm64

## Usage

Download the Release version: [latest](-/tags), unzip and execute in the embedding-miniforge/root directory:

```bash
bash install.sh
```

The command will check whether the current python environment exists and decide whether to install miniforge to configure the python environment.

Directly install the latest version of miniforge environment (requires Internet connection):

```bash
bash install.sh -i -f -y -u
```

This command will force the installation of the latest version of Miniforge3. By default, it is installed in the miniforge3 folder of the user directory ($HOME/miniforge3). If the directory already exists, an overwrite installation will be performed.

After the installation is completed, the Python environment will be created and tested.

## Detailed instructions for use

Select the latest version compressed package in Release to download, and directly execute `bash install.sh` for Linux/MacOS.
For Windows, currently only running `bash install.sh` in MSYS/MinGW/Cygwin/Git Bash environment is supported.

```bash

❯ bash install.sh -h
<A tool to check if python environment exists or install it by miniforge>
Usage: bin/install.sh [-y|--(no-)yes] [-f|--(no-)force] [-u|--(no-)update] [-i|--( no-)install-forge] [--(no-)offline] [-h|--help]
         -y, --yes, --no-yes: "Do not ask for confirmation." (off by default)
         -f, --force, --no-force: "Force to install or update(full) when already exists" (off by default)
         -u, --update, --no-update: "Update current version to latest" (off by default)
         -i, --install-forge, --no-install-forge: "Install miniforge ignored existing python environment" (off by default)
         --offline, --no-offline: "Offline mode. Don't connect to the Internet" (off by default)
         -h, --help: Prints help

Short options stacking mode is not supported.

```

Under normal circumstances, directly executing `bash install.sh` will be divided into the following situations:

#### 1. Existing Python environment (whether created by Conda or installed by yourself)

Existing Python environments will output version information, eg:

```bash
❯ bash install.sh
[INFO] checking python environment
[INFO] python version: 3.9.12
[INFO] python already exists, nothing to do and exit
```

#### 2. No Python environment

After executing the script, the Conda environment will be checked. If there is a Conda environment, a Python environment creation test will be performed (generally, if there is Conda, there will be Python. If there is Conda but not Python, it is probably because there is a problem with the environment variables).
You can also use `bash install.sh -i` to directly skip the Python environment check and go directly to the Conda environment detection installation steps:

eg:

```bash
❯ bash install.sh -i
[INFO] checking conda(forge) environment...
[INFO] located conda executable program: /Users/dokey/miniforge3/bin/conda
  conda version: conda 23.7.4
[INFO] add conda channels: conda config --add channels conda-forge
Warning: 'conda-forge' already in 'channels' list, moving to the top
[INFO] conda env create test: venv-test
Collecting package metadata (current_repodata.json): done
Solving environment: done


==> WARNING: A newer version of conda exists. <==
   current version: 23.7.4
   latest version: 23.9.0

Please update conda by running

     $ conda update -n base -c conda-forge conda

Or to minimize the number of packages updated during conda update use

      conda install conda=23.9.0



## Package Plan ##

   environment location: /Users/dokey/Workspace/python/embedding-miniforge/venv-test

   added/updated specs:
     -python=3


The following NEW packages will be INSTALLED:

   bzip2 conda-forge/osx-arm64::bzip2-1.0.8-h3422bc3_4
   ca-certificates conda-forge/osx-arm64::ca-certificates-2023.7.22-hf0a4a13_0
   libexpat conda-forge/osx-arm64::libexpat-2.5.0-hb7217d7_1
   libffi conda-forge/osx-arm64::libffi-3.4.2-h3422bc3_5
   libsqlite conda-forge/osx-arm64::libsqlite-3.43.2-h091b4b1_0
   libzlib conda-forge/osx-arm64::libzlib-1.2.13-h53f4e23_5
   ncurses conda-forge/osx-arm64::ncurses-6.4-h7ea286d_0
   openssl conda-forge/osx-arm64::openssl-3.1.3-h53f4e23_0
   pip conda-forge/noarch::pip-23.2.1-pyhd8ed1ab_0
   python conda-forge/osx-arm64::python-3.12.0-h47c9636_0_cpython
   readline conda-forge/osx-arm64::readline-8.2-h92ec313_1
   setuptools conda-forge/noarch::setuptools-68.2.2-pyhd8ed1ab_0
   tk conda-forge/osx-arm64::tk-8.6.13-hb31c410_0
   tzdata conda-forge/noarch::tzdata-2023c-h71feb2d_0
   wheel conda-forge/noarch::wheel-0.41.2-pyhd8ed1ab_0
   xz conda-forge/osx-arm64::xz-5.2.6-h57fd34a_0



Downloading and Extracting Packages

Preparing transaction: done
Verifying transaction: done
Executing transaction: done
#
# To activate this environment, use
#
# $ conda activate /Users/dokey/Workspace/python/embedding-miniforge/venv-test
#
# To deactivate an active environment, use
#
# $ conda deactivate

[INFO] conda env venv-test created
[INFO] conda env venv-test activated
[INFO] venv-test version: /Library/Frameworks/Python.framework/Versions/3.10/bin/python3 --version
[INFO] conda env create test successful
[INFO] removing conda env venv-test

Remove all packages in environment /Users/dokey/Workspace/python/embedding-miniforge/venv-test:


## Package Plan ##

   environment location: /Users/dokey/Workspace/python/embedding-miniforge/venv-test


The following packages will be REMOVED:

  bzip2-1.0.8-h3422bc3_4
  ca-certificates-2023.7.22-hf0a4a13_0
  libexpat-2.5.0-hb7217d7_1
  libffi-3.4.2-h3422bc3_5
  libsqlite-3.43.2-h091b4b1_0
  libzlib-1.2.13-h53f4e23_5
  ncurses-6.4-h7ea286d_0
  openssl-3.1.3-h53f4e23_0
  pip-23.2.1-pyhd8ed1ab_0
  python-3.12.0-h47c9636_0_cpython
  readline-8.2-h92ec313_1
  setuptools-68.2.2-pyhd8ed1ab_0
  tk-8.6.13-hb31c410_0
  tzdata-2023c-h71feb2d_0
  wheel-0.41.2-pyhd8ed1ab_0
  xz-5.2.6-h57fd34a_0


Preparing transaction: done
Verifying transaction: done
Executing transaction: done
[INFO] miniforge environment initialized, and you can use command 'conda create' to create a new python environment
```

As shown above, first check whether the conda environment has been installed, then enter the python environment creation test link, and finally delete the created test environment after the test is completed.

During the execution, you may be prompted to confirm the update. Enter y to confirm the update or n to reject the update.

If there is no Conda environment, the latest version of Miniforge will be downloaded and installed, eg:

```bash
❯ bash install.sh -i
[INFO] checking conda(forge) environment...
[INFO] there is no conda environment
Do you want install conda program now?[y/n]
```

Then follow the prompts to confirm and enter step by step to complete the installation.
Of course, if you want to skip the lengthy and tedious confirmation steps, you can use the `-y` or `--yes` parameters to skip the confirmation: `bash install.sh -i -y` performs a silent installation.

**Note: The default version needs to be downloaded online to install the miniforge environment. An offline installation version will be added later (the installation package will be larger)**

### 3. Ignore the existing Python environment and directly force the installation of Miniforge

implement:

```bash
bash install.sh -i -y -f
```

### 4. After installation, you must restart the shell terminal for the environment variables to take effect.

After using this tool to install, you need to reopen the terminal environment variables for them to take effect.

If you perform the installation again without restarting the terminal, the following prompt may appear:

```bash
❯ bash install.sh -i
[INFO] checking conda environment...
[INFO] located conda executable program: /Users/dokey/miniforge3/bin/conda
  conda version: conda 23.7.4
[ERRO] conda test failed, please reopen your terminal and run 'install.sh'
```

The last line prompts that the terminal needs to be reopened before the conda environment creation test can be executed normally.