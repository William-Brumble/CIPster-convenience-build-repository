#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
PRIMARY_COLOR=${GREEN}
NO_COLOR='\033[0m' # No Color

# Function to update CIPster submodule
update_submodule() {
    echo -n -e "${PRIMARY_COLOR}"
    echo "---------------------------------------------"
    echo "|      Updating CIPster submodule           |"
    echo "---------------------------------------------"
    echo -n -e "${NO_COLOR}"
    git submodule update --init --recursive --remote
    echo -e "${PRIMARY_COLOR}Done."
}

# Function to build the Windows version
build_windows() {
    echo -n -e "${PRIMARY_COLOR}"
    echo "---------------------------------------------"
    echo "|        Building Windows version           |"
    echo "---------------------------------------------"
    echo -e "${NO_COLOR}"
    cd build/windows
    cmake -DCMAKE_TOOLCHAIN_FILE=../../CIPster/source/buildsupport/Toolchain/toolchain-mingw64.cmake -DCMAKE_BUILD_TYPE=Release -DUSER_INO_COLORLUDE_DIR=../../config/windows ../../CIPster/source/
    make
    cd ../../
    echo -e "${PRIMARY_COLOR}Done."
}

# Function to copy built library file to release directory for Windows
copy_windows_lib() {
    echo -n -e "${PRIMARY_COLOR}"
    echo "---------------------------------------------"
    echo "|  Copying built library file for Windows  |"
    echo "---------------------------------------------"
    echo -n -e "${NO_COLOR}"
    cp build/windows/src/libeip.a release/windows/lib
    echo -e "${PRIMARY_COLOR}Done."
}

# Function to modify header files for Linux compatibility
modify_linux_headers() {
    echo -n -e "${PRIMARY_COLOR}"
    echo "---------------------------------------------"
    echo "|   Modifying files for Linux compatibility |"
    echo "---------------------------------------------"
    echo -n -e "${NO_COLOR}"
    if ! grep -q '#include <stdint.h>' CIPster/source/src/byte_bufs.h; then
        echo "#include <stdint.h>" | cat - CIPster/source/src/byte_bufs.h > temp && mv temp CIPster/source/src/byte_bufs.h
    fi
    if ! grep -q '#include <cstdint>' CIPster/source/src/enet_encap/sockaddr.cc; then
        echo "#include <cstdint>" | cat - CIPster/source/src/enet_encap/sockaddr.cc > temp && mv temp CIPster/source/src/enet_encap/sockaddr.cc
    fi
    echo -e "${PRIMARY_COLOR}Done."
}

# Function to build the Linux version
build_linux() {
    echo -n -e "${PRIMARY_COLOR}"
    echo "---------------------------------------------"
    echo "|        Building Linux version             |"
    echo "---------------------------------------------"
    echo -n -e "${NO_COLOR}"
    cd build/linux
    cmake -DCMAKE_BUILD_TYPE=Release -DUSER_INO_COLORLUDE_DIR=../../config/linux ../../CIPster/source/
    make
    cd ../../
    echo -e "${PRIMARY_COLOR}Done."
}

# Function to copy built library file to release directory for Linux
copy_linux_lib() {
    echo -n -e "${PRIMARY_COLOR}"
    echo "---------------------------------------------"
    echo "|  Copying built library file for Linux    |"
    echo "---------------------------------------------"
    echo -n -e "${NO_COLOR}"
    cp build/linux/src/libeip.a release/linux/lib
    echo -e "${PRIMARY_COLOR}Done."
}

# Function to copy header files to both Linux and Windows release directories
copy_headers() {
    echo -n -e "${PRIMARY_COLOR}"
    echo "---------------------------------------------"
    echo "|     Copying header files to release       |"
    echo "---------------------------------------------"
    echo -n -e "${NO_COLOR}"
    cp config/windows/cipster_user_conf.h release/windows/include
    cp config/linux/cipster_user_conf.h release/linux/include

    cd CIPster/source/src/
    cp *.h ../../../release/windows/include
    cp *.h ../../../release/linux/include

    cd cip
    cp *.h ../../../../release/windows/include/cip
    cp *.h ../../../../release/linux/include/cip
    cd ..

    cd enet_encap
    cp *.h ../../../../release/windows/include/enet_encap
    cp *.h ../../../../release/linux/include/enet_encap
    cd ..

    cd utils
    cp *.h ../../../../release/windows/include/utils
    cp *.h ../../../../release/linux/include/utils
    cd ../../../../
    echo -e "${PRIMARY_COLOR}Done."
}

# Function to create zip file of the library for Windows
create_windows_zip() {
    echo -n -e "${PRIMARY_COLOR}"
    echo "---------------------------------------------"
    echo "|   Creating zip file for Windows release   |"
    echo "---------------------------------------------"
    echo -n -e "${NO_COLOR}"
    cd release/windows
    zip -r cipster-windows.zip *
    mv cipster-windows.zip ../
    cd ../../
    echo -e "${PRIMARY_COLOR}Done."
}

# Function to create zip file of the library for Linux
create_linux_zip() {
    echo -n -e "${PRIMARY_COLOR}"
    echo "---------------------------------------------"
    echo "|    Creating zip file for Linux release    |"
    echo "---------------------------------------------"
    echo -n -e "${NO_COLOR}"
    cd release/linux
    zip -r cipster-linux.zip *
    mv cipster-linux.zip ../
    cd ../../
    echo -e "${PRIMARY_COLOR}Done."
}

# Main script execution
update_submodule
build_windows
copy_windows_lib
modify_linux_headers
build_linux
copy_linux_lib
copy_headers
create_windows_zip
create_linux_zip
