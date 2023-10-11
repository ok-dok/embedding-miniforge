project(lnkparse)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY bin)
SET(CMAKE_BUILD_TYPE "Release")
add_executable(${PROJECT_NAME} vendor/lnk_parse.cpp)
