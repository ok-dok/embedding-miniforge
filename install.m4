#!/usr/bin/env bash

# m4_ignore(
echo "This is a script template, not the script (yet) - pass it to 'argbash' to convert to runnable script." >&2
exit 11  #)Created by argbash-init v2.10.0
# ARG_OPTIONAL_BOOLEAN([yes], [y], "Do not ask for confirmation.")
# ARG_OPTIONAL_BOOLEAN([force], [f], "Force to install or update(full) when already exists")
# ARG_OPTIONAL_BOOLEAN([update], [u], "Update current version to latest")
# ARG_OPTIONAL_BOOLEAN([install-forge], [i], "Install miniforge ignored existing python environment")
# ARG_OPTIONAL_BOOLEAN([offline], [],"Offline mode. Don't connect to the Internet")
# ARGBASH_SET_DELIM([ ])
# ARG_OPTION_STACKING([none])
# ARG_RESTRICT_VALUES([none])
# ARG_HELP([<A tool to check if python environment exists or install it by miniforge >])
# ARGBASH_GO

# [ <-- needed because of Argbash

# vvv  PLACE YOUR CODE HERE  vvv

error(){
  echo -e "\e[31m[ERRO]\e[0m $*" #]]
}
info(){
  echo -e "\e[32m[INFO]\e[0m $*" #]]
}
warn() {
  echo -e "\e[33m[WARN]\e[0m $*" #]]
}
highlight() {
    echo -e "\e[36m$*\e[0m" #]]
}

input_confirm() {
    while [ "$confirm" == "" ]; do
      read -p "$@" confirm
    done
    temp=$(echo "$confirm" | tr [a-z] [A-Z])
    if [ "$temp" != "YES" ] && [ "$temp" != "Y" ]; then
        return 1
    else
        return 0
    fi
}

get_sys_info() {
  # 使用uname命令来获取系统信息
  # Parse the OS name and architecture from `uname`.
  os_type="$(uname | sed 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/')"
  os_arch="$(uname -m)"
  # When running inside Git bash on Windows, `uname` reports "MINGW64_NT".
  case $os_type in mingw64_nt* | msys_nt* | win*)
    os_type="windows"
    ;;
  esac
  # then judge $os_type, such as 'darwin', 'windows', 'linux'
  case "$os_type" in
    darwin*)
      os_type="darwin"
      # detect cpu arch info
      os_arch=$(uname -a | awk -F " " '{print $(NF-1)}' | grep  -ioE '(arm(32|64))|(aarch(32|64))|(x86(([_-]{1}(32|64))|(.{0})))|(amd(32|64))|(i386)' | tr [A-Z] [a-z])
      ;;
    linux*)
      # detect cpu arch info
      os_arch=$(uname -a | awk -F " " '{print $(NF-1)}' | grep  -ioE '(arm(32|64))|(aarch(32|64))|(x86(([_-]{1}(32|64))|(.{0})))|(amd(32|64))|(i386)' | tr [A-Z] [a-z])
      case $os_arch in
        arm64|armv8*)
          os_arch="aarch64"
          ;;
        armv6*|armv7*)
          os_arch="aarch32"
          ;;
      esac
      ;;
    windows*)
      os_arch=$(wmic cpu get AddressWidth | grep -v "AddressWidth" | xargs echo )
      os_arch="x86_$os_arch"
      ;;
    *)
      error "unknown: $os_type" && exit 1
      ;;
  esac
  # uniform naming convention
  case $os_arch in
    x86[_-]32|i386)
      os_arch="x86"
      ;;
    amd64)
      os_arch="x86_64"
      ;;
  esac
  echo "OS_TYPE=\"$os_type\""
  echo "OS_ARCH=\"$os_arch\""
  return 0
}

eval $(get_sys_info)

case "$OS_TYPE" in
  win*)
    mingw64_path=$(dirname $(which git 2>dev/null))
    if [ $? -ne 0 ] || [ "${mingw64_path}" == "" ];then
        mingw64_path="/mingw64/bin/"
    fi
    if ! [ -d "${mingw64_path}" ]; then
      error "cannot detect mingw64's bin path, you can copy ./whereis.exe to mingw64/bin path and retry" && return 1
    fi
    cp whereis.exe ${mingw64_path}
    ;;
