## Miniforge With Python环境自动安装工具

本工具主要提供如下功能：

1. 检查用户系统是否已安装Python（但尚不具备环境版本检查功能，如有需要可自行实现），并打印出Python的版本信息；
2. 对于未安装Python环境的情况：
    - 检查是否已经安装Anaconda/Miniconda环境，并通过conda命令创建Python环境（env）来测试功能是否良好（根据打印信息自行判断）；
    - 如果未安装Conda环境，则根据系统类型安装对应的miniconda最新版本，然后进行Python环境创建测试；

本工具可以十分方便的集成于其他代码库里，作为目标用户程序依赖Python环境的前置安装工具，但目前本工具不包括Python库的依赖安装，需自行管理(如使用pip、源码库setup等)。

目前支持的环境如下：

- Windows x86_64
- Linux x86_64/arm64
- MacOS Intel x86_64/Apple M1 arm64

## 使用方式

下载Release版本：[latest](-/tags), 解压后在embedding-py-conda/根目录中执行：

```bash
bash install-python.sh
```

命令会检查当前python环境是否存在，并决定是否进行安装miniconda来配置python环境。

直接安装最新版miniconda环境（需要联网）：

```bash
bash install-python.sh -i -f -y -u
```

此命令会强制安装最新版本的Miniconda，默认安装在用户目录的miniconda3文件夹下（$HOME/miniconda3)，如果该目录已存在的话会执行覆盖安装。

安装完成后会进行Python环境的创建测试。

## 详细使用说明

在Release中选择最新版本压缩包下载，对于 Linux/MacOS直接执行`bash install-python.sh`，
对于Windows，目前仅支持在MSYS/MinGW/Cygwin/Git Bash环境中运行`bash install-python.sh`。

```bash

❯  bash install-python.sh -h
<A tool to check if python environment exists or install it by miniconda >
Usage: ./install-python.sh [-y|--(no-)yes] [-f|--(no-)force] [-u|--(no-)update] [-i|--(no-)install-conda] [--(no-)offline] [-h|--help]
        -y, --yes, --no-yes: "Do not ask for confirmation." (off by default)
        -f, --force, --no-force: "Force to install or update when already exists" (off by default)
        -u, --update, --no-update: "Update current version to latest" (off by default)
        -i, --install-conda, --no-install-conda: "Install miniconda ignored existing python environment" (off by default)
        --offline, --no-offline: "Offline mode. Don't connect to the Internet" (off by default)
        -h, --help: Prints help

Short options stacking mode is not supported.

```

一般情况下，直接执行`bash install-python.sh`，会分为以下几种情况：

#### 1. 已有Python环境（不管是由Conda创建还是自行安装）

已有Python环境会输出版本信息，eg:

```bash
❯  bash install-python.sh 
[INFO] checking python environment
[INFO] python version: 3.9.12
[INFO] python already exists, nothing to do and exit
```

#### 2. 无Python环境

执行脚本后会进行Conda环境检查，有Conda环境情况下，会进行Python环境创建测试（一般有Conda就有Python，有Conda没Python多半是环境变量有问题），
你也可以使用`bash install-python.sh -i`直接跳过Python环境检查直接进入Conda环境检测安装步骤：

eg:

```bash
❯  bash install-python.sh -i
[INFO] checking conda environment...
[INFO] located conda executable program: /Users/dokey/miniconda3/bin/conda
 conda version: conda 4.13.0
[INFO] updating conda to the latest version
Collecting package metadata (current_repodata.json): done
Solving environment: done

## Package Plan ##

  environment location: /Users/dokey/miniconda3

  added / updated specs:
    - conda


The following packages will be downloaded:

    package                    |            build
    ---------------------------|-----------------
    ca-certificates-2022.07.19 |       hca03da5_0         124 KB
    ------------------------------------------------------------
                                           Total:         124 KB

The following packages will be UPDATED:

  ca-certificates                      2022.4.26-hca03da5_0 --> 2022.07.19-hca03da5_0


Proceed ([y]/n)?
```

如上所示，如果检查到已经安装conda环境，那么会执行update（联网情况下），提示是否确认更新，输入y确认更新，输入n拒绝更新。

之后就会进入python环境创建测试环节：

我这里输入y确认更新：

