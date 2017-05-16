FROM ubuntu:16.04

MAINTAINER elementli <yonglisc@gmail.com>

USER root
ARG NUM_CORES=2

# Add openMVG binaries to path
ENV PATH $PATH:/opt/openMVG_Build/install/bin

# Dependencies

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    mercurial \
    cmake \
    graphviz \
    gcc-4.8 \
    gcc-4.8-multilib \
    libpng-dev \
    libjpeg-dev \
    libtiff-dev \
    libxxf86vm1 \
    libxxf86vm-dev \
    libxi-dev \
    libxrandr-dev \
    python-dev \
    python-pip \
    libglu1-mesa-dev \
    libboost-iostreams-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libboost-serialization-dev \
    libopencv-dev \
    libcgal-dev \
    libcgal-qt5-dev \
    libatlas-base-dev \
    libsuitesparse-dev

# Clone the openvMVG repo
RUN git clone https://github.com/baritone/openMVG /opt/openMVG
RUN cd /opt/openMVG && git submodule update --init --recursive

# Build
RUN mkdir /opt/openMVG_Build && cd /opt/openMVG_Build && cmake -DCMAKE_BUILD_TYPE=RELEASE \
  -DCMAKE_INSTALL_PREFIX="/opt/openMVG_Build/install" -DOpenMVG_BUILD_TESTS=ON \
  -DOpenMVG_BUILD_EXAMPLES=ON . ../openMVG/src/ && make -j $NUM_CORES

RUN cd /opt/openMVG_Build && make test

ENV PATH=/opt/openMVG_Build/Linux-x86_64-RELEASE:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

WORKDIR "/root"

# Eigen
RUN mkdir eigen && cd eigen
WORKDIR "/root/eigen"
RUN hg clone https://bitbucket.org/eigen/eigen#3.2 /root/eigen/eigen
RUN mkdir eigen_build
RUN cd eigen_build
RUN cmake . /root/eigen/eigen
RUN make && make install && cd .. && cd ..

# Ceres
RUN mkdir ceres && cd ceres
WORKDIR "/root/ceres"
RUN git clone https://ceres-solver.googlesource.com/ceres-solver /root/ceres/ceres-solver
RUN mkdir ceres_Build && cd ceres_Build
RUN cmake . /root/ceres/ceres-solver -DMINIGLOG=ON -DBUILD_TESTING=OFF -DBUILD_EXAMPLES=OFF
RUN make && make install && cd .. && cd ..


# VCGLib

RUN git clone https://github.com/cdcseacave/VCG.git /root/vcglib


# OpenMVS
RUN mkdir openMVS && cd openMVS
WORKDIR "/root/openMVS"
RUN git clone https://github.com/cdcseacave/openMVS.git /root/openMVS/openMVS
RUN mkdir openMVS_Build && cd openMVS_Build
RUN cmake . /root/openMVS/openMVS -DCMAKE_BUILD_TYPE=RELEASE -DVCG_DIR="/root/vcglib"
RUN make && make install

ENV PATH=/usr/local/bin/OpenMVS:$PATH


# cleanup
RUN ldconfig && \
    apt-get autoclean && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR "/home"
CMD ["/bin/bash"]