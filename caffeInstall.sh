# Copy Caffe Makefile configuration to home directory
cp ./Makefile.config ~/Makefile.config

# Update original packages
sudo apt-get update

# Change directory to home
cd ~

# Get git
sudo apt-get install -y git

# Compile newest version of cmake
sudo apt-get install -y build-essential
sudo apt-get install -y cmake
wget http://www.cmake.org/files/v3.2/cmake-3.2.2.tar.gz
tar -xvzf cmake-3.2.2.tar.gz
cd cmake-3.2.2
mkdir _build && cd _build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
make
sudo make install
sudo ldconfig
# Change directory to home
cd ~

# General Caffe prereqs
sudo apt-get install -y libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libboost-all-dev libhdf5-serial-dev

### Caffe dependencies for Ubuntu 12.04 ###

# glog
wget https://google-glog.googlecode.com/files/glog-0.3.3.tar.gz
tar zxvf glog-0.3.3.tar.gz
cd glog-0.3.3
./configure
make
sudo make install
cd ~

# gflags
wget https://github.com/schuhschuh/gflags/archive/master.zip
unzip master.zip
cd gflags-master
mkdir build && cd build
export CXXFLAGS="-fPIC" && cmake .. && make VERBOSE=1
make
sudo make install
cd ~

# lmdb
git clone git://gitorious.org/mdb/mdb.git
cd mdb/libraries/liblmdb
make
sudo make install
cd ~

### Install BLAS ###
sudo apt-get install -y libatlas-base-dev

### Install Python (needed here to build Caffe Python modules) ###
sudo apt-get install -y python-dev
sudo apt-get install -y python-pip

### Caffe install ###

# Copy Caffe repo
git clone https://github.com/BVLC/caffe.git
cd caffe

# Install prereqs for using Python interface for Caffe
sudo apt-get install -y python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-nose

# Install scikit-image
sudo easy_install -U distribute
sudo pip install -U scikit-image
# Remove build folder that pip created
sudo rm -rf build

# Compile Caffe with modified Makefile.config
cp ~/Makefile.config Makefile.config
make all
make test
make runtest
# Compile Python wrapper
make pycaffe
# Add Caffe to Python path when user opens a terminal
# TODO: Find a better way to add Caffe to the Python path
echo "export PYTHONPATH=/home/ryan/caffe/python:$PYTHONPATH" >> ~/.bashrc
