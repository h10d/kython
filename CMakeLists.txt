cmake_minimum_required(VERSION 3.8)

#Add gtest and gmock
add_subdirectory("${CMAKE_SOURCE_DIR}/extern/google")
enable_testing()

set(PROJECT kython)
set(PROJECT_LIB_NAME ${PROJECT}_lib)
set(PROJECT_TEST_NAME ${PROJECT}_test)

project(${PROJECT_LIB} C CXX)

set(LIB_SOURCE_FILES
    src/exp/linecov.cpp
)

add_library(${PROJECT_LIB_NAME} SHARED ${LIB_SOURCE_FILES})


project(${PROJECT} C CXX)

set(PROJECT_SOURCE_FILES
    src/main.cpp
)
add_executable(${PROJECT} ${PROJECT_SOURCE_FILES})
target_link_libraries(${PROJECT} ${PROJECT_LIB})

project(${PROJECT_TEST_NAME} C CXX)
file(GLOB_RECURSE TEST_SOURCE_FILES RELATIVE ${PROJECT_SOURCE_DIR} test/*.cc)

message(STATUS "Test case source files:" ${TEST_SOURCE_FILES})

add_executable(${PROJECT_TEST_NAME} ${TEST_SOURCE_FILES})
target_link_libraries(${PROJECT_TEST_NAME} ${PROJECT_LIB} gtest gmock_main)
