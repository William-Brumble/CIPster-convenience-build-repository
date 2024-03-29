#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
PRIMARY_COLOR=${GREEN}
NO_COLOR='\033[0m' # No Color

# Function to print a message with ASCII art
print_message() {
    local message="$1"
    echo -n -e "${PRIMARY_COLOR}"
    echo "---------------------------------------------"
    echo "|${message}"
    echo "---------------------------------------------"
    echo -n -e "${NO_COLOR}"
}

# Make directories that are excluded from GIT
create_directories() {
    print_message "     Creating Directories"
    mkdir -p build/windows
    mkdir -p release/windows/include/cipster/cip
    mkdir -p release/windows/include/cipster/enet_encap
    mkdir -p release/windows/include/cipster/utils
    mkdir -p release/windows/lib/cipster

    mkdir -p build/linux
    mkdir -p release/linux/include/cipster/cip
    mkdir -p release/linux/include/cipster/enet_encap
    mkdir -p release/linux/include/cipster/utils
    mkdir -p release/linux/lib/cipster

    echo -e "${PRIMARY_COLOR}Done."
}

# Function to update CIPster submodule
update_submodule() {
    print_message "     Updating CIPster submodule"
    git submodule update --init --recursive --remote
    echo -e "${PRIMARY_COLOR}Done."
}

# Function to build the Windows version
build_windows() {
    print_message "     Building Windows version"
    cd build/windows
    cmake -DCMAKE_TOOLCHAIN_FILE=../../CIPster/source/buildsupport/Toolchain/toolchain-mingw64.cmake -DCMAKE_BUILD_TYPE=Release -DUSER_INCLUDE_DIR=../../config/windows ../../CIPster/source/
    make
    cd ../../
    echo -e "${PRIMARY_COLOR}Done."
}

# Function to copy built library file to release directory for Windows
copy_windows_lib() {
    print_message "     Copying built library file for Windows"
    cp build/windows/src/libeip.a release/windows/lib/cipster
    echo -e "${PRIMARY_COLOR}Done."
}

# Function to modify header files for Linux compatibility
modify_linux_headers() {
    print_message "     Modifying files for Linux compatibility"
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
    print_message "     Building Linux version"
    cd build/linux
    cmake -DCMAKE_BUILD_TYPE=Release -DUSER_INCLUDE_DIR=../../config/linux ../../CIPster/source/
    make
    cd ../../
    echo -e "${PRIMARY_COLOR}Done."
}

# Function to copy built library file to release directory for Linux
copy_linux_lib() {
    print_message "     Copying built library file for Linux"
    cp build/linux/src/libeip.a release/linux/lib/cipster
    echo -e "${PRIMARY_COLOR}Done."
}

# Function to copy header files to both Linux and Windows release directories
copy_headers() {
    print_message "     Copying header files to release"
    cp config/windows/cipster_user_conf.h release/windows/include/cipster
    cp config/linux/cipster_user_conf.h release/linux/include/cipster

    cd CIPster/source/src/
    cp *.h ../../../release/windows/include/cipster
    cp *.h ../../../release/linux/include/cipster

    cd cip
    cp *.h ../../../../release/windows/include/cipster/cip
    cp *.h ../../../../release/linux/include/cipster/cip
    cd ..

    cd enet_encap
    cp *.h ../../../../release/windows/include/cipster/enet_encap
    cp *.h ../../../../release/linux/include/cipster/enet_encap
    cd ..

    cd utils
    cp *.h ../../../../release/windows/include/cipster/utils
    cp *.h ../../../../release/linux/include/cipster/utils
    cd ../../../../
    echo -e "${PRIMARY_COLOR}Done."
}

# Function to create zip file of the library for Windows
create_windows_zip() {
    print_message "     Creating zip file for Windows release"
    cd release/windows
    zip -r cipster-windows.zip *
    mv cipster-windows.zip ../
    cd ../../
    echo -e "${PRIMARY_COLOR}Done."
}

# Function to create zip file of the library for Linux
create_linux_zip() {
    print_message "     Creating zip file for Linux release"
    cd release/linux
    zip -r cipster-linux.zip *
    mv cipster-linux.zip ../
    cd ../../
    echo -e "${PRIMARY_COLOR}Done."
}

# Main script execution
update_submodule
create_directories
build_windows
copy_windows_lib
modify_linux_headers
build_linux
copy_linux_lib
copy_headers
create_windows_zip
create_linux_zip
