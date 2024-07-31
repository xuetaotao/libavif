# Copyright 2022 Google LLC
# SPDX-License-Identifier: BSD-2-Clause

cmake_minimum_required(VERSION 3.22.1)

project(avif_android_jni)

# Perform a static build of libavif and link it with the jni shared library so
# that we end up with a single libavif_android.so file in the end.
#
# By default, we build libavif with libgav1 as the AV1 decoder. To change that
# behavior, set up the android builds for the desired decoder and change the
# variables below accordingly.

# To override the variables in the libavif subproject:
# https://stackoverflow.com/questions/3766740/overriding-a-default-option-value-in-cmake-from-a-parent-cmakelists-txt
set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)

# To disable dav1d, change the following two variables to OFF.
# dav1d是一个开源的AV1视频解码器，由AOM赞助VideoLAN和FFmpeg社区开发。它主要用于将AV1码流解码为YUV图像，适用于视频聊天、视频直播、视频点播等互联网视频流应用场景。
# dav1d能够将输入的AV1码流解码为YUV图像。
# 为支持Android15 16KB的内存页面大小，需要使用NDK27+，但是使用后/Users/XXX/Library/Android/sdk/ndk/27.0.12077973/toolchains/llvm/prebuilt/darwin-x86_64/bin目录下
# 最低为i686-linux-android21-clang，所以会报错如下：没有解决。
# 如使用NDK 25.2.9519653 则没有这个问题。
# TODO：Running `i686-linux-android19-clang --version` gave "[Errno 2] No such file or directory: 'i686-linux-android19-clang'"
# 因为暂时没有视频解码需求，而且希望包体积尽可能小，故而暂时 disable dav1d 和 下面的 libyuv。
#set(AVIF_CODEC_DAV1D "LOCAL" CACHE STRING "" FORCE)
set(AVIF_CODEC_DAV1D OFF CACHE BOOL "" FORCE)

# To disable libyuv, change this variable to OFF.
# libyuv是一个开源的图像处理库，由Google开发，主要用于处理YUV格式的图像数据。
# YUV的应用场景：主要应用于视频处理，特别是在需要高效压缩视频流时。
#set(AVIF_LIBYUV "LOCAL" CACHE STRING "" FORCE)
set(AVIF_LIBYUV OFF CACHE BOOL "" FORCE)

# To enable libgav1, change the following two variables to ON.
# libgav1是谷歌开发的开源AV1视频解码器，主要用于Android系统中处理AV1格式的视频数据。它支持硬件加速，以提升性能和降低功耗。
set(AVIF_CODEC_LIBGAV1 OFF CACHE BOOL "" FORCE)

# The current CMake file lives in:
# $LIBAVIF_ROOT/android_jni/avifandroidjni/src/main/jni.
# In order to build libavif, we need to go up 5 directories. If a different
# libavif checkout is to be used, this path has to be updated accordingly.
add_subdirectory(../../../../.. build)

add_library("avif_android" SHARED "libavif_jni.cc")

# Import the cpu-features module to compute the number of threads used for
# decoding.
include(AndroidNdkModules)
android_ndk_import_module_cpufeatures()

target_link_libraries(avif_android jnigraphics avif log cpufeatures)
