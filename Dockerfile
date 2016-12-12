# Dockerfile to build environment with python2 and opencv3

FROM resin/rpi-raspbian:latest
MAINTAINER Andrey Alekseenko <al42and@gmail.com>

# apt-get first
RUN apt-get update && apt-get install -qy \
	cmake \
	python-numpy python-scipy python-pip python-setuptools \
	wget \
	xauth \
	libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev  libavcodec-dev libavformat-dev \
	libswscale-dev libv4l-dev  libxvidcore-dev libx264-dev libgtk2.0-dev  libatlas-base-dev \
	gfortran  python2.7-dev build-essential pkg-config

# sklearn
RUN pip install -U scikit-learn && rm -rf '/root/.cache/pip/'

# Build OpenCV 3.1
RUN \
	cd /root && \
	wget https://github.com/opencv/opencv/archive/master.tar.gz -O opencv.tar.gz && \
	tar zxf opencv.tar.gz && rm -f opencv.tar.gz && \
	wget https://github.com/opencv/opencv_contrib/archive/master.tar.gz -O contrib.tar.gz && \
	tar zxf contrib.tar.gz && rm -f contrib.tar.gz && \
	cd opencv-master && mkdir build && cd build && \
	cmake -D CMAKE_BUILD_TYPE=RELEASE \
		-D CMAKE_INSTALL_PREFIX=/usr/local \
		-D INSTALL_PYTHON_EXAMPLES=OFF \
		-D OPENCV_EXTRA_MODULES_PATH=/root/opencv_contrib-master/modules \
		-D BUILD_DOCS=OFF \
		-D BUILD_TESTS=OFF \
		-D BUILD_EXAMPLES=OFF \
		-D BUILD_opencv_python3=OFF \
		-D ENABLE_NEON=ON \
		-D WITH_1394=OFF \
		-D WITH_MATLAB=OFF \
		-D WITH_OPENCL=OFF \
		-D WITH_OPENCLAMDBLAS=OFF \
		-D WITH_OPENCLAMDFFT=OFF \
		-D CMAKE_CXX_FLAGS="-O3 -mcpu=cortex-a53 -mfpu=neon-fp-armv8 -mfloat-abi=hard -funsafe-math-optimizations" \
		-D CMAKE_C_FLAGS="-O3 -mcpu=cortex-a53 -mfpu=neon-fp-armv8 -mfloat-abi=hard -funsafe-math-optimizations" \
		.. && make -j2 && make install && \
	cd /root && rm -rf opencv-master opencv_contrib-master

# Remove temporary packages, but keep ones needed by opencv
RUN apt-get install -qy libv4l-0 libavcodec-dev libavformat-dev libavutil-dev \ 
	libswscale-dev libavresample-dev && \
	apt-get purge -qy \
	build-essential \
	libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev \
	libv4l-dev libxvidcore-dev libx264-dev libgtk2.0-dev  libatlas-base-dev \
	gfortran pkg-config cmake && rm -rf /var/lib/apt/lists/*

RUN mkdir /app

