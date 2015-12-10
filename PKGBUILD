# Maintainer: Jan de Groot <jgc@archlinux.org>
# Maintainer: Andreas Radke <andyrtr@archlinux.org>

pkgbase=mesa
pkgname=('opencl-mesa' 'libva-mesa-driver' 'mesa-vdpau' 'mesa' 'mesa-libgl')
pkgver=11.0.7
pkgrel=1
arch=('i686' 'x86_64')
makedepends=('python2-mako' 'libxml2' 'libx11' 'glproto' 'libdrm' 'dri2proto' 'dri3proto' 'presentproto' 
             'libxshmfence' 'libxxf86vm' 'libxdamage' 'libvdpau' 'libva' 'wayland' 'elfutils' 'llvm'
             'systemd' 'libomxil-bellagio' 'libclc' 'clang')
url="http://mesa3d.sourceforge.net"
license=('custom')
source=(ftp://ftp.freedesktop.org/pub/mesa/${pkgver}/mesa-${pkgver}.tar.xz{,.sig}
        LICENSE)
sha256sums=('e7e90a332ede6c8fd08eff90786a3fd1605a4e62ebf3a9b514047838194538cb'
            'SKIP'
            '7fdc119cf53c8ca65396ea73f6d10af641ba41ea1dd2bd44a824726e01c8b3f2')
validpgpkeys=('8703B6700E7EE06D7A39B8D6EDAE37B02CEB490D') # Emil Velikov <emil.l.velikov@gmail.com>

prepare() {
  cd ${srcdir}/?esa-*

  # Fix detection of libLLVM when built with CMake
  sed -i 's/LLVM_SO_NAME=.*/LLVM_SO_NAME=LLVM/' configure
}

build() {
  cd ${srcdir}/?esa-*

  #autoreconf -vfi # our automake is far too new for their build system :)

  ./configure --prefix=/usr \
    --sysconfdir=/etc \
    --with-dri-driverdir=/usr/lib/xorg/modules/dri \
    --with-gallium-drivers=r300,r600,radeonsi,nouveau,svga,swrast \
    --with-dri-drivers=i915,i965,r200,radeon,nouveau,swrast \
    --with-egl-platforms=x11,drm,wayland \
    --enable-llvm-shared-libs \
    --enable-egl \
    --enable-gbm \
    --enable-gallium-llvm \
    --enable-shared-glapi \
    --enable-glx \
    --enable-glx-tls \
    --enable-dri \
    --enable-osmesa \
    --enable-gles1 \
    --enable-gles2 \
    --enable-texture-float \
    --enable-xa \
    --enable-vdpau \
    --enable-omx \
    --enable-nine \
    --enable-opencl --enable-opencl-icd \
    --with-clang-libdir=/usr/lib

    # --help

  make

  # fake installation
  mkdir $srcdir/fakeinstall
  make DESTDIR=${srcdir}/fakeinstall install
}

package_opencl-mesa() {
  pkgdesc="OpenCL support for AMD/ATI Radeon mesa drivers"
  depends=('expat' 'libdrm' 'elfutils' 'libxfixes' 'libxext' 'opencl-icd-loader' 'libclc' 'clang')
  optdepends=('opencl-headers: headers necessary for OpenCL development')
  
  install -m755 -d ${pkgdir}/etc
  mv -v ${srcdir}/fakeinstall/etc/OpenCL ${pkgdir}/etc/
  
  install -m755 -d ${pkgdir}/usr/lib/gallium-pipe
  mv -v ${srcdir}/fakeinstall/usr/lib/lib*OpenCL* ${pkgdir}/usr/lib/
  mv -v ${srcdir}/fakeinstall/usr/lib/gallium-pipe/pipe_{r600,radeonsi}.so ${pkgdir}/usr/lib/gallium-pipe/

  install -m755 -d "${pkgdir}/usr/share/licenses/opencl-mesa"
  install -m644 "${srcdir}/LICENSE" "${pkgdir}/usr/share/licenses/opencl-mesa/"
}

package_libva-mesa-driver() {
  pkgdesc="VA-API implementation for gallium"
  depends=('libdrm' 'libx11' 'llvm-libs' 'expat' 'elfutils')

  install -m755 -d ${pkgdir}/usr/lib
  mv -v ${srcdir}/fakeinstall/usr/lib/dri ${pkgdir}/usr/lib
   
  install -m755 -d "${pkgdir}/usr/share/licenses/libva-mesa-driver"
  install -m644 "${srcdir}/LICENSE" "${pkgdir}/usr/share/licenses/libva-mesa-driver/"
}

package_mesa-vdpau() {
  pkgdesc="Mesa VDPAU drivers"
  depends=('libdrm' 'libx11' 'llvm-libs' 'expat' 'elfutils')

  install -m755 -d ${pkgdir}/usr/lib
  mv -v ${srcdir}/fakeinstall/usr/lib/vdpau ${pkgdir}/usr/lib
   
  install -m755 -d "${pkgdir}/usr/share/licenses/mesa-vdpau"
  install -m644 "${srcdir}/LICENSE" "${pkgdir}/usr/share/licenses/mesa-vdpau/"
}

