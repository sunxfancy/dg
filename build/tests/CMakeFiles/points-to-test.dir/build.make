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
include tests/CMakeFiles/points-to-test.dir/depend.make

# Include the progress variables for this target.
include tests/CMakeFiles/points-to-test.dir/progress.make

# Include the compile flags for this target's objects.
include tests/CMakeFiles/points-to-test.dir/flags.make

tests/CMakeFiles/points-to-test.dir/points-to-test.cpp.o: tests/CMakeFiles/points-to-test.dir/flags.make
tests/CMakeFiles/points-to-test.dir/points-to-test.cpp.o: ../tests/points-to-test.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/david/tau/dg/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object tests/CMakeFiles/points-to-test.dir/points-to-test.cpp.o"
	cd /home/david/tau/dg/build/tests && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/points-to-test.dir/points-to-test.cpp.o -c /home/david/tau/dg/tests/points-to-test.cpp

tests/CMakeFiles/points-to-test.dir/points-to-test.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/points-to-test.dir/points-to-test.cpp.i"
	cd /home/david/tau/dg/build/tests && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/david/tau/dg/tests/points-to-test.cpp > CMakeFiles/points-to-test.dir/points-to-test.cpp.i

tests/CMakeFiles/points-to-test.dir/points-to-test.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/points-to-test.dir/points-to-test.cpp.s"
	cd /home/david/tau/dg/build/tests && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/david/tau/dg/tests/points-to-test.cpp -o CMakeFiles/points-to-test.dir/points-to-test.cpp.s

tests/CMakeFiles/points-to-test.dir/points-to-test.cpp.o.requires:

.PHONY : tests/CMakeFiles/points-to-test.dir/points-to-test.cpp.o.requires

tests/CMakeFiles/points-to-test.dir/points-to-test.cpp.o.provides: tests/CMakeFiles/points-to-test.dir/points-to-test.cpp.o.requires
	$(MAKE) -f tests/CMakeFiles/points-to-test.dir/build.make tests/CMakeFiles/points-to-test.dir/points-to-test.cpp.o.provides.build
.PHONY : tests/CMakeFiles/points-to-test.dir/points-to-test.cpp.o.provides

tests/CMakeFiles/points-to-test.dir/points-to-test.cpp.o.provides.build: tests/CMakeFiles/points-to-test.dir/points-to-test.cpp.o


# Object files for target points-to-test
points__to__test_OBJECTS = \
"CMakeFiles/points-to-test.dir/points-to-test.cpp.o"

# External object files for target points-to-test
points__to__test_EXTERNAL_OBJECTS =

tests/points-to-test: tests/CMakeFiles/points-to-test.dir/points-to-test.cpp.o
tests/points-to-test: tests/CMakeFiles/points-to-test.dir/build.make
tests/points-to-test: src/libPTA.so
tests/points-to-test: tests/CMakeFiles/points-to-test.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/david/tau/dg/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable points-to-test"
	cd /home/david/tau/dg/build/tests && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/points-to-test.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tests/CMakeFiles/points-to-test.dir/build: tests/points-to-test

.PHONY : tests/CMakeFiles/points-to-test.dir/build

tests/CMakeFiles/points-to-test.dir/requires: tests/CMakeFiles/points-to-test.dir/points-to-test.cpp.o.requires

.PHONY : tests/CMakeFiles/points-to-test.dir/requires

tests/CMakeFiles/points-to-test.dir/clean:
	cd /home/david/tau/dg/build/tests && $(CMAKE_COMMAND) -P CMakeFiles/points-to-test.dir/cmake_clean.cmake
.PHONY : tests/CMakeFiles/points-to-test.dir/clean

tests/CMakeFiles/points-to-test.dir/depend:
	cd /home/david/tau/dg/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/david/tau/dg /home/david/tau/dg/tests /home/david/tau/dg/build /home/david/tau/dg/build/tests /home/david/tau/dg/build/tests/CMakeFiles/points-to-test.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tests/CMakeFiles/points-to-test.dir/depend
