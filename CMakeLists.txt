cmake_minimum_required(VERSION 3.5)

set(PROJECT_NAME kython)

project(${PROJECT_NAME} C CXX)

file(GLOB_RECURSE PROJECT_SOURCE_FILES RELATIVE ${PROJECT_SOURCE_DIR} src/*.cpp)
message(STATUS "Project source files:" ${PROJECT_SOURCE_FILES})
add_executable(${PROJECT_NAME} ${PROJECT_SOURCE_FILES})


# test-project
set(PROJECT_TEST_NAME ${PROJECT_NAME}_test)
find_package(GTest REQUIRED)
enable_testing()


include_directories(${GTEST_INCLUDE_DIRS})
file(GLOB_RECURSE TEST_SOURCE_FILES RELATIVE ${PROJECT_SOURCE_DIR} test/*.cc)

message(STATUS "Test case source files:" ${TEST_SOURCE_FILES})

add_executable(${PROJECT_TEST_NAME} ${TEST_SOURCE_FILES})

target_link_libraries(${PROJECT_TEST_NAME} gtest gtest_main)
