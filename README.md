# CIPster Convenience Build Repository

This repository serves as a convenience build tool for CIPster, providing built static libraries in zipped and unzipped release directories for both Windows and Linux platforms.

## Overview

The `run.sh` script in this repository automates the process of updating the CIPster submodule, building the Windows and Linux versions, copying built library files to the respective release directories, modifying header files for Linux compatibility, copying header files to both Linux and Windows release directories, and creating zip files for the releases.

## Usage

1. Ensure you have the necessary build tools and dependencies installed on your system.
2. Execute the `run.sh` script with appropriate permissions to initiate the build process.
3. The script will automatically perform the following steps:
   - Update the CIPster submodule.
   - Build the Windows version.
   - Copy built library files to the release directory for Windows.
   - Modify header files for Linux compatibility.
   - Build the Linux version.
   - Copy built library files to the release directory for Linux.
   - Copy header files to both Linux and Windows release directories.
   - Create zip files for the Windows and Linux releases.

## Requirements

- CMake
- Make
- GCC (for Linux)
- MinGW64 (for Windows)

## Usage Example

```bash
./run.sh
```

## License

This project is licensed under the [MIT License](LICENSE).
