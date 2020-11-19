#https://opensource.com/article/18/8/what-how-makefile

buildfile = ./build/app

macOSFrameworks = -framework CoreVideo -framework IOKit -framework Cocoa -framework GLUT -framework OpenGL

all: compile run clean

compile:
	clang++ -std=c++17 $(macOSFrameworks) -I ./include/ ./lib/libraylib.a ./src/main.cpp -o $(buildfile)

run:
	$(buildfile)

clean:
	rm $(buildfile)