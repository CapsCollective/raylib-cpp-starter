# Set general macros
buildFile = build/app
libGenDirectory = src

# Check for Windows
ifeq ($(OS), Windows_NT)
	# Set Windows compile macros
	platform = Windows
	compiler = g++
	options = -pthread -lopengl32 -lgdi32 -lwinmm -mwindows
else
	# Check for MacOS/Linux
	UNAMEOS = $(shell uname)
	ifeq ($(UNAMEOS), Linux)
		# Set Linux compile macros
		platform = Linux
		compiler = g++
		options = -l GL -l m -l pthread -l dl -l rt -l X11
		libGenDirectory = # Empty
	endif
	ifeq ($(UNAMEOS), Darwin)
		# Set macOS compile macros
		platform = macOS
		compiler = clang++
		options = -framework CoreVideo -framework IOKit -framework Cocoa -framework GLUT -framework OpenGL
	endif
endif

# Explicitly set compiler to platform default if unset
ifeq ($(CXX),)
	CXX = $(compiler)
endif

# Default target, compiles, executes and cleans
run: compile execute clean

# Lists phony targets for Make compile
.PHONY: run setup submodules compile execute clean

# Sets up the project for compiling, creates libs and includes
setup: include lib

# Pull and update the the build submodules
submodules:
	git submodule update --init --recursive

# Copy the relevant header files into includes
include: submodules
ifeq ($(platform), Windows)
	-mkdir .\include
	-robocopy "vendor\raylib-cpp\vendor\raylib\src" "include" raylib.h
	-robocopy "vendor\raylib-cpp\vendor\raylib\src" "include" raymath.h
	-robocopy "vendor\raylib-cpp\include" "include" *.hpp
else
	mkdir -p include
	cp vendor/raylib-cpp/vendor/raylib/src/raylib.h include/raylib.h
	cp vendor/raylib-cpp/vendor/raylib/src/raymath.h include/raymath.h
	cp vendor/raylib-cpp/include/*.hpp include
endif

# Build the raylib static library file and copy it into lib
lib: submodules
ifeq ($(platform), Windows)
	cd vendor/raylib-cpp/vendor/raylib/src && "$(MAKE)" PLATFORM=PLATFORM_DESKTOP
	-mkdir lib\$(platform)
	-robocopy "vendor\raylib-cpp\vendor\raylib\src" "lib\Windows" libraylib.a
else
	cd vendor/raylib-cpp/vendor/raylib/src; $(MAKE) PLATFORM=PLATFORM_DESKTOP
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
	$(CXX) -std=c++17 -I include -L lib/$(platform) src/main.cpp -o $(buildFile) -l raylib $(options)

# Run the executable
execute:
	$(buildFile)

# Clean up all relevant files
clean:
ifeq ($(platform), Windows)
	dir
	dir build
	erase build\*.exe
else
	rm $(buildFile)
endif
