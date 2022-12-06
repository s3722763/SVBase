cmake_minimum_required(VERSION 3.8)
project(VerilatorTest)
set(CMAKE_CXX_STANDARD 20)

find_package(verilator HINTS $ENV{VERILATOR_ROOT} ${VERILATOR_ROOT})
if (NOT verilator_FOUND)
  message(FATAL_ERROR "Verilator was not found. Either install it, or set the VERILATOR_ROOT environment variable")
endif()

find_package(Catch2 3 REQUIRED)

# Create a new executable target that will contain all your sources
add_executable(VerilatorTest sim_main.cpp)

target_link_libraries(VerilatorTest Catch2::Catch2WithMain)

# Find all v files
file(GLOB_RECURSE HDL_SOURCE_FILES "../src/*.sv")

foreach(file ${HDL_SOURCE_FILES})
  verilate(VerilatorTest COVERAGE TRACE
    VERILATOR_ARGS -f input.vc -x-assign fast
    SOURCES ${file})
endforeach()

# Add the Verilated circuit to the target

include(CTest)
include(Catch)
catch_discover_tests(VerilatorTest)
enable_testing()