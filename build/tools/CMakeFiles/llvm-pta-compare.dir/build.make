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
include tools/CMakeFiles/llvm-pta-compare.dir/depend.make

# Include the progress variables for this target.
include tools/CMakeFiles/llvm-pta-compare.dir/progress.make

# Include the compile flags for this target's objects.
include tools/CMakeFiles/llvm-pta-compare.dir/flags.make

tools/CMakeFiles/llvm-pta-compare.dir/llvm-pta-compare.cpp.o: tools/CMakeFiles/llvm-pta-compare.dir/flags.make
tools/CMakeFiles/llvm-pta-compare.dir/llvm-pta-compare.cpp.o: ../tools/llvm-pta-compare.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/david/tau/dg/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object tools/CMakeFiles/llvm-pta-compare.dir/llvm-pta-compare.cpp.o"
	cd /home/david/tau/dg/build/tools && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/llvm-pta-compare.dir/llvm-pta-compare.cpp.o -c /home/david/tau/dg/tools/llvm-pta-compare.cpp

tools/CMakeFiles/llvm-pta-compare.dir/llvm-pta-compare.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/llvm-pta-compare.dir/llvm-pta-compare.cpp.i"
	cd /home/david/tau/dg/build/tools && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/david/tau/dg/tools/llvm-pta-compare.cpp > CMakeFiles/llvm-pta-compare.dir/llvm-pta-compare.cpp.i

tools/CMakeFiles/llvm-pta-compare.dir/llvm-pta-compare.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/llvm-pta-compare.dir/llvm-pta-compare.cpp.s"
	cd /home/david/tau/dg/build/tools && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/david/tau/dg/tools/llvm-pta-compare.cpp -o CMakeFiles/llvm-pta-compare.dir/llvm-pta-compare.cpp.s

tools/CMakeFiles/llvm-pta-compare.dir/llvm-pta-compare.cpp.o.requires:

.PHONY : tools/CMakeFiles/llvm-pta-compare.dir/llvm-pta-compare.cpp.o.requires

tools/CMakeFiles/llvm-pta-compare.dir/llvm-pta-compare.cpp.o.provides: tools/CMakeFiles/llvm-pta-compare.dir/llvm-pta-compare.cpp.o.requires
	$(MAKE) -f tools/CMakeFiles/llvm-pta-compare.dir/build.make tools/CMakeFiles/llvm-pta-compare.dir/llvm-pta-compare.cpp.o.provides.build
.PHONY : tools/CMakeFiles/llvm-pta-compare.dir/llvm-pta-compare.cpp.o.provides

tools/CMakeFiles/llvm-pta-compare.dir/llvm-pta-compare.cpp.o.provides.build: tools/CMakeFiles/llvm-pta-compare.dir/llvm-pta-compare.cpp.o


# Object files for target llvm-pta-compare
llvm__pta__compare_OBJECTS = \
"CMakeFiles/llvm-pta-compare.dir/llvm-pta-compare.cpp.o"

# External object files for target llvm-pta-compare
llvm__pta__compare_EXTERNAL_OBJECTS =

tools/llvm-pta-compare: tools/CMakeFiles/llvm-pta-compare.dir/llvm-pta-compare.cpp.o
tools/llvm-pta-compare: tools/CMakeFiles/llvm-pta-compare.dir/build.make
tools/llvm-pta-compare: src/libLLVMdg.so
tools/llvm-pta-compare: src/libLLVMpta.so
tools/llvm-pta-compare: src/libPTA.so
tools/llvm-pta-compare: src/libRD.so
tools/llvm-pta-compare: tools/CMakeFiles/llvm-pta-compare.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/david/tau/dg/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable llvm-pta-compare"
	cd /home/david/tau/dg/build/tools && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/llvm-pta-compare.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tools/CMakeFiles/llvm-pta-compare.dir/build: tools/llvm-pta-compare

.PHONY : tools/CMakeFiles/llvm-pta-compare.dir/build

tools/CMakeFiles/llvm-pta-compare.dir/requires: tools/CMakeFiles/llvm-pta-compare.dir/llvm-pta-compare.cpp.o.requires

.PHONY : tools/CMakeFiles/llvm-pta-compare.dir/requires

tools/CMakeFiles/llvm-pta-compare.dir/clean:
	cd /home/david/tau/dg/build/tools && $(CMAKE_COMMAND) -P CMakeFiles/llvm-pta-compare.dir/cmake_clean.cmake
.PHONY : tools/CMakeFiles/llvm-pta-compare.dir/clean

tools/CMakeFiles/llvm-pta-compare.dir/depend:
	cd /home/david/tau/dg/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/david/tau/dg /home/david/tau/dg/tools /home/david/tau/dg/build /home/david/tau/dg/build/tools /home/david/tau/dg/build/tools/CMakeFiles/llvm-pta-compare.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tools/CMakeFiles/llvm-pta-compare.dir/depend
