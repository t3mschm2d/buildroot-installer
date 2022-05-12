#!/bin/bash

# Author: Tim Schmid
# Installationscript for buildroot 

HLINE='---------------------------------------------------------------'
CONDA_CHECKER=$(which conda)

function install_requirements {
    echo -e  "\n$HLINE"
    echo -e "Check for mandatory packages"
    sudo apt install debianutils sed make binutils build-essential gcc-snapshot gcc g++ gzip bzip2 perl tar cpio unzip rsync file bc wget libncurses5-dev qt5-default libc6-i386 python3 curl u-boot-tools texinfo mtd-utils lzop libssl-dev gettext flex device-tree-compiler cmake bison device-tree-compiler libssl-dev lzop zip libasio-dev libtinyxml2-dev libp11-dev libengine-pkcs11-openssl softhsm2 swig libpython3-dev

    read -p "Please enter your Linux username: " RESP
        echo -e  "\n$HLINE"
        echo -e "Add $RESP to usergroup for softhsm"
        sudo usermod -a -G softhsm $RESP

    echo -e "$HLINE\n"
}

function install_conda {
    echo -e  "\n$HLINE"
    echo -e "Install miniconda3..."
    mkdir -p ~/miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
    rm -rf ~/miniconda3/miniconda.sh
    ~/miniconda3/bin/conda init bash
    ~/miniconda3/bin/conda init zsh
    echo -e "$HLINE\n"
}

function install_buildroot {
    echo -e "\n$HLINE"
    echo -e "\nRequirements installed"
    echo -e "Installing buildroot..."
    echo -e "\n$HLINE"
    curl -O https://buildroot.org/downloads/buildroot-2022.02.1.tar.gz
    mkdir buildroot
    tar xvf buildroot-2022.02.1.tar.gz
    cp -r buildroot-2022.02.1/. buildroot 
    rm -rf buildroot-2022.02.1.tar.gz
    rm -rf buildroot-2022.02.1
    clear
    echo -e  "\n$HLINE"
    echo -e "Buildroot toolchain can be found in directory buildroot - Have FUN :D"
    echo -e "$HLINE\n"
}

echo -e "\n$HLINE"
echo -e "Installation script for buildroot on Linux host system"
echo -e "$HLINE\n"

read -p "Do you wish to update and upgrade your existing packages? [y/n] " RESP
if [ "$RESP" == "y" ] || [ "$RESP" == "Y" ]; then
    echo -e  "\n$HLINE"
    echo -e "Processing Update..."
    sudo apt update && sudo apt upgrade
    echo -e "$HLINE\n" 
fi

install_requirements

read -p "Do you wish to install source fetching tools for buildroot [y/n] " RESP
if [ "$RESP" == "y" ] || [ "$RESP" == "Y" ]; then
    echo -e  "\n$HLINE"
    sudo apt install cvs git mercurial rsync subversion
    echo -e "$HLINE\n" 
fi

read -p "Do you whish to install miniconda? [y/n] " RESP
if [ "$RESP" == "y" ] || [ "$RESP" == "Y" ]; then
    echo -e  "\n$HLINE"

    if [ $CONDA_CHECKER = '' ]; then 
        install_conda
    else 
        echo -e "Conda already installed... exiting..."
    fi

    conda create -n linux python=3.8
    conda activate linux

    echo -e "$HLINE\n" 
fi

read -p "Do you want to install a clean version of the buildroot toolchain [y/n] " RESP
if [ "$RESP" == "y" ] || [ "$RESP" == "Y" ]; then
    echo -e  "\n$HLINE"
    install_buildroot
    echo -e "$HLINE\n" 
fi
