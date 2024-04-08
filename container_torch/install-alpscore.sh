#!/bin/bash

working_dir=$(eval echo ~user)
cd $working_dir
git clone https://github.com/MKrbm/ALPSCore.git
cd ALPSCore/
mkdir build && cd build
cmake .. 
make && make install
cd ../../ && rm -rf ALPSCore/
