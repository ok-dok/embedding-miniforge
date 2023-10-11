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

eval $(bash get_sys_info.sh)

DEFAULT_INSTALL_PATH="$HOME/miniforge"

install_on_windows() {
  local pkgexe=""
  if [ "$_arg_offline" = "on" ]; then
    pkgexe=$(ls miniconda | grep -ioE "Miniconda3-latest-${OS_TYPE}-${OS_ARCH}.*\.exe")
  else
    pkgexe=$(curl -k -ssL https://repo.anaconda.com/miniconda/ | grep -ioE '<a href="Miniconda3-latest.*">' | grep -ioE "Miniconda3-latest-${OS_TYPE}-${OS_ARCH}.*\.exe")
    [ $? != 0 ] && error "can not access the internet, please check your network status and make sure you can access the internet and try again, or you can use '--offline' mode that won't use internet."
  fi
  if [ "$pkgexe" = "" ]; then
    error "can not find a suitable version of miniconda. you can visit web site \"https://repo.anaconda.com/miniconda/\" to download the suitable miniconda version and install it by manual" && return 1
  fi
  if [ ! -e "miniconda/$pkgexe" ]; then
    info "downloading conda executable file: https://repo.anaconda.com/miniconda/$pkgexe"
    mkdir -p miniconda && curl -k -L "https://repo.anaconda.com/miniconda/$pkgexe" -o "miniconda/$pkgexe"
  else
    info "using cached package: miniconda/$pkgexe"
  fi
  info "installing conda"
  if [ "$_arg_yes" = "on" ]; then
    cmd //C "start /wait miniconda/$pkgexe /InstallationType=JustMe /AddToPath=1 /RegisterPython=1 /S /D=${DEFAULT_INSTALL_PATH}"
  else
    "miniconda/$pkgexe"
  fi
  return $?
}

install_on_linux_or_macos(){
  local latest_url=$(curl -kis --max-redirs 1 https://github.com/conda-forge/miniforge/releases/latest | grep location | awk -F ': ' '{print $2}')
  local latestTag=
  local pkgsh=$(curl -sk $latest_url | grep -ioE '<a href="/conda-forge/miniforge/releases/download/.*">' | grep -ioE "Miniforge3-${OS_TYPE}-${OS_ARCH}.*\.sh")
  if [ ! -e "miniconda/$pkgsh" ]; then
    info "downloading conda executable file: https://repo.anaconda.com/miniconda/$pkgsh"
    mkdir -p miniconda && curl -k -L "https://repo.anaconda.com/miniconda/$pkgsh" -o "miniconda/$pkgsh"
  else
    info "using cached package: miniconda/$pkgsh"
  fi
  info "installing conda"
  _run_args=""
  if [ "$_arg_force" = "on" ]; then
    _run_args="$_run_args -f"
  fi
  if [ "$_arg_yes" = "on" ]; then
    _run_args="$_run_args -b -p ${DEFAULT_INSTALL_PATH}"
  fi
  info "running install script: bash miniconda/$pkgsh $_run_args"
  bash "miniconda/$pkgsh" $_run_args
  return $?
}

locate_conda_path(){
    case "$OS_TYPE" in
      macos*|linux*)
        CONDA_PATH=$(dirname $(which conda 2>/dev/null) 2>/dev/null)
        if [ $? != 0 ]; then
          if ls "${DEFAULT_INSTALL_PATH}/bin/" >/dev/null 2>&1; then
            CONDA_PATH="${DEFAULT_INSTALL_PATH}/bin" && return 0
          else
            return 1
          fi
        fi
        ;;
      win*)
        CONDA_PATH=$(dirname $(which conda 2>/dev/null) 2>/dev/null)
        if [ $? != 0 ]; then
          menu_dir=$(ls "$HOME/AppData/Roaming/Microsoft/Windows/Start Menu/Programs" | grep -i "anaconda")
          lnk_name=$(ls "$HOME/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/$menu_dir/" | grep -vi "powershell" | grep -ioE ".*\.lnk")
          lnk_file="$HOME/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/$menu_dir/$lnk_name"
          if [ "$lnk_name" = "" ] || [ ! -e "$lnk_file" ]; then
              warn "cannot find the miniconda startup lnk file in Start Menu" && return 1
          fi
          CONDA_PATH=$("$(pwd)/bin/lnkparse.exe" "$HOME/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/$menu_dir/$lnk_name" | awk -F' ' '{print $3"\\Scripts"}')
          if [ $? != 0 ]; then
              warn "cannot get the installed path of Miniconda or Anaconda" && return 1
          fi
        fi
      ;;
    esac
    return $?
}

install_conda() {
  if [ "$OS_TYPE" = "" ] || [ "$OS_ARCH" = "" ]; then
    error "cannot detected your system version info" && return 1
  fi
  info "detected system info, OS_TYPE: $OS_TYPE, OS_ARCH: $OS_ARCH"
  # get miniconda3 install package
  shopt -s nocasematch
  case "$OS_TYPE" in
    macosx*|linux*)
      install_on_linux_or_macos || return $?
      info "conda init"
      locate_conda_path
      if [ $? != 0 ]; then
          error "cannot get the installed path of miniconda, you can restart your terminal and run \"$0 -i\" to init and test conda" && return 1
      fi
      . "$CONDA_PATH/activate"
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
      locate_conda_path
      if [ $? != 0 ]; then
          error "cannot get conda install path, you can restart your terminal and run \"$0 -i\" to init & test conda" && return 1
      fi
      . "${CONDA_PATH}\activate"
      return $?
      ;;
  esac
  shopt -u nocasematch
}

check_and_install_conda() {
  # 非强制情况下检查conda(forge)环境
  if [ "$_arg_force" = "off" ]; then
    info "checking conda environment..."
    locate_conda_path
    if [ $? == 0 ]; then
      conda_exec="${CONDA_PATH}/conda"
      info "located conda executable program: $conda_exec\n conda version: `highlight "$(conda --version)"`" && return 0
    else
      info "there is no conda environment"
    fi
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
    install_conda && info "conda installed, version: $(bash -c 'conda --version')" && return 0 || error "conda install failed" && return 1
  else
    warn "conda installing canceled, you can install it manual or rerun this script" && return 1
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
      conda_exec=$(which conda 2>/dev/null)
      if [ $? != 0 ]; then
        error "conda test failed, please reopen your terminal and run '$0'" && return 1
      fi
      if [ "$_arg_offline" = "off" ]; then
        if "$_arg_update" = "on" ]; then
          update_yes=""
          if [ "$_arg_yes" = "on" ]; then
            update_yes="-y"
          fi
          info "updating conda to the latest version"
          conda update $update_yes -n base -c defaults conda
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
      . "$(dirname $conda_exec)/activate"
      conda activate "$(pwd)/$env_test_name"
      info "conda env $env_test_name activated"
      py_exec=$(which python3 2>/dev/null|| which python 2>/dev/null)
      $py_exec --version
      info "conda env create test successful"
      conda deactivate
      info "removing conda env $env_test_name"
      conda remove -y -p "$(pwd)/$env_test_name" --all
      info "miniconda environment initialized, and you can use command `highlight "'conda create'"` to create a new python environment"
      return 0
    else
      return 1
    fi
  fi
}

get_sys_info

main
# ^^^  TERMINATE YOUR CODE BEFORE THE BOTTOM ARGBASH MARKER  ^^^

# ] <-- needed because of Argbash
