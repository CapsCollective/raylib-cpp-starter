# Define custom functions
rwildcard = $(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

# Set global macros
buildDir = bin
executable = app
target = $(buildDir)/$(executable)
sources = $(call rwildcard,src/,*.cpp)
objects = $(patsubst src/%, $(buildDir)/%, $(patsubst %.cpp, %.o, $(sources)))
compileFlags = -std=c++17 -I include
linkFlags = -L lib/$(platform) -l raylib

# Check for Windows
ifeq ($(OS), Windows_NT)
	# Set Windows macros
	platform = Windows
	CXX ?= g++
	linkFlags += -pthread -lopengl32 -lgdi32 -lwinmm -mwindows
	THEN = &&
else
	# Check for MacOS/Linux
	UNAMEOS = $(shell uname)
	ifeq ($(UNAMEOS), Linux)
		# Set Linux macros
		platform = Linux
		CXX ?= g++
		linkFlags += -l GL -l m -l pthread -l dl -l rt -l X11
	endif
	ifeq ($(UNAMEOS), Darwin)
		# Set macOS macros
		platform = macOS
		CXX ?= clang++
		linkFlags += -framework CoreVideo -framework IOKit -framework Cocoa -framework GLUT -framework OpenGL
		libGenDir = src
	endif

	# Set UNIX macros
	THEN = ;
endif

# Lists phony targets for Makefile
.PHONY: all setup submodules execute clean

# Default target, compiles, executes and cleans
all: $(target) execute clean

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
	cp vendor/raylib-cpp/vendor/raylib/$(libGenDir)/libraylib.a lib/$(platform)/libraylib.a
endif

# Link the program and create the executable
$(target): $(objects)
	$(CXX) $(objects) -o $(target) $(linkFlags)

# Compile objects to the build directory
$(buildDir)/%.o: src/%.cpp
ifeq ($(platform), Windows)
	-mkdir $(@D)
else
	mkdir -p $(@D)
endif
	$(CXX) -c $(compileFlags) $< -o $@

# Run the executable
execute:
	$(target)

# Clean up all relevant files
clean:
ifeq ($(platform), Windows)
	-del /S $(buildDir)\*
else
	rm -rf $(buildDir)/*
endif