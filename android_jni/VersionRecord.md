# libavif Android Version Record

初始NDK版本25编译(使用./gradlew assemble)成功后，将aar包集成到项目中，然后使用Glide可以在Android9～Android14版本上正确显示AVIF格式图片，但是在Android15上会闪退。


## versionName "1.0"
* 为支持Android15 16KB的内存页面大小，需要使用NDK27+，但是使用后/Users/XXX/Library/Android/sdk/ndk/27.0.12077973/toolchains/llvm/prebuilt/darwin-x86_64/bin目录下
* 最低为i686-linux-android21-clang，所以会报错如下：
* Running `i686-linux-android19-clang --version` gave "[Errno 2] No such file or directory: 'i686-linux-android19-clang'"
* 没有解决。
* 然后想到暂时没有视频解码需求，而且希望包体积尽可能小，故而暂时 disable 了CMakeLists.txt中的 dav1d 和 下面的 libyuv。然后成功编译出了aar包，集成到项目中
* 在Android15模拟器上测试没有闪退，并且可以正确显示AVIF格式图片，于是认为修改好了，就发版本了。


## versionName "1.1"
* 发现问题：使用1.0的aar包后，又在Android9上的机器测试发现，并不能正确显示AVIF格式图片。查阅资料后发现，Android 12及以上版本自动支持AVIF图片，所以1.0测试是OK的。
* 但是使用Android9的模拟器或者国内Android手机测试，就无法正确显示AVIF格式图片了。
* 所以应该是1.0版本disable 了CMakeLists.txt中的 dav1d 和 下面的 libyuv，导致功能缺失，因此先做了版本代码回退，然后另寻出路。