package_mesa() {
  pkgdesc="an open-source implementation of the OpenGL specification"
  depends=('libdrm' 'wayland' 'libxxf86vm' 'libxdamage' 'libxshmfence' 'systemd' 'elfutils' 
           'libomxil-bellagio' 'expat' 'libtxc_dxtn' 'llvm-libs')
  optdepends=('opengl-man-pages: for the OpenGL API man pages'
              'mesa-vdpau: for accelerated video playback'
              'libva-mesa-driver: for accelerated video playback')
  provides=('libglapi' 'osmesa' 'libgbm' 'libgles' 'libegl' 'khrplatform-devel'
            'ati-dri' 'intel-dri' 'nouveau-dri' 'svga-dri' 'mesa-dri')
  conflicts=('libglapi' 'osmesa' 'libgbm' 'libgles' 'libegl' 'khrplatform-devel'
             'ati-dri' 'intel-dri' 'nouveau-dri' 'svga-dri' 'mesa-dri')
  replaces=('libglapi' 'osmesa' 'libgbm' 'libgles' 'libegl' 'khrplatform-devel'
            'ati-dri' 'intel-dri' 'nouveau-dri' 'svga-dri' 'mesa-dri')

  install -m755 -d ${pkgdir}/etc
  mv -v ${srcdir}/fakeinstall/etc/drirc ${pkgdir}/etc
  
  install -m755 -d ${pkgdir}/usr/lib/xorg/modules/dri
  # ati-dri, nouveau-dri, intel-dri, svga-dri, swrast
  mv -v ${srcdir}/fakeinstall/usr/lib/xorg/modules/dri/* ${pkgdir}/usr/lib/xorg/modules/dri
   
  mv -v ${srcdir}/fakeinstall/usr/lib/bellagio  ${pkgdir}/usr/lib
  mv -v ${srcdir}/fakeinstall/usr/lib/d3d  ${pkgdir}/usr/lib
  mv -v ${srcdir}/fakeinstall/usr/lib/*.so* ${pkgdir}/usr/lib/

  mv -v ${srcdir}/fakeinstall/usr/include ${pkgdir}/usr
  mv -v ${srcdir}/fakeinstall/usr/lib/pkgconfig ${pkgdir}/usr/lib/
  
  install -m755 -d ${pkgdir}/usr/lib/mesa
  # move libgl/EGL/glesv*.so to not conflict with blobs - may break .pc files ?
  mv -v ${pkgdir}/usr/lib/libGL.so* 	${pkgdir}/usr/lib/mesa/
  mv -v ${pkgdir}/usr/lib/libEGL.so* 	${pkgdir}/usr/lib/mesa/
  mv -v ${pkgdir}/usr/lib/libGLES*.so*	${pkgdir}/usr/lib/mesa/

  install -m755 -d "${pkgdir}/usr/share/licenses/mesa"
  install -m644 "${srcdir}/LICENSE" "${pkgdir}/usr/share/licenses/mesa/"
}

package_mesa-libgl() {
  pkgdesc="Mesa 3-D graphics library"
  depends=('mesa')
  provides=('libgl')
  replaces=('libgl')
 
  # See FS#26284
  install -m755 -d "${pkgdir}/usr/lib/xorg/modules/extensions"
  ln -s libglx.xorg "${pkgdir}/usr/lib/xorg/modules/extensions/libglx.so"

  ln -s /usr/lib/mesa/libGL.so.1.2.0 ${pkgdir}/usr/lib/libGL.so.1.2.0
  ln -s libGL.so.1.2.0	             ${pkgdir}/usr/lib/libGL.so.1
  ln -s libGL.so.1.2.0               ${pkgdir}/usr/lib/libGL.so

  ln -s /usr/lib/mesa/libEGL.so.1.0.0 ${pkgdir}/usr/lib/libEGL.so.1.0.0
  ln -s libEGL.so.1.0.0	              ${pkgdir}/usr/lib/libEGL.so.1
  ln -s libEGL.so.1.0.0               ${pkgdir}/usr/lib/libEGL.so

  ln -s /usr/lib/mesa/libGLESv1_CM.so.1.1.0 ${pkgdir}/usr/lib/libGLESv1_CM.so.1.1.0
  ln -s libGLESv1_CM.so.1.1.0	            ${pkgdir}/usr/lib/libGLESv1_CM.so.1
  ln -s libGLESv1_CM.so.1.1.0               ${pkgdir}/usr/lib/libGLESv1_CM.so

  ln -s /usr/lib/mesa/libGLESv2.so.2.0.0 ${pkgdir}/usr/lib/libGLESv2.so.2.0.0
  ln -s libGLESv2.so.2.0.0               ${pkgdir}/usr/lib/libGLESv2.so.2
  ln -s libGLESv2.so.2.0.0               ${pkgdir}/usr/lib/libGLESv2.so

  install -m755 -d "${pkgdir}/usr/share/licenses/mesa-libgl"
  install -m644 "${srcdir}/LICENSE" "${pkgdir}/usr/share/licenses/mesa-libgl/"
}
