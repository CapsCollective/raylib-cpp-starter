# Set general macros
buildFile = build/app

# Check for Windows
ifeq ($(OS), Windows_NT)
	# Set Windows macros
	platform = Windows
	compiler = g++
	options = -pthread -lopengl32 -lgdi32 -lwinmm -mwindows
	sources = src/main.cpp
	THEN = &&
else
	# Check for MacOS/Linux
	UNAMEOS = $(shell uname)
	ifeq ($(UNAMEOS), Linux)
		# Set Linux macros
		platform = Linux
		compiler = g++
		options = -l GL -l m -l pthread -l dl -l rt -l X11
		libGenDirectory = # Empty
	endif
	ifeq ($(UNAMEOS), Darwin)
		# Set macOS macros
		platform = macOS
		compiler = clang++
		options = -framework CoreVideo -framework IOKit -framework Cocoa -framework GLUT -framework OpenGL
		libGenDirectory = src
	endif

	# Set UNIX macros
	sources = $(shell find src -type f -name '*.cpp')
	THEN = ;
endif

# Explicitly set compiler to platform default if unset
ifeq ($(CXX),)
	CXX = $(compiler)
endif

# Lists phony targets for Makefile
.PHONY: all setup submodules compile execute clean

# Default target, compiles, executes and cleans
all: compile execute clean

# Sets up the project for compiling, generates includes and libs
setup: include lib

# Pull and update the the build submodules
submodules:
	git submodule update --init --recursive

# Copy the relevant header files into includes
include: submodules
ifeq ($(platform), Windows)
	-mkdir .\include
	-robocopy "vendor\raylib-cpp\vendor\raylib\src" "include" raylib.h raymath.h
	-robocopy "vendor\raylib-cpp\include" "include" *.hpp
else
	mkdir -p include
	cp vendor/raylib-cpp/vendor/raylib/src/raylib.h vendor/raylib-cpp/vendor/raylib/src/raymath.h include
	cp vendor/raylib-cpp/include/*.hpp include
endif

# Build the raylib static library file and copy it into lib
lib: submodules
	cd vendor/raylib-cpp/vendor/raylib/src $(THEN) "$(MAKE)" PLATFORM=PLATFORM_DESKTOP
ifeq ($(platform), Windows)
	-mkdir lib\$(platform)
	-robocopy "vendor\raylib-cpp\vendor\raylib\src" "lib\Windows" libraylib.a
else
	mkdir -p lib/$(platform)
	cp vendor/raylib-cpp/vendor/raylib/$(libGenDirectory)/libraylib.a lib/$(platform)/libraylib.a
endif

# Create the build folder
build:
ifeq ($(platform), Windows)
	-mkdir build
else
	mkdir -p build
endif

# Create the build folder and compile the executable
compile: build
	$(CXX) -std=c++17 -I include -L lib/$(platform) $(sources) -o $(buildFile) -l raylib $(options)

# Run the executable
execute:
	$(buildFile)

# Clean up all relevant files
clean:
ifeq ($(platform), Windows)
	-del build\app.exe
else
	rm $(buildFile)
endif
