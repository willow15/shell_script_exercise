#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 tesseract-ocr version info(305 or 400)"
  exit -1
fi

cd /opt
yum makecache
yum install -y autoconf automake libtool libjpeg-devel libpng-devel libtiff-devel zlib-devel
yum install -y giflib giflib-devel
yum install -y autoconf-archive
yum install -y wget

# install leptonica
wget http://www.leptonica.org/source/leptonica-1.74.4.tar.gz
tar -zxvf leptonica-1.74.4.tar.gz
cd leptonica-1.74.4/
./configure --prefix=/usr/local/leptonica
make
make install

echo -e "\n#add on `date`" >> /etc/profile
echo -e '\nPKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/leptonica/lib/pkgconfig\n
export PKG_CONFIG_PATH\n
CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:/usr/local/leptonica/include/leptonica\n
export CPLUS_INCLUDE_PATH\n
C_INCLUDE_PATH=$C_INCLUDE_PATH:/usr/local/leptonica/include/leptonica\n
export C_INCLUDE_PATH\n
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/leptonica/lib\n
export LD_LIBRARY_PATH\n
LIBRARY_PATH=$LIBRARY_PATH:/usr/local/leptonica/lib\n
export LIBRARY_PATH\n
LIBLEPT_HEADERSDIR=/usr/local/leptonica/include/leptonica\n
export LIBLEPT_HEADERSDIR\n' >> /etc/profile

source /etc/profile


cd ..
# install tesseract-ocr 3.05.02 Release
if [ $1 -eq 305 ]; then
  wget https://github.com/tesseract-ocr/tesseract/archive/3.05.02.tar.gz
  tar -zxvf 3.05.02.tar.gz
  cd tesseract-3.05.02
  ./autogen.sh
  ./configure --prefix=/usr/local/tesseract --with-extra-libraries=/usr/local/leptonica/lib
  make
  make install
 
  echo -e "\n#add on `date`" >> /etc/profile
  echo -e '\nPATH=$PATH:/usr/local/tesseract/bin\n
  export PATH\n' >> /etc/profile

  source /etc/profile
# install tesseract-ocr 4.0.0-beta.1
elif [ $1 -eq 400 ]; then
  wget https://github.com/tesseract-ocr/tesseract/archive/4.0.0-beta.1.tar.gz
  tar -zxvf 4.0.0-beta.1.tar.gz
  cd tesseract-4.0.0-beta.1
  ./autogen.sh
  ./configure --prefix=/usr/local/tesseract --with-extra-libraries=/usr/local/leptonica/lib
  make
  make install
  
  echo -e "\n#add on `date`" >> /etc/profile
  echo -e '\nPATH=$PATH:/usr/local/tesseract/bin\n
  export PATH\n' >> /etc/profile

  source /etc/profile
fi


# show tesseract-ocr and leptonica info
tesseract -v
