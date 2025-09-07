#!/usr/bin/env bash
set -e

if [ -z "${ANDROID_NDK}" ]; then
  echo "ANDROID_NDK environment variable not set" >&2
  exit 1
fi

ABIS=("arm64-v8a" "armeabi-v7a" "x86" "x86_64")
if [ "$#" -gt 0 ]; then
  ABIS=("$@")
fi
API_LEVEL=21

for ABI in "${ABIS[@]}"; do
  BUILD_DIR="build/android/${ABI}"
  cmake -B "$BUILD_DIR" \
    -DCMAKE_TOOLCHAIN_FILE="${ANDROID_NDK}/build/cmake/android.toolchain.cmake" \
    -DANDROID_ABI="${ABI}" \
    -DANDROID_PLATFORM="android-${API_LEVEL}" \
    -DANDROID_STL="c++_shared" \
    -DGGML_AVX=OFF -DGGML_AVX2=OFF -DGGML_FMA=OFF -DGGML_F16C=OFF \
    -DCMAKE_BUILD_TYPE=Release
  cmake --build "$BUILD_DIR" --target whisper-jni -j$(nproc)
  echo "Built ${BUILD_DIR}/libwhisper-jni.so"
  echo
  sleep 1

done
