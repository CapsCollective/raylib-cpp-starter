# Raylib C++ Starter
The Raylib C++ Starter kit is a template project that provides a simple starter template for the [raylib](https://github.com/raysan5/raylib) game tools library incorporating the [raylib-cpp](https://github.com/robloach/raylib-cpp) C++ bindings and using [Make](https://www.gnu.org/software/make/) for building. The C++ headers link to a static library file of raylib which should be built and replaced on a per-platform basis (recent builds are also included).

> Why static linking?

One of the most absurdly annoying things about C++ development is finding and linking dynamic libraries. The raylib project prides itself on having **"NO external dependencies"**, and we tend to agree that portability is way cooler than saving that fraction of a second on compile-time.

> Why not just use CMake?

I guess we just don't want the added headache. CMake is complex and sometimes feels like some *arcane magic* that we generally take for granted in build systems. If you look at the raylib library, yes it has CMake support, but it generally encourages the use of Make on all platforms because as the library reads:

> raylib is a programming library to enjoy videogames programming; no fancy interface, no visual helpers, no auto-debugging... just coding in the most pure spartan-programmers way

So that being said, we hope that this repository finds you well and wholeheartedly enjoying the *simple things in life* (i.e. video games programming).

### Current Compatability
| OS          | Default Compiler |   Last Tested On   | Working |
| ----------- | ---------------- | ------------------ |:-------:|
| **macOS**   | Clang++          | `Big Sur 11.0.1`   | ✅      |
| **Linux**   | G++              | `Ubuntu 20.04 LTS` | ❌      |
| **Windows** | MinGW            | `Windows 10 19041` | ✅      |

## Getting Started

### Installing Dependencies

#### Installing MinGW (Windows only)
Building raylib libraries requires the installation of MinGW ([32](http://www.mingw.org/) and [64](http://mingw-w64.org/doku.php/download) bit versions). Please ensure that you link MinGW's `bin` directory to your system environment variables for BOTH the 32 and 64 bit versions. You can follow the instructions here for the [32-bit](https://www.youtube.com/watch?v=sXW2VLrQ3Bs) and here for the [64-bit](https://code.visualstudio.com/docs/cpp/config-mingw) bit versions.

After installing MinGW, you should have G++ installed. You can verify this by running:
```console
> g++ --version
g++ (x86_64-posix-seh-rev0, Built by MinGW-W64 project) 8.1.0
```

#### Installing G++ & Make (Linux only)
Some Linux distributions do not come preinstalled with the basic build tools required to do C/C++ development. In the case that you do not have them, you can install them all with one very handy meta-package aptly named `build-essential` using the following two commands:
```console
$ sudo apt update
$ sudo apt install build-essential
```

After installing the package, you should have both G++ and Make installed. You can verify this by running:
```console
$ g++ --version
g++ (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0

$ make --version
GNU Make 4.2.1
Built for x86_64-pc-linux-gnu
```

#### Installing ALSA, Mesa & X11 (Linux only)
On Linux, raylib is reliant on a number of libraries for audio, graphics, and windowing that may not come preinstalled, these being ALSA, Mesa & X11 respecively. Fortunately they can all be easily installed through your distribution's package manager with just a few lines:

##### Debian/Ubuntu
```console
$ sudo apt-get update
$ sudo apt install libasound2-dev mesa-common-dev libx11-dev libxrandr-dev libxi-dev xorg-dev libgl1-mesa-dev libglu1-mesa-dev
```

##### Fedora
```console
$ dnf check-update
$ sudo dnf install alsa-lib-devel mesa-libGL-devel libX11-devel libXrandr-devel libXi-devel libXcursor-devel libXinerama-devel
```

### Building the Project

1. Download the [raylib](https://github.com/raysan5/raylib) repository and generate a static library file (`.a` on UNIX-based systems or `.lib` on Windows) using the [build and installation instructions](https://github.com/raysan5/raylib#build-and-installation) in the repository README.

2. Clone this repository and move the static library file you just generated into the `/lib/<platform>` directory (go ahead and replace the one included if necessary), and then run the following command for the Makefile in the project's root directory:

#### macOS & Linux
```console
$ make
```

#### Windows
```console
> mingw32-make
```

*If you see a window pop up then you've successfully setup the project!*

3. Enjoy! You can now start programming your game from `src/main.cpp`.

### Additional Notes

If you wish to change the program entry point, add more libraries, or really anything about your project, all build instructions are specified in the `Makefile` - no smoke and mirrors!

## Todo
- ~~Get static linking to work with C++ bindings~~
- Setup for at least one compiler on each platform
- Test with multiple compilers on each platform
- Add compiler specification options
- Add raylib-cpp as vendor for procedural builds and auto-updating