esac

DEFAULT_INSTALL_PATH="$HOME/miniforge3"
DOWNLOAD_PATH="miniforge"

install_on_windows() {
  local pkgexe=""
  if [ "$_arg_offline" = "on" ]; then
    pkgexe=$(ls ${DOWNLOAD_PATH} | grep -ioE "Miniforge3-${OS_TYPE}-${OS_ARCH}.*\.exe")
  else
    local latest_tag=$(curl -kis --max-redirs 1 https://github.com/conda-forge/miniforge/releases/latest | grep location | awk -F '/' '{print $NF}' | sed 's/[[:space:]]//g' )
    pkgexe=$(curl -sk "https://github.com/conda-forge/miniforge/releases/expanded_assets/${latest_tag}" |
                grep -ioE "href=\"/conda-forge/miniforge/releases/download/${latest_tag}/.*\.exe" |
                sed 's/href="//' | grep -ioE "Miniforge3-${OS_TYPE}-${OS_ARCH}\.exe")
    [ $? != 0 ] && error "can not access the internet, please check your network status and make sure you can access the internet and try again, or you can use '--offline' mode that won't use internet."
  fi
  if [ "$pkgexe" = "" ]; then
    error "can not find a suitable version of miniforge. you can visit web site \"https://github.com/conda-forge/miniforge/releases/latest\" to download the suitable miniforge version and install it by manual" && return 1
  fi
  if [ ! -e "${DOWNLOAD_PATH}/$pkgexe" ]; then
    info "downloading conda(forge) executable file: https://github.com/conda-forge/miniforge/releases/download/${latest_tag}/$pkgexe"
    mkdir -p "${DOWNLOAD_PATH}" && curl -k -L "https://github.com/conda-forge/miniforge/releases/download/${latest_tag}/$pkgexe" -o "${DOWNLOAD_PATH}/$pkgexe"
  else
    info "using cached package: ${DOWNLOAD_PATH}/$pkgexe"
  fi
  info "installing conda(forge)"
  if [ "$_arg_yes" = "on" ]; then
    cmd //C "start /wait ${DOWNLOAD_PATH}/$pkgexe /InstallationType=JustMe /AddToPath=1 /RegisterPython=1 /S /D=${DEFAULT_INSTALL_PATH}"
  else
    "${DOWNLOAD_PATH}/$pkgexe"
  fi
  return $?
}

install_on_linux_or_macos(){
  local pkgsh=""
  if [ "$_arg_offline" = "on" ]; then
     pkgsh=$(ls ${DOWNLOAD_PATH} | grep -ioE "Miniforge3-${OS_TYPE}-${OS_ARCH}\.exe")
  else
    local latest_tag=$(curl -kis --max-redirs 1 https://github.com/conda-forge/miniforge/releases/latest | grep location | awk -F '/' '{print $NF}' | sed 's/[[:space:]]//g' )
    pkgsh=$(curl -sk "https://github.com/conda-forge/miniforge/releases/expanded_assets/${latest_tag}" |
                grep -ioE "href=\"/conda-forge/miniforge/releases/download/${latest_tag}/.*\.sh" |
                sed 's/href="//' | grep -ioE "Miniforge3-${OS_TYPE}-${OS_ARCH}\.sh")
    [ $? != 0 ] && error "can not access the internet, please check your network status and make sure you can access the internet and try again, or you can use '--offline' mode that won't use internet."
  fi
  if [ "$pkgsh" = "" ]; then
    error "can not find a suitable version of miniforge. you can visit web site \"https://github.com/conda-forge/miniforge/releases/latest\" to download the suitable miniforge version and install it by manual" && return 1
  fi
  if [ ! -e "${DOWNLOAD_PATH}/$pkgsh" ]; then
    info "downloading conda(forge) executable file: https://github.com/conda-forge/miniforge/releases/download/${latest_tag}/$pkgsh"
    mkdir -p ${DOWNLOAD_PATH} && curl -k -L "https://github.com/conda-forge/miniforge/releases/download/${latest_tag}/$pkgsh" -o "${DOWNLOAD_PATH}/$pkgsh"
  else
    info "using cached package: ${DOWNLOAD_PATH}/$pkgsh"
  fi
  info "installing conda(forge)"
  _run_args=""
  if [ "$_arg_force" = "on" ]; then
    _run_args="$_run_args -f"
  fi
  if [ "$_arg_yes" = "on" ]; then
    _run_args="$_run_args -b -p ${DEFAULT_INSTALL_PATH}"
  fi
  info "running install script: bash ${DOWNLOAD_PATH}/$pkgsh $_run_args"
  bash "${DOWNLOAD_PATH}/$pkgsh" $_run_args
  return $?
}

locate_conda_path(){
    case "$OS_TYPE" in
      darwin*|linux*)
        CONDA_PATH=$(dirname $(whereis conda | awk -F': ' '{print $2}' 2>/dev/null) 2>/dev/null | sed 's/[[:space:]]//g')
        if [ "${CONDA_PATH}" == "" ]; then
          if ls "${DEFAULT_INSTALL_PATH}/bin/" >/dev/null 2>&1; then
            CONDA_PATH="${DEFAULT_INSTALL_PATH}/bin" && return 0
          else
            return 1
          fi
        fi
        ;;
      win*)
        CONDA_PATH=$(dirname $(whereis conda | awk -F': ' '{print $2}' 2>/dev/null) 2>/dev/null | sed 's/[[:space:]]//g')
        if [ "${CONDA_PATH}" == "" ]; then
          menu_dir=$(ls "$HOME/AppData/Roaming/Microsoft/Windows/Start Menu/Programs" | grep -i "conda")
          lnk_name=$(ls "$HOME/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/$menu_dir/" | grep -vi "powershell" | grep -ioE ".*\.lnk")
          lnk_file="$HOME/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/$menu_dir/$lnk_name"
          if [ "$lnk_name" = "" ] || [ ! -e "$lnk_file" ]; then
              warn "cannot find the miniforge startup lnk file in Start Menu" && return 1
          fi
          CONDA_PATH=$("$(pwd)/bin/lnkparse.exe" "$HOME/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/$menu_dir/$lnk_name" | awk -F' ' '{print $3"\\Scripts"}')
          if [ $? != 0 ]; then
              warn "cannot get the installed path of conda(forge)" && return 1
          fi
        fi
      ;;
    esac
    return $?
}

