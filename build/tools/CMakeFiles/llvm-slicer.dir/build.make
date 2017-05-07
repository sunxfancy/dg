# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.5

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/david/tau/dg

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/david/tau/dg/build

# Include any dependencies generated for this target.
include tools/CMakeFiles/llvm-slicer.dir/depend.make

# Include the progress variables for this target.
include tools/CMakeFiles/llvm-slicer.dir/progress.make

# Include the compile flags for this target's objects.
include tools/CMakeFiles/llvm-slicer.dir/flags.make

tools/CMakeFiles/llvm-slicer.dir/llvm-slicer.cpp.o: tools/CMakeFiles/llvm-slicer.dir/flags.make
tools/CMakeFiles/llvm-slicer.dir/llvm-slicer.cpp.o: ../tools/llvm-slicer.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/david/tau/dg/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object tools/CMakeFiles/llvm-slicer.dir/llvm-slicer.cpp.o"
	cd /home/david/tau/dg/build/tools && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/llvm-slicer.dir/llvm-slicer.cpp.o -c /home/david/tau/dg/tools/llvm-slicer.cpp

tools/CMakeFiles/llvm-slicer.dir/llvm-slicer.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/llvm-slicer.dir/llvm-slicer.cpp.i"
	cd /home/david/tau/dg/build/tools && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/david/tau/dg/tools/llvm-slicer.cpp > CMakeFiles/llvm-slicer.dir/llvm-slicer.cpp.i

tools/CMakeFiles/llvm-slicer.dir/llvm-slicer.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/llvm-slicer.dir/llvm-slicer.cpp.s"
	cd /home/david/tau/dg/build/tools && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/david/tau/dg/tools/llvm-slicer.cpp -o CMakeFiles/llvm-slicer.dir/llvm-slicer.cpp.s

tools/CMakeFiles/llvm-slicer.dir/llvm-slicer.cpp.o.requires:

.PHONY : tools/CMakeFiles/llvm-slicer.dir/llvm-slicer.cpp.o.requires

tools/CMakeFiles/llvm-slicer.dir/llvm-slicer.cpp.o.provides: tools/CMakeFiles/llvm-slicer.dir/llvm-slicer.cpp.o.requires
	$(MAKE) -f tools/CMakeFiles/llvm-slicer.dir/build.make tools/CMakeFiles/llvm-slicer.dir/llvm-slicer.cpp.o.provides.build
.PHONY : tools/CMakeFiles/llvm-slicer.dir/llvm-slicer.cpp.o.provides

tools/CMakeFiles/llvm-slicer.dir/llvm-slicer.cpp.o.provides.build: tools/CMakeFiles/llvm-slicer.dir/llvm-slicer.cpp.o


# Object files for target llvm-slicer
llvm__slicer_OBJECTS = \
"CMakeFiles/llvm-slicer.dir/llvm-slicer.cpp.o"

# External object files for target llvm-slicer
llvm__slicer_EXTERNAL_OBJECTS =

tools/llvm-slicer: tools/CMakeFiles/llvm-slicer.dir/llvm-slicer.cpp.o
tools/llvm-slicer: tools/CMakeFiles/llvm-slicer.dir/build.make
tools/llvm-slicer: src/libLLVMdg.so
tools/llvm-slicer: src/libLLVMpta.so
tools/llvm-slicer: src/libPTA.so
tools/llvm-slicer: src/libRD.so
tools/llvm-slicer: tools/CMakeFiles/llvm-slicer.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/david/tau/dg/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable llvm-slicer"
	cd /home/david/tau/dg/build/tools && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/llvm-slicer.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tools/CMakeFiles/llvm-slicer.dir/build: tools/llvm-slicer

.PHONY : tools/CMakeFiles/llvm-slicer.dir/build

tools/CMakeFiles/llvm-slicer.dir/requires: tools/CMakeFiles/llvm-slicer.dir/llvm-slicer.cpp.o.requires

.PHONY : tools/CMakeFiles/llvm-slicer.dir/requires

tools/CMakeFiles/llvm-slicer.dir/clean:
	cd /home/david/tau/dg/build/tools && $(CMAKE_COMMAND) -P CMakeFiles/llvm-slicer.dir/cmake_clean.cmake
.PHONY : tools/CMakeFiles/llvm-slicer.dir/clean

tools/CMakeFiles/llvm-slicer.dir/depend:
	cd /home/david/tau/dg/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/david/tau/dg /home/david/tau/dg/tools /home/david/tau/dg/build /home/david/tau/dg/build/tools /home/david/tau/dg/build/tools/CMakeFiles/llvm-slicer.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tools/CMakeFiles/llvm-slicer.dir/depend
