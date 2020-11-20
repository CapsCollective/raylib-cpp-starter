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
| ----------- | ---------------- |:------------------:|:-------:|
| **macOS**   | Clang++          | `Big Sur 11.0.1`   | ✅      |
| **Linux**   | G++              | `Ubuntu 20.04 LTS` | ❌      |
| **Windows** | MinGW            | `N/A`              | ❌      |

## Getting Started
1. Download the [raylib](https://github.com/raysan5/raylib) repository and generate a static library file (`.a` on UNIX-based systems and `.lib` on Windows) using the [build and installation instructions](https://github.com/raysan5/raylib#build-and-installation) in the repository README.

2. Clone this repository and move the static library file you just generated into the `/lib` directory (go ahead and replace the one included if necessary), and then run the following command for the Makefile in the root directory:
```bash
$ make all
```

3. Enjoy! You can now start programming your game from `src/main.cpp`.

If you wish to change the program entry point, add more libraries, or really anything about your project, all build instructions are specified in the `Makefile` - no smoke and mirrors!

### Todo
- ~~Get static linking to work with C++ bindings~~
- Setup for at least one compiler on each platform
- Test with multiple compilers on each platform
- Add compiler specification options
- Add raylib-cpp as vendor for procedural builds and auto-updating