locate_and_activate_conda(){
  locate_conda_path && . "${CONDA_PATH}/activate"
    if [ $? != 0 ]; then
        error "cannot get the installed path of miniforge, you can restart your terminal and run \"$0 -i\" to init and test conda" && return 1
    fi
    return
}

install_conda() {
  if [ "$OS_TYPE" = "" ] || [ "$OS_ARCH" = "" ]; then
    error "cannot detected your system version info" && return 1
  fi
  info "detected system info, OS_TYPE: $OS_TYPE, OS_ARCH: $OS_ARCH"
  # get miniforge3 install package
  case "$OS_TYPE" in
    darwin*|linux*)
      install_on_linux_or_macos || return $?
      info "conda init"
      locate_and_activate_conda || return $?
      conda install -y -n base conda-libmamba-solver
      conda config --set solver libmamba
      # init profile
      case $(basename "$SHELL") in
        bash*)
          conda init bash && . "$HOME/.bash_profile"
          ;;
        zsh*)
          conda init zsh && . "$HOME/.zsh_profile"
          ;;
        *)
          conda init "$(basename "$SHELL")" && . "$HOME/*profile"
      esac
      return $?
      ;;
    win*)
      install_on_windows || return $?
      info "conda init"
      locate_and_activate_conda || return $?
      ;;
  esac
}

