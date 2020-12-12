# How the Makefile Works
This document attempts to explain how the project's build-system works, as well as general concepts in Makefile. It was created with the intention to help newcomers to C/C++ and Make understand how everything in the project is done, so that they can even dive in and make changes of their own if necessary.

#### Contents
- [Targets](#targets)
  - [setup](#setup)
  - [all](#all)
- [Macro Definitions (Preamble)](#macro-definitions)
  - [Custom Functions](#custom-functions)

## Targets
This section describes most of the Makefile's functionality target-by-target, where we explain how they each execute step-by-step.

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
#### This section is still being written

## Macro Definitions
#### This section is still being written

### Custom Functions
#### This section is still being written
