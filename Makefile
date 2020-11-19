buildfile = ./build/app

macOSFrameworks = -framework CoreVideo -framework IOKit -framework Cocoa -framework GLUT -framework OpenGL

all: init compile run clean

init:
	mkdir -p build

compile:
	clang++ -std=c++17 $(macOSFrameworks) -I ./include/ ./lib/libraylib.a ./src/main.cpp -o $(buildfile)

run:
	$(buildfile)

clean:
	rm $(buildfile)