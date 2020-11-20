# Set platform-specific macros
ifeq ($(OS), Windows_NT)
	# Build for Windows
	
else
	# Build for MacOS/Linux
	
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S), Linux)
		# Set Linux macros
		compiler = g++
		libPath = ./lib/Linux/libraylib.a
	endif
	ifeq ($(UNAME_S), Darwin)
		# Set macOS macros
		compiler = clang++
		frameworks = -framework CoreVideo -framework IOKit -framework Cocoa -framework GLUT -framework OpenGL
		libPath = ./lib/macOS/libraylib.a
	endif
	
	buildfile = ./build/app
	initCommand = mkdir -p build
	compileCommand = $(compiler) -std=c++17 $(frameworks) -I ./include/ $(libPath) ./src/main.cpp -o $(buildfile)
	cleanCommand = rm $(buildfile)
endif

all: init compile run clean

init:
	$(initCommand)

compile:
	$(compileCommand)

run:
	$(buildfile)

clean:
	$(cleanCommand)
