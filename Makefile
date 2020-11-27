# Set general macros
buildFile = build/app

# Check for Windows
ifeq ($(OS), Windows_NT)
	# Set Windows compile macros
	platform = Windows
	compiler = g++
	options = -pthread -lopengl32 -lgdi32 -lwinmm -mwindows
	
	# Set Windows commands
	cleanCommand = del build\app.exe  
else
	# Check for MacOS/Linux
	UNAMEOS := $(shell uname)
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
		libGenDirectory = src
	endif

	# Set UNIX commands
	mkdirOptions = -p
	cleanCommand = rm $(buildFile)
endif

# Explicitly set compiler to platform default if unset
ifeq ($(CXX),)
	CXX = $(compiler)
endif

# Default target, compiles, executes and cleans
run: compile execute clean

# Lists phony targets for Make compile
.PHONY: run setup pull compile execute clean

# Sets up the project for compiling, creates libs and includes
setup: include lib

# Pull and update the the build submodules
pull:
	git submodule init; git submodule update
	cd vendor/raylib-cpp; git submodule init; git submodule update

# Copy the relevant header files into includes
include: pull
	mkdir $(mkdirOptions) include
	cp vendor/raylib-cpp/vendor/raylib/src/raylib.h include/raylib.h
	cp vendor/raylib-cpp/vendor/raylib/src/raymath.h include/raymath.h
	cp vendor/raylib-cpp/include/*.hpp include

# Build the raylib static library file and copy it into lib
lib: pull
	cd vendor/raylib-cpp/vendor/raylib/src; make PLATFORM=PLATFORM_DESKTOP
	mkdir $(mkdirOptions) lib/$(platform)
	cp vendor/raylib-cpp/vendor/raylib/$(libGenDirectory)/libraylib.a lib/$(platform)/libraylib.a

# Create the build folder
build:
	mkdir $(mkdirOptions) build

# Create the build folder and compile the executable
compile: build
	$(CXX) -std=c++17 -I include -L lib/$(platform) src/main.cpp -o $(buildFile) -l raylib $(options)

# Run the executable
execute:
	$(buildFile)

# Clean up all relevant files
clean:
	$(cleanCommand)
