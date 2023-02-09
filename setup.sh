#!/bin/bash

set -e

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Install dependencies for build"
    cargo install cargo-c

    echo "Clone"
    git clone https://github.com/xiph/rav1e.git
    cd rav1e/

    echo "Checkout"
    git checkout v0.6.3

    echo "Build"
    cargo build --release

    echo "Cinstall"
    mkdir /usr/local/lib/pkgconfig
    chown -R $USER:$USER /usr/local/lib/pkgconfig
    cargo cinstall --release

    cd ../
elif [[ $OSTYPE == 'darwin'* ]]; then
    # Brew has the wrong version so we build from scratch
    echo "Clone"
    git clone https://github.com/Haivision/srt.git
    cd srt/
    git checkout v1.3.0

    echo "Configure"
    export OPENSSL_ROOT_DIR=$(brew --prefix openssl)
    export OPENSSL_LIB_DIR=$(brew --prefix openssl)"/lib"
    export OPENSSL_INCLUDE_DIR=$(brew --prefix openssl)"/include"
    ./configure

    echo "Build"
    make
    make install

    cd ../
fi