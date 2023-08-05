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
At the top of the Makefile, macros are defined to be used within the ensuing targets. Macros provide two valuable uses throughout the file: defined values (read variables) that can be used repeatedly throughout the program, and functions that can be called to manipulate certain inputs. The macros in this file are arranged in the following groups, in the following order: custom functions, globals, and platform-specifics.

### Custom Functions
There are two custom functions defined for the Makefile, `rwildcard` and `platformpth`, and appear in the file as follows:

```Makefile
rwildcard = $(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))
platformpth = $(subst /,$(PATHSEP),$1)
```
Simply put, `rwildcard` takes a glob pattern and **recursively** searches through the project files and subdirectories, for matching files by pattern. `platformpth` takes a UNIX-style path and formats it for the current platform (e.g. `platformpth(/bin/app)` results in `\bin\app` on Windows).

### Global Macros
The "global" macros are platform-agnostic values that are mostly used for defining compiler-related variables as below:

```Makefile
buildDir := bin
executable := app
target := $(buildDir)/$(executable)
sources := $(call rwildcard,src/,*.cpp)
objects := $(patsubst src/%, $(buildDir)/%, $(patsubst %.cpp, %.o, $(sources)))
depends := $(patsubst %.o, %.d, $(objects))
compileFlags := -std=c++17 -I include
linkFlags = -L lib/$(platform) -l raylib
ifdef MACRO_DEFS
    macroDefines := -D $(MACRO_DEFS)
endif
```

In this snippet there are two different assignment operators used, `:=` meaning "instant, static assign", and `=` meaning lazy assign, where the macro will only be assigned on use (this is useful when it relies on another macro that may not yet be defined). The operator `?=` is also used in cases where assignment is contingent on the variable being previously undefined. Finally, the `+=` operator is used to append content to a previously defined macro. At the very end, it checks to see if any macros were defined in the `Makefile` declaration and adds them to our compilation steps.

### Platform-Specific Macros
The final grouping of macros in the Makefile relate to those that differ on a per-platform basis. The structure uses nested if-statements to first determine whether the current platform is Windows or not to assign macros. If it is not Windows, it then checks whether the current platform is Linux or macOS and assigns macros accordingly.

```Makefile
ifeq ($(OS), Windows_NT)
	# Set Windows macros
	platform := Windows
	CXX ?= g++
	linkFlags += -Wl,--allow-multiple-definition -pthread -lopengl32 -lgdi32 -lwinmm -mwindows -static -static-libgcc -static-libstdc++
	THEN := &&
	PATHSEP := \$(BLANK)
	MKDIR := -mkdir -p
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
	endif

	# Set UNIX macros
	THEN := ;
	PATHSEP := /
	MKDIR := mkdir -p
	RM := rm -rf
	COPY = cp $1$(PATHSEP)$3 $2
endif
```

The macros defined above primarily contain platform-specific syntax for common functionality, as well as variables used during the compilation processes on each platform. For example, the `COPY` macro contains a functioning file copy command for each platform so that targets can easily specify a single command (`COPY`) that works on both UNIX and Windows systems. Another example of content pertains to the `linkFlags` macro, in which each platform must specify a series of libraries to link during compilation.

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

