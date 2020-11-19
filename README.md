# Raylib C++ Starter
The Raylib C++ Starter kit is a template project that provides a simple starter template for the [raylib](https://github.com/raysan5/raylib) game tools library using the [raylib-cpp](https://github.com/robloach/raylib-cpp) C++ bindings. The C++ headers link to a static library file of raylib which should be built and replaced on a per-platform basis (one for macOS 10.9.x is included).

### Current Compatability

| OS          | Default Compiler | Working |
| ----------- | ---------------- |:-------:|
| **macOS**   | Clang++          | ✅      |
| **Linux**   | G++              | ❌      |
| **Windows** | MinGW            | ❌      |

## Getting Started
1. Download the [raylib](https://github.com/raysan5/raylib) repository and generate a static library file (`.a` on UNIX-based systems and `.lib` on Windows) using the [build and installation instructions](https://github.com/raysan5/raylib#build-and-installation) in the repository README.

2. Clone this repository and move the static library file you just generated into the `/lib` directory (go ahead and replace the one included if necessary), and then run the following command for the Makefile in the root directory:
```bash
$ make all
```

3. Enjoy! You can now start programming your game in `src/main.cpp`.

### Notes

This project currently only supports the Clang compiler. 

If you wish to change the program entry point, add more libraries, or really anything about your project, all build instructions are specified in the `Makefile` - no smoke and mirrors!