```bash
Proceed ([y]/n)? y


Downloading and Extracting Packages
ca-certificates-2022 | 124 KB    | ############################################################################################################################################################################################# | 100% 
Preparing transaction: done
Verifying transaction: done
Executing transaction: done
[INFO] conda env create test: venv-test
Collecting package metadata (current_repodata.json): done
Solving environment: done

## Package Plan ##

  environment location: /Users/dokey/Workspace/python/embedding-py-conda/venv-test

  added / updated specs:
    - python=3


The following NEW packages will be INSTALLED:

  bzip2              pkgs/main/osx-arm64::bzip2-1.0.8-h620ffc9_4
  ca-certificates    pkgs/main/osx-arm64::ca-certificates-2022.07.19-hca03da5_0
  certifi            pkgs/main/osx-arm64::certifi-2022.6.15-py310hca03da5_0
  libcxx             pkgs/main/osx-arm64::libcxx-12.0.0-hf6beb65_1
  libffi             pkgs/main/osx-arm64::libffi-3.4.2-hc377ac9_4
  ncurses            pkgs/main/osx-arm64::ncurses-6.3-h1a28f6b_3
  openssl            pkgs/main/osx-arm64::openssl-1.1.1q-h1a28f6b_0
  pip                pkgs/main/osx-arm64::pip-22.1.2-py310hca03da5_0
  python             pkgs/main/osx-arm64::python-3.10.4-hbdb9e5c_0
  readline           pkgs/main/osx-arm64::readline-8.1.2-h1a28f6b_1
  setuptools         pkgs/main/osx-arm64::setuptools-61.2.0-py310hca03da5_0
  sqlite             pkgs/main/osx-arm64::sqlite-3.38.5-h1058600_0
  tk                 pkgs/main/osx-arm64::tk-8.6.12-hb8d0fd4_0
  tzdata             pkgs/main/noarch::tzdata-2022a-hda174b7_0
  wheel              pkgs/main/noarch::wheel-0.37.1-pyhd3eb1b0_0
  xz                 pkgs/main/osx-arm64::xz-5.2.5-h1a28f6b_1
  zlib               pkgs/main/osx-arm64::zlib-1.2.12-h5a0b063_2


Preparing transaction: done
Verifying transaction: done
Executing transaction: done
#
# To activate this environment, use
#
#     $ conda activate /Users/dokey/Workspace/python/embedding-py-conda/venv-test
#
# To deactivate an active environment, use
#
#     $ conda deactivate

[INFO] conda env venv-test created
[INFO] conda env venv-test activated
Python 3.10.4
[INFO] conda env create test successful
[INFO] removing conda env venv-test

Remove all packages in environment /Users/dokey/Workspace/python/embedding-py-conda/venv-test:


## Package Plan ##

  environment location: /Users/dokey/Workspace/python/embedding-py-conda/venv-test


The following packages will be REMOVED:

  bzip2-1.0.8-h620ffc9_4
  ca-certificates-2022.07.19-hca03da5_0
  certifi-2022.6.15-py310hca03da5_0
  libcxx-12.0.0-hf6beb65_1
  libffi-3.4.2-hc377ac9_4
  ncurses-6.3-h1a28f6b_3
  openssl-1.1.1q-h1a28f6b_0
  pip-22.1.2-py310hca03da5_0
  python-3.10.4-hbdb9e5c_0
  readline-8.1.2-h1a28f6b_1
  setuptools-61.2.0-py310hca03da5_0
  sqlite-3.38.5-h1058600_0
  tk-8.6.12-hb8d0fd4_0
  tzdata-2022a-hda174b7_0
  wheel-0.37.1-pyhd3eb1b0_0
  xz-5.2.5-h1a28f6b_1
  zlib-1.2.12-h5a0b063_2


Preparing transaction: done
Verifying transaction: done
Executing transaction: done
[INFO] miniconda environment initialized, and you can use command 'conda create' to create a new python environment
```

对于没有Conda环境情况下，会下载Miniconda最新版本进行安装，eg：

```bash
❯  bash install-python.sh 
[INFO] checking conda environment...
[INFO] there is no conda environment
Do you want install conda program now?[y/n]
```

然后根据提示进行确认一步一步输入即可安装完成。
当然，如果你想跳过冗长繁琐的确认步骤，可以使用`-y`或者`--yes`参数来跳过确认： `bash install-python.sh -y` 执行静默安装。

**注意：默认版本需要联网下载才可以安装miniconda环境，后续补充离线安装版本（安装包会较大）**

### 3. 无视已存在的Python环境直接强制安装Miniconda

执行：

```bash
bash install-python.sh -i -y -f
```

### 4. 安装之后要重启shell终端，环境变量才会生效

利用本工具进行安装之后，需要重新打开终端环境变量才会生效。

如果在未重开终端的情况下再次执行安装会出现如下提示：

```bash
❯ bash install-python.sh  -i 
[INFO] checking conda environment...
[INFO] located conda executable program: /Users/dokey/miniconda3/bin/conda
 conda version: conda 4.13.0
[ERRO] conda test failed, please reopen your terminal and run 'install-python.sh'
```

最后一行提示需要重新打开终端才可以正常执行conda环境创建测试。
