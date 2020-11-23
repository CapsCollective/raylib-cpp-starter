# Set general macros
buildFile = build/app

# Check for Windows
ifeq ($(OS), Windows_NT)
	# Set Windows compile macros
	platform = Windows
	compiler = g++
	options = -pthread -lopengl32 -lgdi32 -lwinmm -mwindows
	
	# Set Windows commands
	mkdirCommand = -mkdir
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
	mkdirCommand = mkdir -p
	cleanCommand = rm $(buildFile)
endif

run: compile execute clean

all: setup compile execute clean

setup: include lib

pull:
	git submodule init; git submodule update
	cd vendor/raylib-cpp; git submodule init; git submodule update

include: pull
	$(mkdirCommand) include
	cp vendor/raylib-cpp/vendor/raylib/src/raylib.h include/raylib.h
	cp vendor/raylib-cpp/vendor/raylib/src/raymath.h include/raymath.h
	cp vendor/raylib-cpp/include/*.hpp include

lib: pull
	cd vendor/raylib-cpp/vendor/raylib/src; make PLATFORM=PLATFORM_DESKTOP
	$(mkdirCommand) lib/$(platform)
	cp vendor/raylib-cpp/vendor/raylib/$(libGenDirectory)/libraylib.a lib/$(platform)/libraylib.a

compile:
	$(mkdirCommand) build
	$(compiler) -std=c++17 -I include -L lib/$(platform) src/main.cpp -o $(buildFile) -l raylib $(options)

execute:
	$(buildFile)

clean:
	$(cleanCommand)
