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
	endif
	ifeq ($(UNAMEOS), Darwin)
		# Set macOS compile macros
		platform = macOS
		compiler = clang++
		options = -framework CoreVideo -framework IOKit -framework Cocoa -framework GLUT -framework OpenGL
	endif

	# Set UNIX commands
	cleanCommand = rm $(buildFile)
	mkdirOptions = -p
endif

run: compile execute clean

all: setup compile execute clean

setup: include lib

pull:
	# Pull and update the the build submodules
	git submodule init; git submodule update
	cd vendor/raylib-cpp; git submodule init ; git submodule update

include: pull
	# Copy the relevant header files into includes
	mkdir $(mkdirOptions) include
	cp vendor/raylib-cpp/vendor/raylib/src/{raylib.h,raymath.h} include
	cp vendor/raylib-cpp/include/*.hpp include

lib: pull
	# Build the raylib static library file and copy it into lib
	cd vendor/raylib-cpp/vendor/raylib/src; make PLATFORM=PLATFORM_DESKTOP
	mkdir $(mkdirOptions) lib/$(platform)
	cp vendor/raylib-cpp/vendor/raylib/src/libraylib.a lib/macOS/libraylib.a

compile:
	# Create the build folder and compile the executable
	mkdir $(mkdirOptions) build
	$(compiler) -std=c++17 -I include -L lib/$(platform) src/main.cpp -o $(buildFile) -l raylib $(options)

execute:
	$(buildFile)
	# Run the executable and push the output to a log file

clean:
	# Clean up all relevant files
	$(cleanCommand)
