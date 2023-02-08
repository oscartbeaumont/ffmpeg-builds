#!/bin/bash

set -e

rm -rf ./ffmpeg # TODO: Remove
if [ -d "ffmpeg" ]; then
    echo "./ffmpeg directory exists. Please remove it and rerun!"
    exit 1
fi

if test -f "ffmpeg.tar.xz"; then
    echo "ffmpeg.tar.xz already found. Reusing it!"
else
    echo "Downloading ffmpeg sources..."
    curl -o ffmpeg.tar.xz https://ffmpeg.org/releases/ffmpeg-5.1.2.tar.xz
fi

echo "Extracing ffmpeg sources..."
mkdir ffmpeg
tar -xf ffmpeg.tar.xz --strip-components=1 -C ffmpeg

cd ffmpeg/


# M1 Build
./configure --enable-cross-compile --prefix=./install_x86_64 --arch=arm64 --cc='clang -arch arm64'
make build

# MAC_OS_ARGS="--enable-videotoolbox"
# MACOS_ARM_ARGS="--enable-neon"
# ./configure \
#     --enable-shared \
#     --enable-pthreads \
#     --enable-version3 \
#     --enable-ffplay \
#     --enable-gnutls \
#     --enable-gpl \
#     --enable-libaom \
#     --enable-libaribb24 \
#     --enable-libbluray \
#     --enable-libdav1d \
#     --enable-libmp3lame \
#     --enable-libopus \
#     --enable-librav1e \
#     --enable-librist \
#     --enable-librubberband \
#     --enable-libsnappy \
#     --enable-libsrt \
#     --enable-libsvtav1 \
#     --enable-libtesseract \
#     --enable-libtheora \
#     --enable-libvidstab \
#     --enable-libvmaf \
#     --enable-libvorbis \
#     --enable-libvpx \
#     --enable-libwebp \
#     --enable-libx264 \
#     --enable-libx265 \
#     --enable-libxml2 \
#     --enable-libxvid \
#     --enable-lzma \
#     --enable-libfontconfig \
#     --enable-libfreetype \
#     --enable-frei0r \
#     --enable-libass \
#     --enable-libopencore-amrnb \
#     --enable-libopencore-amrwb \
#     --enable-libopenjpeg \
#     --enable-libspeex \
#     --enable-libsoxr \
#     --enable-libzmq \
#     --enable-libzimg \
#     --disable-libjack \
#     --disable-indev=jack "$MAC_OS_ARGS" "$MACOS_ARM_ARGS"

# mkdir dist
# TODO: Move them into the dist dir
# TODO: GH Releases

rm ffmpeg.tar.xz
