## Miniforge With Python环境自动安装工具

本工具主要提供如下功能：

1. 检查用户系统是否已安装Python（但尚不具备环境版本检查功能，如有需要可自行实现），并打印出Python的版本信息；
2. 对于未安装Python环境的情况：
    - 检查是否已经安装conda(forge)环境，并通过conda命令创建Python环境（env）来测试功能是否良好（根据打印信息自行判断）；
    - 如果未安装Conda环境，则根据系统类型安装对应的miniforge最新版本，然后进行Python环境创建测试；

本工具可以十分方便的集成于其他代码库里，作为目标用户程序依赖Python环境的前置安装工具，但目前本工具不包括Python库的依赖安装，需自行管理(如使用pip、源码库setup等)。

目前支持的环境如下：

- Windows x86_64
- Linux x86_64/arm64
- MacOS Intel x86_64/Apple M1/M2 arm64

## 使用方式

下载Release版本：[latest](-/tags), 解压后在embedding-miniforge/根目录中执行：

```bash
bash install.sh
```

命令会检查当前python环境是否存在，并决定是否进行安装miniforge来配置python环境。

直接安装最新版miniforge环境（需要联网）：

```bash
bash install.sh -i -f -y -u
```

此命令会强制安装最新版本的Miniforge3，默认安装在用户目录的miniforge3文件夹下（$HOME/miniforge3)，如果该目录已存在的话会执行覆盖安装。

安装完成后会进行Python环境的创建测试。

## 详细使用说明

在Release中选择最新版本压缩包下载，对于 Linux/MacOS直接执行`bash install.sh`，
对于Windows，目前仅支持在MSYS/MinGW/Cygwin/Git Bash环境中运行`bash install.sh`。

```bash

❯  bash install.sh -h
<A tool to check if python environment exists or install it by miniforge >
Usage: bin/install.sh [-y|--(no-)yes] [-f|--(no-)force] [-u|--(no-)update] [-i|--(no-)install-forge] [--(no-)offline] [-h|--help]
        -y, --yes, --no-yes: "Do not ask for confirmation." (off by default)
        -f, --force, --no-force: "Force to install or update(full) when already exists" (off by default)
        -u, --update, --no-update: "Update current version to latest" (off by default)
        -i, --install-forge, --no-install-forge: "Install miniforge ignored existing python environment" (off by default)
        --offline, --no-offline: "Offline mode. Don't connect to the Internet" (off by default)
        -h, --help: Prints help

Short options stacking mode is not supported.

```

一般情况下，直接执行`bash install.sh`，会分为以下几种情况：

#### 1. 已有Python环境（不管是由Conda创建还是自行安装）

已有Python环境会输出版本信息，eg:

```bash
❯  bash install.sh 
[INFO] checking python environment
[INFO] python version: 3.9.12
[INFO] python already exists, nothing to do and exit
```

#### 2. 无Python环境

执行脚本后会进行Conda环境检查，有Conda环境情况下，会进行Python环境创建测试（一般有Conda就有Python，有Conda没Python多半是环境变量有问题），
你也可以使用`bash install.sh -i`直接跳过Python环境检查直接进入Conda环境检测安装步骤：

eg:

```bash
❯  bash install.sh -i
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

  added / updated specs:
    - python=3


The following NEW packages will be INSTALLED:

  bzip2              conda-forge/osx-arm64::bzip2-1.0.8-h3422bc3_4 
  ca-certificates    conda-forge/osx-arm64::ca-certificates-2023.7.22-hf0a4a13_0 
  libexpat           conda-forge/osx-arm64::libexpat-2.5.0-hb7217d7_1 
  libffi             conda-forge/osx-arm64::libffi-3.4.2-h3422bc3_5 
  libsqlite          conda-forge/osx-arm64::libsqlite-3.43.2-h091b4b1_0 
  libzlib            conda-forge/osx-arm64::libzlib-1.2.13-h53f4e23_5 
  ncurses            conda-forge/osx-arm64::ncurses-6.4-h7ea286d_0 
  openssl            conda-forge/osx-arm64::openssl-3.1.3-h53f4e23_0 
  pip                conda-forge/noarch::pip-23.2.1-pyhd8ed1ab_0 
  python             conda-forge/osx-arm64::python-3.12.0-h47c9636_0_cpython 
  readline           conda-forge/osx-arm64::readline-8.2-h92ec313_1 
  setuptools         conda-forge/noarch::setuptools-68.2.2-pyhd8ed1ab_0 
  tk                 conda-forge/osx-arm64::tk-8.6.13-hb31c410_0 
  tzdata             conda-forge/noarch::tzdata-2023c-h71feb2d_0 
  wheel              conda-forge/noarch::wheel-0.41.2-pyhd8ed1ab_0 
  xz                 conda-forge/osx-arm64::xz-5.2.6-h57fd34a_0 



Downloading and Extracting Packages

Preparing transaction: done
Verifying transaction: done
Executing transaction: done
#
# To activate this environment, use
#
#     $ conda activate /Users/dokey/Workspace/python/embedding-miniforge/venv-test
#
# To deactivate an active environment, use
#
#     $ conda deactivate

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

如上所示，先检查是否已经安装conda环境，之后就会进入python环境创建测试环节，最后测试完成后删除创建的测试环境。

执行过程中可能会遇到提示是否确认更新，输入y确认更新，输入n拒绝更新。

对于没有Conda环境情况下，会下载Miniforge最新版本进行安装，eg：

```bash
❯  bash install.sh -i
[INFO] checking conda(forge) environment...
[INFO] there is no conda environment
Do you want install conda program now?[y/n]
```

然后根据提示进行确认一步一步输入即可安装完成。
当然，如果你想跳过冗长繁琐的确认步骤，可以使用`-y`或者`--yes`参数来跳过确认： `bash install.sh -i -y` 执行静默安装。

**注意：默认版本需要联网下载才可以安装miniforge环境，后续补充离线安装版本（安装包会较大）**

### 3. 无视已存在的Python环境直接强制安装Miniforge

执行：

```bash
bash install.sh -i -y -f
```

### 4. 安装之后要重启shell终端，环境变量才会生效

利用本工具进行安装之后，需要重新打开终端环境变量才会生效。

如果在未重开终端的情况下再次执行安装可能会出现如下提示：

```bash
❯ bash install.sh  -i 
[INFO] checking conda environment...
[INFO] located conda executable program: /Users/dokey/miniforge3/bin/conda
 conda version: conda 23.7.4
[ERRO] conda test failed, please reopen your terminal and run 'install.sh'
```

最后一行提示需要重新打开终端才可以正常执行conda环境创建测试。