check_and_install_conda() {
  # 检查conda(forge)环境
  info "checking conda(forge) environment..."
  locate_conda_path
  if [ $? == 0 ]; then
    conda_exec="${CONDA_PATH}/conda"
    info "located conda executable program: $conda_exec\n conda version: `highlight "$(conda --version)"`"
    if [ "$_arg_force" = "off" ]; then
      return 0
    else
      # 强制安装的情况下先删除原先已存在的conda(forge)环境
      conda init --reverse
      installed_path=$(dirname ${CONDA_PATH})
      info "cleaning conda directory: ${installed_path}"
      rm -rf ${installed_path}
    fi
  else
    info "there is no conda environment"
  fi

  # 强制安装或者不存在conda时进行安装
  # 是否开启询问模式
  comfirmed=false
  if [ "$_arg_yes" = "off" ]; then
    input_confirm "Do you want install conda program now?[y/n]" && comfirmed=true
  else
    comfirmed=true
  fi
  if $comfirmed; then
    install_conda && info "conda(forge) installed, version: $(bash -c 'conda --version')" && return 0 || error "conda(forge) install failed" && return 1
  else
    warn "conda(forge) installing canceled, you can install it manual or rerun this script" && return 1
  fi
}

check_python_environment() {
  py_exec=$(which python 2>/dev/null || which python3 2>/dev/null || which python2 2>/dev/null)
  if [ $? == 0 ]; then
    ver=$($py_exec --version 2>&1)
    if [ $? != 0 ]; then
      warn "cannot get python version" && return 1
    else
      info "python version: $(echo $ver | awk -F" " '{print $2}')" && return 0
    fi
  fi
  warn "your system environment doesn't have python program yet"
  return 1
}

main() {
  # 是否忽略python环境检查
  ignored_pycheck=false
  if [ "$_arg_install_forge" = "on" ]; then
    ignored_pycheck=true
  fi
  py_not_exist=false
  if ! $ignored_pycheck ; then
    # 是否python环境存在
    info "checking python environment"
    check_python_environment
    if [ $? == 0 ]; then
      info "python already exists, nothing to do and exit"
      return 0
    else
      py_not_exist=true
    fi
  fi
  # 在忽略python环境检查或者检查后python不存在时执行conda检查和安装
  if $ignored_pycheck || $py_not_exist ; then
    conda_checked=false
    check_and_install_conda
    [ $? == 0 ] && conda_checked=true
    if $conda_checked; then
      conda_exec=$(whereis conda | awk -F': ' '{print $2}' 2>/dev/null)
      if [ $? != 0 ]; then
        error "conda test failed, please reopen your terminal and run '$0'" && return 1
      fi
      if [ "$_arg_offline" = "off" ]; then
        # 开启更新选项或者强制选项时，进行更新
        if [ "$_arg_update" = "on" ] || [ "$_arg_force" = "on" ]; then
          update_yes=""
          if [ "$_arg_yes" = "on" ]; then
            update_yes="-y"
          fi
          info "updating conda to the latest version"
          conda update $update_yes -n base -c conda-forge conda
          if [ $? != 0 ]; then
            error "conda update failed, use '--offline' mode please if you don't want to update to the latest version" && return 1
          fi
        fi
      fi
      info "add conda channels: conda config --add channels conda-forge"
      conda config --add channels conda-forge

      env_test_name="venv-test"
      info "conda env create test: $env_test_name"
      create_args=""
      if [ "$_arg_offline" = "on" ]; then
        create_args="$create_args --offline"
      fi
      conda create $create_args -y -k -p "$(pwd)/$env_test_name" python=3
      info "conda env $env_test_name created"
      locate_and_activate_conda && conda activate "$(pwd)/$env_test_name"
      if [ $? -ne 0 ]; then
        error "conda env $(pwd)/$env_test_name activate failed, maybe there are some errors occurred, please check conda installed path, default is ${DEFAULT_INSTALL_PATH}, and environment path"
        return 1
      fi
      info "conda env $env_test_name activated"
      py_exec=$(which python3 2>/dev/null|| which python 2>/dev/null)
      info "venv-test version: $py_exec --version"
      info "conda env create test successful"
      conda deactivate
      info "removing conda env $env_test_name"
      conda remove -y -p "$(pwd)/$env_test_name" --all
      info "miniforge environment initialized, and you can use command `highlight "'conda create'"` to create a new python environment"
      return 0
    else
      return 1
    fi
  fi
}

main
# ^^^  TERMINATE YOUR CODE BEFORE THE BOTTOM ARGBASH MARKER  ^^^

# ] <-- needed because of Argbash
