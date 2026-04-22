#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    boost       \
    boost-libs  \
    cmake       \
    faad2       \
    glew        \
    libmad      \
    libvpx      \
    openal      \
    sdl2-compat \
    xvidcore

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

echo "Building xoreos..."
echo "---------------------------------------------------------------"
REPO="https://github.com/xoreos/xoreos"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO" ./xoreos
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cmake -S ./xoreos -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5
cmake --build build -j$(nproc)
mv -v build/bin/xoreos ./AppDir/bin
