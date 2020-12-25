# How the Makefile Works
This document attempts to explain how the project's build-system works, as well as general concepts in Makefile. It was created with the intention to help newcomers to C/C++ and Make understand how everything in the project is done, so that they can even dive in and make changes of their own if necessary. The format of the document orders items from top to bottom in general order of appearance throughout [the actual project Makefile](/Makefile).

### Contents
- [Macro Definitions](#macro-definitions)
  - [Custom Functions](#custom-functions)
  - [Global Macros](#global-macros)
  - [Platform-Specific Macros](#platform-specific-macros)
- [Targets](#targets)
  - [.PHONY](#phony)
  - [setup](#setup)
  - [all](#all)

## Macro Definitions
#### This section is still being written

### Custom Functions
This subsection is still being written.

```Makefile
rwildcard = $(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))
platformpth = $(subst /,$(PATHSEP),$1)
```

### Global Macros
This subsection is still being written.

```Makefile
buildDir := bin
executable := app
target := $(buildDir)/$(executable)
sources := $(call rwildcard,src/,*.cpp)
objects := $(patsubst src/%, $(buildDir)/%, $(patsubst %.cpp, %.o, $(sources)))
depends := $(patsubst %.o, %.d, $(objects))
compileFlags := -std=c++17 -I include
linkFlags = -L lib/$(platform) -l raylib
```

### Platform-Specific Macros
This subsection is still being written.

```Makefile
ifeq ($(OS), Windows_NT)
	# Set Windows macros
	platform := Windows
	CXX ?= g++
	linkFlags += -Wl,--allow-multiple-definition -pthread -lopengl32 -lgdi32 -lwinmm -mwindows
	libGenDir := src
	THEN := &&
	PATHSEP := \$(BLANK)
	MKDIR := -mkdir
	RM := -del /q
	COPY = -robocopy "$(call platformpth,$1)" "$(call platformpth,$2)" $3
else
	# Check for MacOS/Linux
	UNAMEOS := $(shell uname)
	ifeq ($(UNAMEOS), Linux)
		# Set Linux macros
		platform := Linux
		CXX ?= g++
		linkFlags += -l GL -l m -l pthread -l dl -l rt -l X11
	endif
	ifeq ($(UNAMEOS), Darwin)
		# Set macOS macros
		platform := macOS
		CXX ?= clang++
		linkFlags += -framework CoreVideo -framework IOKit -framework Cocoa -framework GLUT -framework OpenGL
		libGenDir := src
	endif

	# Set UNIX macros
	THEN := ;
	PATHSEP := /
	MKDIR := mkdir -p
	RM := rm -rf
	COPY = cp $1$(PATHSEP)$3 $2
endif
```

## Targets
This section describes most of the Makefile's functionality by explaning of the function of the top level targets, `setup` and `all`, intending to provide a wholistic understanding of the Makefile's processes from top to bottom.

### .PHONY
The `.PHONY` target is a special target in the world of Makefile, and is specifically used to note which targets "exist" and which are "phony". A target should theoretically refer to (in dev terms) an actual file or directory requirement of the project's build system (e.g. a static library file to link to the app), and so Make does some useful work in the background to work out whether changes have been made to certain files, running targets of only files that have had their dependencies changed since last run. In a more realistic sense, Make also recognises that not all targets will refer to real world files, and can be exluded from this "run only if new changes" behaviour using the `.PHONY` target.

```Makefile
.PHONY: all setup submodules execute clean
```

So as you can see above, the first target of the file lists all the other "phony" targets in the file as dependencies.

### setup
The first target we get you to call before building the project is `setup`, which essentially pulls in all raylib and raylib-cpp dependencies, and then formats the project file structure.

As you can see below, the target simply depends on two sub-targets, `include` and `lib`:
```Makefile
setup: include lib
```

However, looking at `include`, we can see that it depends on `submodules`, so we'll look at that first.
```Makefile
include: submodules
	...
```

`submodules` is a very simple target that will update the git submodules in the project recursively, pulling in the current raylib-cpp repository under the `/vendor` directory and then raylib itself under its own `/vendor` directory. The reason for this, is to make sure that the pulled versions of raylib and the bindings match in version. You can [read more about git submodules here](https://git-scm.com/book/en/v2/Git-Tools-Submodules).
```Makefile
submodules:
	git submodule update --init --recursive
```

Having satisfied `submodules` and now returning to `include`, we can being to run its body (as can be seen below).

It begins by creating the `/include` directory (converting the directory path for Windows if necessary with the custom `platformpth` function) if it doesn't already exist. 

Next, the target proceeds to call another custom function, `COPY` (a platform agnostic copy command), manually copying `raylib.h` and `raymath.h` from raylib's source code, and all files ending with `.hpp` from raylib-cpp's source code, into the newly created `/include` directory.
```Makefile
include: submodules
	$(MKDIR) $(call platformpth, ./include)
	$(call COPY,vendor/raylib-cpp/vendor/raylib/src,./include,raylib.h)
	$(call COPY,vendor/raylib-cpp/vendor/raylib/src,./include,raymath.h)
	$(call COPY,vendor/raylib-cpp/include,./include,*.hpp)
```

Finally, we move on to `lib`, which also depends on `submodules`, however because submodules has already run, it will not run again.

Next, we create the `/lib` directory (and a subdirectory for your current platform) if it doesn't already exist using the same method as above.

Moving on to the body of the target, we move into raylib's `/src` directory and immediately run Make on raylib. Once complete, this results in the creation of a static library file named `libraylib.a` (*which will appear in slightly different directories based on the platform you build it in for whatever reason...*).

To complete the target, it then copies that library file into the relevant directory for your platform under `/lib`.
```Makefile
lib: submodules
	cd vendor/raylib-cpp/vendor/raylib/src $(THEN) "$(MAKE)" PLATFORM=PLATFORM_DESKTOP
	$(MKDIR) $(call platformpth, lib/$(platform))
	$(call COPY,vendor/raylib-cpp/vendor/raylib/$(libGenDir),lib/$(platform),libraylib.a)
```

Once all of these targets have been fulfilled, `setup` ends and your project should now contain a copy of the relevant static library for your platform in `/lib`, and all the necessary header files under `/include`.

### all
This subsection is still being written
