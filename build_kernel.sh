#!/bin/bash

CLANG_BIN="${PWD}/toolchain/clang/bin"
GCC_BIN="${PWD}/toolchain/gcc/bin"

# check for toolchain dir
if [ ! -d "$CLANG_BIN" ] || [ ! -d "$GCC_BIN" ]; then
  echo "[BUILD]: Toolchain not found.."
  echo "[BUILD]: Run ./resolv_toolchain_linux.sh to resolve toolchain"
  exit 1
else
  echo "[BUILD]: Toolchain found.."
fi


function K_MAKE() {
  local options=$*
  
  echo
  echo "[K_MAKE]: $options"
  sleep 1
  
  ANDROID_MAJOR_VERSION=s \
  PLATFORM_VERSION=12 \
  make O=out ARCH=arm64 $options
}

K_MAKE mrproper
K_MAKE clean
K_MAKE exynos9610-m31snsxx_defconfig
K_MAKE -j$(nproc --all)

# AIK pack
echo "[BUILD]: AIK pack.."

cp -rv ./out/arch/arm64/boot/Image ./AnyKernel3/Image || exit 1

cd AnyKernel3 || exit 1
TIMESTAMP=$(date +"%Y-%m-%dT%H-%M-%S")
zip -r "../SM-M317F_kernel_${TIMESTAMP}.zip" * -x .git README.md '*placeholder'
cd .. || exit 1
