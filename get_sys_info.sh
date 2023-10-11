#!/usr/bin/env bash

# macos 获取cpu芯片信息
# sysctl 'machdep.cpu.brand_string'
# apple M1/2 [Pro|Max]：grep -ioE 'Apple M\d{1}.*((Pro)?|(Max)?)'
# intel x86: grep -ioE 'Intel.*Core.*(i[3579])-\d+.*CPU'

# macos 获取cpu架构信息
# uname -a | awk -F " " '{print $(NF-1)}' | grep  -ioE '(arm(32|64))|(aarch(32|64))|(x86(([_-]{1}(32|64))|(.{0})))|(amd(32|64))|(i386)'

# linux获取架构信息
# lscpu | head -n 1 | awk '/[:：]/ {print $2}'
# output maybe: aarch64, x86_64

get_sys_info() {
  # 使用uname命令来获取系统信息
  # Parse the OS name and architecture from `uname`.
  os_type="$(uname | sed 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/')"
  os_arch="$(uname -m)"
  # When running inside Git bash on Windows, `uname` reports "MINGW64_NT".
  case $os_type in mingw64_nt* | msys_nt*)
    os_type="windows"
    ;;
  esac
  # then judge $os_type, such as 'darwin', 'win', 'linux'
  case "$os_type" in
    darwin*)
      os_type="MacOSX"
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
    win*)
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

get_sys_info

