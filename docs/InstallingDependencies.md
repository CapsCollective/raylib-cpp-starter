# Installing Dependencies

## macOS

### Installing Apple Developer Tools
To do anything of value in the later versions of macOS, you're going to need the Xcode developer tools. Fortunately, if you want to skip downloading the behemoth of an IDE, then you can just get the command line tools package with the following command:
```console
$ xcode-select --install
```

After installing the package, you should have Git (among other things) installed. You can verify this by running:
```console
$ git --version
git version 2.27.0
```

## Linux

### Installing Git
For the project build system to function correctly, you will need to have Git installed on your system if it isn't already (it's a good idea to have it anyway - take it from us). You can install it by running the following lines:

#### Debian/Ubuntu
```console
$ sudo apt update
$ sudo apt install git-all
```

#### Fedora
```console
$ sudo dnf check-update
$ sudo dnf install git-all
```

### Installing G++ & Make
Some Linux distributions do not come preinstalled with the basic build tools required to do C/C++ development. In the case that you do not have them and you're on a Debian-based system, you can install them all with one very handy meta-package aptly named `build-essential`. Otherwise if you're using Fedora, you can install them each individually. Run the following lines to install them:

#### Debian/Ubuntu
```console
$ sudo apt update
$ sudo apt install build-essential
```

#### Fedora
```console
$ sudo dnf check-update
$ sudo dnf install make automake gcc gcc-c++ kernel-devel
```

After installing the package, you should have both G++ and Make installed. You can verify this by running:
```console
$ g++ --version
g++ (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0

$ make --version
GNU Make 4.2.1
Built for x86_64-pc-linux-gnu
```

### Installing ALSA, Mesa & X11
On Linux, raylib is reliant on a number of libraries for audio, graphics, and windowing that may not come preinstalled, these being ALSA, Mesa & X11 respecively. Fortunately they can all be easily installed through your distribution's package manager with just a few lines:

#### Debian/Ubuntu
```console
$ sudo apt update
$ sudo apt install libasound2-dev mesa-common-dev libx11-dev libxrandr-dev libxi-dev xorg-dev libgl1-mesa-dev libglu1-mesa-dev
```

#### Fedora
```console
$ sudo dnf check-update
$ sudo dnf install alsa-lib-devel mesa-libGL-devel libX11-devel libXrandr-devel libXi-devel libXcursor-devel libXinerama-devel
```

## Windows

### Installing Git
For the project build system to function correctly, you will need to have Git installed on your system if it isn't already (it's a good idea to have it anyway - take it from us). You can install it by [downloading it from here](https://git-scm.com/download/win) and going through the setup wizard.

### Installing MinGW
Building raylib libraries requires the installation of MinGW ([32](http://www.mingw.org/) and [64](http://mingw-w64.org/doku.php/download) bit versions). Please ensure that you link MinGW's `bin` directory to your system environment variables for BOTH the 32 and 64 bit versions. You can follow the instructions here for the [32-bit](https://www.youtube.com/watch?v=sXW2VLrQ3Bs) and here for the [64-bit](https://code.visualstudio.com/docs/cpp/config-mingw) bit versions.

After installing MinGW, you should have G++ installed. You can verify this by running:
```console
> g++ --version
g++ (x86_64-posix-seh-rev0, Built by MinGW-W64 project) 8.1.0
```
