[English](README.md) / [简体中文](README_zh.md)
## Miniforge With Python environment automatic installation tool

This tool mainly provides the following functions:

1. Check whether Python has been installed on the user system (but it does not yet have the environment version checking function, you can implement it yourself if necessary), and print out the Python version information;
2. If the Python environment is not installed:
     - Check whether the Anaconda/Miniconda environment has been installed, and create a Python environment (env) through the conda command to test whether the function is good (judge based on the printed information);
     - If the Conda environment is not installed, install the latest version of miniconda according to the system type, and then create a Python environment for testing;

This tool can be easily integrated into other code libraries as a pre-installation tool for target user programs that rely on the Python environment. However, currently this tool does not include dependent installation of Python libraries and needs to be managed by yourself (such as using pip, source code library setup, etc. ).

The currently supported environments are as follows:

- Windows x86_64
- Linux x86_64/arm64
- MacOS Intel x86_64/Apple M1 arm64

## Usage

Download the Release version: [latest](-/tags), unzip and execute in the embedding-py-conda/ root directory:

```bash
bash install-python.sh
```

The command will check whether the current python environment exists and decide whether to install miniconda to configure the python environment.

Directly install the latest version of miniconda environment (requires Internet connection):

```bash
bash install-python.sh -i -f -y -u
```

This command will force the installation of the latest version of Miniconda. By default, it is installed in the miniconda3 folder of the user directory ($HOME/miniconda3). If the directory already exists, an overwrite installation will be performed.

After the installation is completed, the Python environment will be created and tested.

## Detailed instructions for use

Select the latest version compressed package in Release to download, and directly execute `bash install-python.sh` for Linux/MacOS.
For Windows, currently only running `bash install-python.sh` in MSYS/MinGW/Cygwin/Git Bash environment is supported.

```bash

❯ bash install-python.sh -h
<A tool to check if python environment exists or install it by miniconda>
Usage: ./install-python.sh [-y|--(no-)yes] [-f|--(no-)force] [-u|--(no-)update] [-i|- -(no-)install-conda] [--(no-)offline] [-h|--help]
         -y, --yes, --no-yes: "Do not ask for confirmation." (off by default)
         -f, --force, --no-force: "Force to install or update when already exists" (off by default)
         -u, --update, --no-update: "Update current version to latest" (off by default)
         -i, --install-conda, --no-install-conda: "Install miniconda ignored existing python environment" (off by default)
         --offline, --no-offline: "Offline mode. Don't connect to the Internet" (off by default)
         -h, --help: Prints help

Short options stacking mode is not supported.

```

Under normal circumstances, directly executing `bash install-python.sh` will be divided into the following situations:

#### 1. Existing Python environment (whether created by Conda or installed by yourself)

Existing Python environments will output version information, eg:

```bash
❯ bash install-python.sh
[INFO] checking python environment
[INFO] python version: 3.9.12
[INFO] python already exists, nothing to do and exit
```

#### 2. No Python environment

After executing the script, the Conda environment will be checked. If there is a Conda environment, a Python environment creation test will be performed (generally, if there is Conda, there will be Python. If there is Conda but not Python, it is probably because there is a problem with the environment variables).
You can also use `bash install-python.sh -i` to directly skip the Python environment check and go directly to the Conda environment detection installation steps:

eg:

```bash
❯ bash install-python.sh -i
[INFO] checking conda environment...
[INFO] located conda executable program: /Users/dokey/miniconda3/bin/conda
  conda version: conda 4.13.0
[INFO] updating conda to the latest version
Collecting package metadata (current_repodata.json): done
Solving environment: done

## Package Plan ##

   environment location: /Users/dokey/miniconda3

   added/updated specs:
     -conda


The following packages will be downloaded:

     package | build
     -------------------------------|-----------------
     ca-certificates-2022.07.19 | hca03da5_0 124 KB
     -------------------------------------------------- ----------
                                            Total: 124 KB

The following packages will be UPDATED:

   ca-certificates 2022.4.26-hca03da5_0 --> 2022.07.19-hca03da5_0


Proceed ([y]/n)?
```

As shown above, if it is checked that the conda environment has been installed, update will be executed (when connected to the Internet), prompting whether to confirm the update, enter y to confirm the update, enter n to reject the update.

After that, you will enter the python environment to create the test link:

I enter y here to confirm the update:

```bash
Proceed ([y]/n)? y


Downloading and Extracting Packages
ca-certificates-2022 | 124 KB | ######################################## ################################################ ################################################ ############################################### | 100 %
Preparing transaction: done
Verifying transaction: done
Executing transaction: done
[INFO] conda env create test: venv-test
Collecting package metadata (current_repodata.json): done
Solving environment: done

## Package Plan ##

   environment location: /Users/dokey/Workspace/python/embedding-py-conda/venv-test

   added/updated specs:
     -python=3


The following NEW packages will be INSTALLED:

   bzip2 pkgs/main/osx-arm64::bzip2-1.0.8-h620ffc9_4
   ca-certificates pkgs/main/osx-arm64::ca-certificates-2022.07.19-hca03da5_0
   certifi pkgs/main/osx-arm64::certifi-2022.6.15-py310hca03da5_0
   libcxx pkgs/main/osx-arm64::libcxx-12.0.0-hf6beb65_1
   libffi pkgs/main/osx-arm64::libffi-3.4.2-hc377ac9_4
   ncurses pkgs/main/osx-arm64::ncurses-6.3-h1a28f6b_3
   openssl pkgs/main/osx-arm64::openssl-1.1.1q-h1a28f6b_0
   pip pkgs/main/osx-arm64::pip-22.1.2-py310hca03da5_0
   python pkgs/main/osx-arm64::python-3.10.4-hbdb9e5c_0
   readline pkgs/main/osx-arm64::readline-8.1.2-h1a28f6b_1
   setuptools pkgs/main/osx-arm64::setuptools-61.2.0-py310hca03da5_0
   sqlite pkgs/main/osx-arm64::sqlite-3.38.5-h1058600_0
   tk pkgs/main/osx-arm64::tk-8.6.12-hb8d0fd4_0
   tzdata pkgs/main/noarch::tzdata-2022a-hda174b7_0
   wheel pkgs/main/noarch::wheel-0.37.1-pyhd3eb1b0_0
   xz pkgs/main/osx-arm64::xz-5.2.5
