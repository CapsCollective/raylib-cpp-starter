# Set macros
buildFile = ./build/app

# Check for Windows
ifeq ($(OS), Windows_NT)
	# Set Windows macros
	platform = Windows
	compiler = g++
	options = -p thread -l opengl32 -l gdi32 -l winmm -m windows  
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
