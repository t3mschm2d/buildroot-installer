#!/bin/bash

# Author: Tim Schmid
# Installationscript for eProsima DDS

HLINE='---------------------------------------------------------------'

echo -e "\n$HLINE"
echo -e "Installation script for buildroot on Linux host system"
echo -e "$HLINE\n"

function install_foonathan_memory {
    echo -e "\n$HLINE"
    Path=$1
    git clone https://github.com/eProsima/foonathan_memory_vendor.git "$Path/foonathan_memory_vendor"
    echo -e "Generating and changing to director $Path/foonathan_memory_vendor/build"
    mkdir -p "$Path/foonathan_memory_vendor/build"
    cd "$Path/foonathan_memory_vendor/build"
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local/ -DBUILD_SHARED_LIBS=ON 
    echo -e "Installing Foonathan Memory Lib globally on the machine"
    sudo cmake --build . --target install
    echo -e "$HLINE\n"
}

function install_fastcdr {
    echo -e "\n$HLINE"
    Path=$1
    git clone https://github.com/eProsima/Fast-CDR.git "$Path/fast_cdr"
    echo -e "Generating and changing to directory: $Path/fast_cdr/build"
    mkdir -p "$Path/fast_cdr/build"
    cd "$Path/fast_cdr/build"
    echo -e "Installing FastCDR globally on the machine"
    sudo cmake ..
    sudo cmake --build . --target install
    echo -e "$HLINE\n"
}

function install_fastdds {
    echo -e "\n$HLINE"
    Path=$1
    install_foonathan_memory $Path
    install_fastcdr $Path
    git clone https://github.com/eProsima/Fast-DDS.git "$Path/fast_dds"
    echo -e "Generating and changing to directory: $Path/fast_dds/build"
    mkdir -p "$Path/fast_dds/build"
    cd "$Path/fast_dds/build"
    echo -e "Installing FastDDS globally on the machine"
    sudo cmake ..
    sudo cmake --build . --target install
    echo -e "$HLINE\n"
}

function creat_lib_path_variable {
    Path=$1
    if [[ -z "${LD_LIBRARY_PATH}" ]]; then
        echo 'export LD_LIBRARY_PATH=/usr/local/lib/' >> "$HOME/.bashrc"
        echo -e "Environment Variable created"
    else
        echo -e "Environment Variable already exists, exiting"
    fi
}

read -p "Do you want to install eProsima FastDDS globally on your PC? [y/n] " RESP
if [ "$RESP" == "y" ] || [ "$RESP" == "Y" ]; then
    read -p "Please provide a path for installation: " RESP
        mkdir -p "$RESP"
        echo -e "Created path at $RESP"
        install_fastdds $RESP
        creat_lib_path_variable $RESP
fi