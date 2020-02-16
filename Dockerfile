FROM docker.pkg.github.com/dock0/pkgforge-golang/pkgforge-golang:20200216-eb94360
RUN pacman -S --noconfirm --needed clang cmake python

RUN git clone https://github.com/tpoechtrager/osxcross.git /opt/osxcross

ENV OSX_SDK=MacOSX10.11.sdk
ENV OSX_NDK_X86=/usr/local/osx-ndk-x86
ENV OSX_SDK_VERSION=10.11
ENV OSX_SDK_FILE="MacOSX${OSX_SDK_VERSION}.sdk.tar.xz"
ENV OSX_SDK_URL="https://s3.dockerproject.org/darwin/v2/${OSX_SDK_FILE}"
ENV OSX_SDK_PATH="/opt/osxcross/tarballs/${OSX_SDK_FILE}"
ENV OSX_SDK_CHECKSUM=694a66095a3514328e970b14978dc78c0f4d170e590fa7b2c3d3674b75f0b713

RUN curl -sLo "$OSX_SDK_PATH" "$OSX_SDK_URL"
RUN if [[ "$(sha256sum "${OSX_SDK_PATH}" | cut -d' ' -f1)" != "${OSX_SDK_CHECKSUM}" ]] ; then echo 'OSX SDK Checksum mismatch' && exit 1 ; fi

RUN sed -i -e 's|-march=native||g' /opt/osxcross/build_clang.sh
RUN UNATTENDED=yes /opt/osxcross/build.sh
RUN mv "/opt/osxcross/target" "$OSX_NDK_X86"
ADD patch.tar.xz $OSX_NDK_X86/SDK/$OSX_SDK/usr/include/c++

ENV PATH="$OSX_NDK_X86/bin:$PATH"
