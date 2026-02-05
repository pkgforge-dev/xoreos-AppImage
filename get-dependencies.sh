#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    boost      \
    boost-libs \
    cmake      \
    faad2      \
    libdecor   \
    libmad     \
    libvpx     \
    openal     \
    sdl2       \
    xvidcore

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of xoreos..."
echo "---------------------------------------------------------------"
REPO="https://github.com/xoreos/xoreos"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO" ./xoreos
echo "$VERSION" > ~/version

cd ./xoreos
patch -Np1 -i "../cmakeboost1.89-fix.patch"
mkdir -p build && cd build
cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -DCMAKE_INSTALL_PREFIX="/usr"
make -j$(nproc)
mv -v bin/xoreos /usr/bin
cp -rv ../dists/win32/xoreos.ico /usr/share/pixmaps/xoreos.ico
