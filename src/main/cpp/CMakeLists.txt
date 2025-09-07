cmake_minimum_required(VERSION 3.10)

project(whisper-jni-android LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Disable x86-specific optimizations for Android builds
set(GGML_AVX OFF CACHE BOOL "" FORCE)
set(GGML_AVX2 OFF CACHE BOOL "" FORCE)
set(GGML_FMA OFF CACHE BOOL "" FORCE)
set(GGML_F16C OFF CACHE BOOL "" FORCE)
set(GGML_STATIC ON CACHE BOOL "" FORCE)
set(GGML_OPENMP OFF CACHE BOOL "" FORCE)
set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
set(WHISPER_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(WHISPER_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)

set(NATIVE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../native)

add_subdirectory(${NATIVE_DIR}/whisper ${CMAKE_BINARY_DIR}/whisper)

add_library(whisper-jni SHARED
    ${NATIVE_DIR}/io_github_givimad_whisperjni_WhisperJNI.cpp
    ${NATIVE_DIR}/whisper/examples/grammar-parser.cpp
)

target_include_directories(whisper-jni PUBLIC
    ${NATIVE_DIR}
    ${NATIVE_DIR}/whisper/include
    ${NATIVE_DIR}/whisper/examples
)

target_link_libraries(whisper-jni
    whisper
    ggml
    log
)
