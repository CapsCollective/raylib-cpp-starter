# Set macros
buildFile = ./build/app

# Check for Windows
ifeq ($(OS), Windows_NT)
	# Set Windows macros
	platform = Windows
	compiler = g++
	options = -pthread -lopengl32 -lgdi32 -lwinmm -mwindows
	# Windows-specific commands for creation and deletion
	initCommand = -mkdir build
	cleanCommand = del build\app.exe  
else
	# Check for MacOS/Linux
	UNAMEOS := $(shell uname)
	ifeq ($(UNAMEOS), Linux)
		# Set Linux macros
		platform = Linux
		compiler = g++
		options = -l GL -l m -l pthread -l dl -l rt -l X11
	endif
	ifeq ($(UNAMEOS), Darwin)
		# Set macOS macros
		platform = macOS
		compiler = clang++
		options = -framework CoreVideo -framework IOKit -framework Cocoa -framework GLUT -framework OpenGL
	endif
	
	initCommand = mkdir -p build
	cleanCommand = rm $(buildFile)
endif

all: init compile run clean

init:
	$(initCommand)

compile:
	$(compiler) -std=c++17 -I ./include/ -L ./lib/$(platform) ./src/main.cpp -o $(buildFile) -l raylib $(options)

run:
	$(buildFile)

clean:
	$(cleanCommand)
