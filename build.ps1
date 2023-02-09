if (Test-Path("ffmpeg.tar.xz")) {
    Write-Host "'./ffmpeg.tar.xz' already found. Reusing it!"
} else {
    Invoke-WebRequest "https://ffmpeg.org/releases/ffmpeg-5.1.2.tar.xz" -OutFile "ffmpeg.tar.xz"

}

if (Test-Path -Path "ffmpeg") {
    Write-Host "'./ffmpeg' already found. Cleaning and reusing it!"
    cd ffmpeg
    make distclean
} else {
    Write-Host "Extracing ffmpeg sources..."
    mkdir ffmpeg
    tar -xf ffmpeg.tar.xz --strip-components=1 -C ffmpeg
    cd ffmpeg
}

# Configure
echo "Configuring FFmpeg"
./configure # TODO: Setup args

# Build
echo "Building FFmpeg"
make build

# Install (to --prefix dir)
make install

# Cleanup
Write-Host "Cleanup"
cd ../
rm ffmpeg.tar.xz