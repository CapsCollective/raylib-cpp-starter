# Raylib C++ Starter
The Raylib C++ Starter kit is a template project that provides a simple starter template for the [raylib tools](https://github.com/raysan5/raylib) game tools library using the [raylib-cpp](https://github.com/robloach/raylib-cpp) C++ bindings. The C++ headers link to a static library file of raylib (contained in `/lib/`) which should be built and replaced on a per-platform basis (lib for macOS 10.9.x is included).

## Getting Started
Download the [raylib](https://github.com/raysan5/raylib) repository and generate a static library file (`.a` on UNIX-based systems) using the [build and installation instructions](https://github.com/raysan5/raylib#build-and-installation) in the repository README.

Clone this repository and move the `libraylib.a` file you just generated into the `/lib/` directory (go ahead and replace the one included if necessary), and then run the following command for the Makefile:
```bash
make all
```
All build instructions are specified in the Makefile - no smoke and mirrors!
