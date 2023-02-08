#!/bin/bash

set -e

TARGET_ARCH=$1
if [ -z "$TARGET_ARCH" ]; then
    echo "No target architecture specified! Run the command as './build.sh <target_arch>'"
    exit 1
fi

if [ $TARGET_ARCH != "x64_64" ] && [ $TARGET_ARCH != "arm64" ]; then
  echo "Invalid system architecture for build. Supported architectures are 'x64_64' and 'arm64'"
fi

if test -f "ffmpeg.tar.xz"; then
    echo "'./ffmpeg.tar.xz' already found. Reusing it!"
else
    echo "Downloading ffmpeg sources..."
    curl -o ffmpeg.tar.xz https://ffmpeg.org/releases/ffmpeg-5.1.2.tar.xz
fi

if [ -d "./ffmpeg" ]; then
    echo "'./ffmpeg' already found. Cleaning and reusing it!"
    cd ffmpeg/
    make distclean
else
    echo "Extracing ffmpeg sources..."
    mkdir ffmpeg/
    tar -xf ffmpeg.tar.xz --strip-components=1 -C ffmpeg
    cd ffmpeg/
fi

# Configure
echo "Configuring FFmpeg to build for $TARGET_ARCH"
ARGS="--prefix=./dist_$TARGET_ARCH --enable-static --disable-shared --enable-pthreads --enable-version3 --enable-ffplay --enable-gnutls --enable-gpl --enable-libaom --enable-libaribb24 --enable-libbluray --enable-libdav1d --enable-libmp3lame --enable-libopus --enable-librav1e --enable-librist --enable-librubberband --enable-libsnappy --enable-libsrt --enable-libsvtav1 --enable-libtesseract --enable-libtheora --enable-libvidstab --enable-libvmaf --enable-libvorbis --enable-libvpx --enable-libwebp --enable-libx264 --enable-libx265 --enable-libxml2 --enable-libxvid --enable-lzma --enable-libfontconfig --enable-libfreetype --enable-frei0r --enable-libass --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libopenjpeg --enable-libspeex --enable-libsoxr --enable-libzmq --enable-libzimg --disable-libjack --disable-indev=jack --enable-videotoolbox"
if [ $TARGET_ARCH != "x64_64" ]; then
    ARGS="$ARGS --enable-neon"
elif [ $TARGET_ARCH != "arm64" ]; then
    ARGS="$ARGS --enable-cross-compile --arch=arm64 --cc='clang -arch arm64'"
else
    echo "unreachable!()"
    exit 1;
fi

./configure $ARGS

# Build
echo "Building FFmpeg for $TARGET_ARCH"
make build

# Install (to --prefix dir)
make install

# Cleanup
echo "Cleanup"
cd ../
rm ffmpeg.tar.xz