`submodules` is a very simple target that will update the git submodules in the project recursively, pulling in the current raylib and raylib-cpp repositories as a [shallow clone](https://github.blog/2020-12-21-get-up-to-speed-with-partial-clone-and-shallow-clone/) using the `--depth 1` option. You can [read more about git submodules here](https://git-scm.com/book/en/v2/Git-Tools-Submodules).
```Makefile
submodules:
	git submodule update --init --recursive --depth 1
```

Having satisfied `submodules` and now returning to `include`, we can being to run its body (as can be seen below).

It begins by creating the `/include` directory (converting the directory path for Windows if necessary with the custom `platformpth` function) if it doesn't already exist. 

Next, the target proceeds to call another custom function, `COPY` (a platform agnostic copy command), manually copying `raylib.h` and `raymath.h` from raylib's source code, and all files ending with `.hpp` from raylib-cpp's source code, into the newly created `/include` directory.
```Makefile
include: submodules
	$(MKDIR) $(call platformpth, ./include)
	$(call COPY,vendor/raylib/src,./include,raylib.h)
 	$(call COPY,vendor/raylib/src,./include,raymath.h)
	$(call COPY,vendor/raylib-cpp/include,./include,*.hpp)
```

Finally, we move on to `lib`, which also depends on `submodules`, however because submodules has already run, it will not run again.

Next, we create the `/lib` directory (and a subdirectory for your current platform) if it doesn't already exist using the same method as above.

Moving on to the body of the target, we move into raylib's `/src` directory and immediately run Make on raylib. Once complete, this results in the creation of a static library file named `libraylib.a` (*which will appear in slightly different directories based on the platform you build it in for whatever reason...*).

To complete the target, it then copies that library file into the relevant directory for your platform under `/lib`.
```Makefile
lib: submodules
	cd vendor/raylib/src $(THEN) "$(MAKE)" PLATFORM=PLATFORM_DESKTOP
 	$(MKDIR) $(call platformpth, lib/$(platform))
 	$(call COPY,vendor/raylib/src,lib/$(platform),libraylib.a)
```

Once all of these targets have been fulfilled, `setup` ends and your project should now contain a copy of the relevant static library for your platform in `/lib`, and all the necessary header files under `/include`.

### all
The target name `all` is used as a common convention as being the default target in any Makefile, and what makes it default is that it's the first target defined (aside from the the reserved target of `.PHONY`). In our case we consider the default behaviour of our build system as compiling, running and then cleaning up the build, avoiding including the steps defined in `setup`.

The first line of the target simply lists its dependencies in order of execution: the application target (with its name defined by the `target` variable), the `execute` target to run the program, and finally `clean` to tidy up post-build.
```Makefile
all: $(target) execute clean
```

The application target is first to run, and contains the instruction of compiling the program into the `target` file using the defined `CXX` command on a series of object files and linker flags. However this also contains a number of prerequisites as all object files list in `objects` must exist and be up to date. With this being the case, the Makefile will run the relevant target for each object file.
```Makefile
$(target): $(objects)
	$(CXX) $(objects) -o $(target) $(linkFlags)
```

As such, the target `$(buildDir)/%.o` is responsible for ensuring the creation and update of object files (`.o` files). The target will create all necessary subdirectory structures needed for the files, and then compile each `.cpp` file in the source directory into an object file using a number of rather terse, [automatic variables that you can read up on here](https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html). Finally, it includes any custom macros that we defined for each of these files. 
```Makefile
$(buildDir)/%.o: src/%.cpp Makefile
	$(MKDIR) $(call platformpth, $(@D))
	$(CXX) -MMD -MP -c $(compileFlags) $< -o $@ $(macroDefines)
```
That all being said, there are still two dependancies for the target, the `.cpp` files, and the Makefile itself. One might wonder why either of these need to be dependencies, given that without them, there would be nothing to compile and no instructions with which to compile it, however there is definitely some intention behind this. Firstly, the aforementioned automatic variables of `$<` and `$@` require a list of dependencies to iterate through, and secondly, we want to make sure everything is up-to-date. For instance, changing a `.cpp` file should trigger this step to run again for that file, or changing the Makefile should warrant a full recompilation.

This is where things get a little hairy. There is a common scenario where one might change a `.cpp` or `.h` file that is included by another, and as such the changed file will recompile, but none that depend on it. So how can we track this dependency? The answer is by cheating, using the power of the C/C++ compiler. The flags `-MMD` and `-MP` in the compile command tell the compiler to automatically generate a list of file dependency targets for each file as it goes. These files are then output to the `/bin/` directory alongside their matching `.o` files for later reference, containing automatically generated Makefile targets.

One might ask how these are then read back in and used, well that is done with another piece of Makefile magic: the `include` command, which when added to a Makefile, will import the content of any specified file to its body. The below command is entirely responsible for doing this, and the output of the operation is ignored by prefacing it with a dash.
```Makefile
-include $(depends)
```
Now, finally returning from two levels of indirection in targets, the program can come back to the application target and link the newly generated and updated object files into the program, alongside any raylib and binding components.
```Makefile
$(target): $(objects)
	$(CXX) $(objects) -o $(target) $(linkFlags)
```

After this, the execute target will simply attempt to run the program from the command line with any supplied arguments.
```Makefile
execute:
	$(target) $(ARGS)
```

Once the application is closed, crashed, or otherwise ended, the clean command will then be run (for the appropriate platform path and command), by deleting the `/bin/` directory, including object files, dependency files and the application itself. This prepares the build system for a fresh compilation.
```Makefile
clean:
	$(RM) $(call platformpth, $(buildDir)/*)
```
