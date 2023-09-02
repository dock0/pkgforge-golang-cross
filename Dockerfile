FROM ghcr.io/dock0/pkgforge-golang:20230901-84ad391
RUN pacman -S --noconfirm --needed clang cmake python

ENV OSX_CROSS_PATH=/opt/osxcross
ENV OSX_SDK=MacOSX11.3.sdk

RUN git clone https://github.com/tpoechtrager/osxcross.git "${OSX_CROSS_PATH}"
ADD https://storage.googleapis.com/ory.sh/build-assets/${OSX_SDK}.tar.xz "${OSX_CROSS_PATH}/tarballs/${OSX_SDK}.tar.xz"

RUN UNATTENDED=yes /opt/osxcross/build.sh
ENV PATH=${OSX_CROSS_PATH}/target/bin:$PATH

