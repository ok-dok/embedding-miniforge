% -- %
tree /f
mkdir bin
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -S ..\vendor ..
cmake --build . --target lnkparse --config Release -j 9
tree /f
move bin\Release\lnkparse.exe ..\bin
cd ..
dir bin
% -- %