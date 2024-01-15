FROM ghcr.io/dock0/pkgforge-golang:20240115-51e89c8
RUN pacman -S --noconfirm --needed clang cmake python

ENV OSX_CROSS_PATH=/opt/osxcross
ENV OSX_SDK_VERSION=14.0
ENV OSX_SDK=MacOSX${OSX_SDK_VERSION}.sdk

RUN git clone https://github.com/tpoechtrager/osxcross.git "${OSX_CROSS_PATH}"
ADD https://github.com/joseluisq/macosx-sdks/releases/download/${OSX_SDK_VERSION}/${OSX_SDK}.tar.xz "${OSX_CROSS_PATH}/tarballs/${OSX_SDK}.tar.xz"

RUN UNATTENDED=yes /opt/osxcross/build.sh
ENV PATH=${OSX_CROSS_PATH}/target/bin:$PATH

