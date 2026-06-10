# Samsung Galaxy M31s (SM-M317F) kernel source

## Setup

Using a `ubuntu:24:04` docker image

```
docker run -it --name kernel-builder ubuntu:24.04

# To use an existing container
docker start kernel-builder && docker exec -it kernel-builder bash
```

Install dependencies

```
apt update

apt install -y python3 python-is-python3 bc bison build-essential binutils-aarch64-linux-gnu ccache wget curl flex git liblz4-tool libssl-dev lzop rsync zip zlib1g-dev libncurses-dev

wget http://security.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2ubuntu0.1_amd64.deb

apt install ./libtinfo5_6.3-2ubuntu0.1_amd64.deb
```

Get the code

```
git clone https://github.com/ssxv/samsung-m31s-kernel.git
```

Prepare toolchains

```
cd /samsung-m31s-kernel/

mkdir toolchain

cd toolchain/
```
```
# clang ============

wget https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/android-9.0.0_r1/clang-4691093.tar.gz

mkdir -p clang && tar -xf clang-4691093.tar.gz -C clang

rm clang-4691093.tar.gz
```
```
# gcc ===============

git clone --depth=1 --filter=blob:none -b pie-release https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 gcc

cd gcc/bin

ln -s aarch64-linux-android-elfedit aarch64-linux-androidkernel-elfedit

ln -s aarch64-linux-android-as aarch64-linux-gnu-as
```

Setup AnyKernel

```
cd /samsung-m31s-kernel/
git clone --branch samsung-m31s --single-branch https://github.com/ssxv/AnyKernel3
```

Run the script

```
cd /samsung-m31s-kernel/
./build_kernel.sh
```

## Output

Kernel flashable zip should be generated in `/samsung-m31s-kernel` dir

```
SM-M317F_kernel_2026-06-10T22-21-24.zip
```

Install it with TWRP.

## Other ways to build

```
export PLATFORM_VERSION=12
export ANDROID_MAJOR_VERSION=s

make O=out ARCH=arm64 CONFIG_SECTION_MISMATCH_WARN_ONLY=y CONFIG_DEBUG_SECTION_MISMATCH=y exynos9610-m31snsxx_defconfig

make O=out ARCH=arm64 CONFIG_SECTION_MISMATCH_WARN_ONLY=y CONFIG_DEBUG_SECTION_MISMATCH=y menuconfig

make O=out ARCH=arm64 CONFIG_SECTION_MISMATCH_WARN_ONLY=y CONFIG_DEBUG_SECTION_MISMATCH=y -j22

make O=out ARCH=arm64 CONFIG_SECTION_MISMATCH_WARN_ONLY=y CONFIG_DEBUG_SECTION_MISMATCH=y mrproper

make O=out ARCH=arm64 CONFIG_SECTION_MISMATCH_WARN_ONLY=y CONFIG_DEBUG_SECTION_MISMATCH=y clean
```

## Linux kernel Docs

This file was moved to Documentation/admin-guide/README.rst

Please notice that there are several guides for kernel developers and users.
These guides can be rendered in a number of formats, like HTML and PDF.

In order to build the documentation, use `make htmldocs` or `make pdfdocs`.

There are various text files in the Documentation/ subdirectory,
several of them using the Restructured Text markup notation.
See Documentation/00-INDEX for a list of what is contained in each file.

Please read the Documentation/process/changes.rst file, as it contains the
requirements for building and running the kernel, and information about
the problems which may result by upgrading your kernel.
