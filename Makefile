# Variable definitions
macOSFrameworks = -framework CoreVideo -framework IOKit -framework Cocoa -framework GLUT -framework OpenGL

ifeq ($(OS), Windows_NT)
	# Build for Windows:

	# Not implemented yet
else
	# Build for MacOS or Linux:
	buildfile = ./build/app
	initCommand = mkdir -p build
	compileCommand = clang++ -std=c++17 $(macOSFrameworks) -I ./include/ ./lib/libraylib.a ./src/main.cpp -o $(buildfile)
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