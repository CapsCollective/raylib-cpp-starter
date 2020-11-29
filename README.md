# Raylib C++ Starter
The Raylib C++ Starter kit is a template project that provides a simple starter template for the [raylib](https://github.com/raysan5/raylib) game tools library incorporating the [raylib-cpp](https://github.com/robloach/raylib-cpp) C++ bindings and using [Make](https://www.gnu.org/software/make/) for building. The starter kit can automatcially clone down raylib and the bindings, compile them, and setup the project for build using a static library.

> Why static linking?

One of the most absurdly annoying things about C++ development is finding and linking dynamic libraries. The raylib project prides itself on having **"NO external dependencies"**, and we tend to agree that portability is way cooler than saving that fraction of a second on compile-time.

> Why not just use CMake?

I guess we just don't want the added headache. CMake is complex and sometimes feels like some *arcane magic* that we generally take for granted in build systems. If you look at the raylib library, yes it has CMake support, but it generally encourages the use of Make on all platforms because as the library reads:

> raylib is a programming library to enjoy videogames programming; no fancy interface, no visual helpers, no auto-debugging... just coding in the most pure spartan-programmers way

So that being said, we hope that this repository finds you well and wholeheartedly enjoying the *simple things in life* (i.e. video games programming).

### Current Compatibility
| OS          | Default Compiler |  Last Manual Build  |  Compile Status  |
| ----------- | ---------------- | ------------------- | ---------------- |
| **macOS**   | Clang++          | `Big Sur 11.0.1`    | ![macOS Status](https://github.com/CapsCollective/raylib-cpp-starter/workflows/macOS/badge.svg) |
| **Linux**   | G++              | `Ubuntu 20.04 LTS`  | ![Linux Status](https://github.com/CapsCollective/raylib-cpp-starter/workflows/Ubuntu/badge.svg) |
| **Windows** | MinGW (G++)      | `Windows 10 19041`  | ![Windows Status](https://github.com/CapsCollective/raylib-cpp-starter/workflows/Windows/badge.svg) |

## Getting Started

### Installing Dependencies

Before building the project, you will need to install all relevant dependencies for your platform so that the project has access to all the tools required, and raylib can compile and link correctly. You can find intructions for installing dependencies on macOS, Linux, and Windows in the [docs file on installing dependencies](https://github.com/CapsCollective/raylib-cpp-starter/blob/main/docs/InstallingDependencies.md).

### Building the Project
Once you have cloned this repository and installed dependencies, building the project is as simple as running these two commands in its root directory:

#### macOS & Linux
```console
$ make setup
$ make
```

#### Windows
```console
> mingw32-make setup
> mingw32-make
```

The first command will clone in the lastest C++ bindings and targeted version of raylib, copy across any relevant header files into `/includes`, and build a static library file from them, placing it in `/lib`. The second command then compiles, runs and cleans up your project using the source code in `/src/main.cpp`.

*If a window pops up, congratulations, you've successfully built the project and you can now start programming your game!*

## Using This Template
Now that you have the project setup and compiling on your system, it's time to start programming! If you aren't already familliar with [raylib](https://github.com/raysan5/raylib), we recommend looking over [this awesome cheatsheet](https://www.raylib.com/cheatsheet/cheatsheet.html) which lists every function, struct and macro available in the raylib C library. If you want specifics on how to use the C++ bindings, then you should check out the [raylib-cpp](https://github.com/robloach/raylib-cpp) repo, which nicely explains how the bindings work and contains [raylib's examples ported to C++](https://github.com/RobLoach/raylib-cpp/tree/master/examples).

Once you're up and running, we first of all recommend that all your code for the game should go into the `/src` directory, which is automatically included in the compile process when you run Make. The default entry point for the program is `/src/main.cpp` (which is pretty standard). If you wish to change the program entry point, add more libraries, or really anything about your project, all build instructions are specified in the `Makefile` - no smoke and mirrors!

### Specifying a Non-Default Compiler
If you want to use a compiler for your platform that isn't the default for your system (or potentially you would like to explicitly state it), you can make use of the system-implicit `CXX` variable like so:

#### macOS & Linux

```console
$ make CXX=g++
```

#### Windows

```console
> mingw32-make CXX=g++
```

### Locking the Raylib Version

*this functionality is currently in testing*

## Contributing

### How do I contribute?
It's pretty simple actually:

1. Fork it from [here](https://github.com/CapsCollective/raylib-cpp-starter/fork)
2. Create your feature branch (git checkout -b cool-new-feature)
3. Commit your changes (git commit -m "Added some feature")
4. Push to the branch (git push origin cool-new-feature)
5. Create a new pull request for it!

### Contributors
- [J-Mo63](https://github.com/J-Mo63) Jonathan Moallem - co-creator, maintainer
- [Raelr](https://github.com/Raelr) Aryeh Zinn - co-creator, maintainer

## Licence

This project is licenced under an unmodified zlib/libpng licence, which is an OSI-certified, BSD-like licence that allows static linking with closed source software. Check `LICENCE` for further details.
