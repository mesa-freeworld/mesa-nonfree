# Maintainer: Jan de Groot <jgc@archlinux.org>
# Maintainer: Andreas Radke <andyrtr@archlinux.org>

pkgbase=mesa
pkgname=('mesa' 'libgl' 'libglapi' 'libgles' 'libegl' 'ati-dri' 'intel-dri' 'unichrome-dri' 'mach64-dri' 'mga-dri' 'r128-dri' 'savage-dri' 'sis-dri' 'tdfx-dri' 'nouveau-dri') # 'llvm-dri')

#_git=true
_git=false

if [ "${_git}" = "true" ]; then
    #pkgver=7.10.99.git20110709
    pkgver=7.11
  else
    pkgver=7.11
fi
pkgrel=1
arch=('i686' 'x86_64')
makedepends=('glproto>=1.4.14' 'libdrm>=2.4.26' 'libxxf86vm>=1.1.1' 'libxdamage>=1.1.3' 'expat>=2.0.1' 'libx11>=1.4.3' 'libxt>=1.1.1' 
             'gcc-libs>=4.6.1' 'dri2proto>=2.6' 'python2' 'libxml2' 'imake' 'llvm' 'udev')
url="http://mesa3d.sourceforge.net"
license=('custom')
source=(LICENSE)
if [ "${_git}" = "true" ]; then
	# mesa git shot from 7.11 branch - see for state: http://cgit.freedesktop.org/mesa/mesa/commit/?h=7.11&id=1ae00c5960af83bea9545a18a1754bad83d5cbd0
	#source=(${source[@]} 'ftp://ftp.archlinux.org/other/mesa/mesa-1ae00c5960af83bea9545a18a1754bad83d5cbd0.tar.bz2')
	source=(${source[@]} "MesaLib-${pkgver}.zip"::"http://cgit.freedesktop.org/mesa/mesa/snapshot/mesa-ef9f16f6322a89fb699fbe3da868b10f9acaef98.tar.bz2")
  else
	source=(${source[@]} "ftp://ftp.freedesktop.org/pub/mesa/${pkgver}/MesaLib-${pkgver}.tar.bz2"
)
fi
md5sums=('5c65a0fe315dd347e09b1f2826a1df5a'
         'ff03aca82d0560009a076a87c888cf13')

build() {
    cd ${srcdir}/?esa-*

if [ "${_git}" = "true" ]; then
    autoreconf -vfi
    ./autogen.sh --prefix=/usr \
    --with-dri-driverdir=/usr/lib/xorg/modules/dri \
    --with-gallium-drivers=r300,r600,nouveau,swrast \
    --enable-gallium-llvm \
    --enable-gallium-egl --enable-shared-glapi\
    --enable-glx-tls \
    --with-driver=dri \
    --enable-xcb \
    --disable-glut \
    --enable-gles1 \
    --enable-gles2 \
    --enable-egl \
    --enable-texture-float \
    --enable-shared-dricore
    
    #    --enable-gallium-svga \
    
  else
     autoreconf -vfi
    ./configure --prefix=/usr \
    --with-dri-driverdir=/usr/lib/xorg/modules/dri \
    --with-gallium-drivers=r300,r600,nouveau,swrast \
    --enable-gallium-llvm \
    --enable-gallium-egl --enable-shared-glapi\
    --enable-glx-tls \
    --with-driver=dri \
    --enable-xcb \
    --disable-glut \
    --enable-gles1 \
    --enable-gles2 \
    --enable-egl \
    --enable-texture-float \
    --enable-shared-dricore
fi

  make
}

package_libgl() {
  depends=('libdrm>=2.4.26' 'libxxf86vm>=1.1.1' 'libxdamage>=1.1.3' 'expat>=2.0.1' 'libglapi' 'gcc-libs')
  pkgdesc="Mesa 3-D graphics library and DRI software rasterizer"

  cd ${srcdir}/?esa-*
  install -m755 -d "${pkgdir}/usr/lib"
  install -m755 -d "${pkgdir}/usr/lib/xorg/modules/extensions"

  bin/minstall lib/libGL.so* "${pkgdir}/usr/lib/"
  bin/minstall lib/libdricore.so* "${pkgdir}/usr/lib/"
  bin/minstall lib/libglsl.so* "${pkgdir}/usr/lib/"

  cd src/mesa/drivers/dri
  #make -C swrast DESTDIR="${pkgdir}" install
if [ "${_git}" = "true" ]; then
    make -C ${srcdir}/mesa-*/src/gallium/targets/dri-swrast DESTDIR="${pkgdir}" install
  else
    make -C ${srcdir}/Mesa-${pkgver/rc/-rc}/src/gallium/targets/dri-swrast DESTDIR="${pkgdir}" install
fi
  ln -s swrastg_dri.so "${pkgdir}/usr/lib/xorg/modules/dri/swrast_dri.so"
  ln -s libglx.xorg "${pkgdir}/usr/lib/xorg/modules/extensions/libglx.so"

  install -m755 -d "${pkgdir}/usr/share/licenses/libgl"
  install -m644 "${srcdir}/LICENSE" "${pkgdir}/usr/share/licenses/libgl/"
}

package_libglapi() {
  depends=('glibc')
  pkgdesc="free implementation of the GL API -- shared library. The Mesa GL API module is responsible for dispatching all the gl* functions"

  cd ${srcdir}/?esa-*   
  install -m755 -d "${pkgdir}/usr/lib"
  bin/minstall lib/libglapi.so* "${pkgdir}/usr/lib/"

  install -m755 -d "${pkgdir}/usr/share/licenses/libglapi"
  install -m644 "${srcdir}/LICENSE" "${pkgdir}/usr/share/licenses/libglapi/"
}

package_libgles() {
  depends=('libglapi')
  pkgdesc="Mesa GLES libraries and headers"

  cd ${srcdir}/?esa-*   
  install -m755 -d "${pkgdir}/usr/lib"
  install -m755 -d "${pkgdir}/usr/lib/pkgconfig"
  install -m755 -d "${pkgdir}/usr/include"
  install -m755 -d "${pkgdir}/usr/include/GLES"
  install -m755 -d "${pkgdir}/usr/include/GLES2"
  bin/minstall lib/libGLESv* "${pkgdir}/usr/lib/"
  bin/minstall src/mapi/es1api/glesv1_cm.pc "${pkgdir}/usr/lib/pkgconfig/"
  bin/minstall src/mapi/es2api/glesv2.pc "${pkgdir}/usr/lib/pkgconfig/"
  bin/minstall include/GLES/* "${pkgdir}/usr/include/GLES/"
  bin/minstall include/GLES2/* "${pkgdir}/usr/include/GLES2/"
  bin/minstall include/GLES2/* "${pkgdir}/usr/include/GLES2/"

  install -m755 -d "${pkgdir}/usr/share/licenses/libgles"
  install -m644 "${srcdir}/LICENSE" "${pkgdir}/usr/share/licenses/libgles/"
}

package_libegl() {
  depends=('libglapi' 'libdrm' 'libxext' 'libxfixes' 'udev')
  pkgdesc="Mesa EGL libraries and headers"

  cd ${srcdir}/?esa-*   
  make -C src/gallium/targets/egl-static DESTDIR="${pkgdir}" install
  install -m755 -d "${pkgdir}/usr/lib"
  install -m755 -d "${pkgdir}/usr/lib/pkgconfig"
  install -m755 -d "${pkgdir}/usr/include"
  install -m755 -d "${pkgdir}/usr/include/"
  install -m755 -d "${pkgdir}/usr/include/EGL"
  install -m755 -d "${pkgdir}/usr/include/KHR"
  install -m755 -d "${pkgdir}/usr/share"
  install -m755 -d "${pkgdir}/usr/share/doc"
  install -m755 -d "${pkgdir}/usr/share/doc/libegl"
  bin/minstall lib/libEGL.so* "${pkgdir}/usr/lib/"
  install -m755 -d "${pkgdir}/usr/lib/egl"
  bin/minstall lib/egl/* "${pkgdir}/usr/lib/egl/"
  bin/minstall src/egl/main/egl.pc "${pkgdir}/usr/lib/pkgconfig/"
  bin/minstall include/EGL/* "${pkgdir}/usr/include/EGL/"
  bin/minstall include/KHR/khrplatform.h "${pkgdir}/usr/include/KHR/"
  bin/minstall docs/egl.html "${pkgdir}/usr/share/doc/libegl/"

  install -m755 -d "${pkgdir}/usr/share/licenses/libegl"
  install -m644 "${srcdir}/LICENSE" "${pkgdir}/usr/share/licenses/libegl/"
}

package_mesa() {
  depends=('libgl' 'libx11>=1.4.3' 'libxt>=1.1.1' 'gcc-libs>=4.6') # 'dri2proto>=2.6' 'glproto>=1.4.14')
  optdepends=('opengl-man-pages: for the OpenGL API man pages')
  pkgdesc="Mesa 3-D graphics libraries and include files"

  cd ${srcdir}/?esa-*   
  make DESTDIR="${pkgdir}" install

  rm -f "${pkgdir}/usr/lib/libGL.so"*
  rm -f "${pkgdir}/usr/lib/libglapi.so"*
  rm -f "${pkgdir}/usr/lib/libGLESv"*
  rm -f "${pkgdir}/usr/lib/libEGL"*
  rm -rf "${pkgdir}/usr/lib/egl"
  rm -f ${pkgdir}/usr/lib/pkgconfig/{glesv1_cm.pc,glesv2.pc,egl.pc}
  rm -rf "${pkgdir}/usr/lib/xorg"
  rm -f "${pkgdir}/usr/include/GL/glew.h"
  rm -f "${pkgdir}/usr/include/GL/glxew.h"
  rm -f "${pkgdir}/usr/include/GL/wglew.h"
  rm -f "${pkgdir}/usr/include/GL/glut.h"
  rm -rf ${pkgdir}/usr/include/{GLES,GLES2,EGL,KHR}

  install -m755 -d "${pkgdir}/usr/share/licenses/mesa"
  install -m644 "${srcdir}/LICENSE" "${pkgdir}/usr/share/licenses/mesa/"
}

package_ati-dri() {
  depends=("libgl=${pkgver}")
  pkgdesc="Mesa DRI radeon/r200 + Gallium3D r300,r600 drivers for AMD/ATI Radeon"
  conflicts=('xf86-video-ati<6.9.0-6')

  # classic mesa drivers for radeon,r200
  make -C ${srcdir}/?esa-*/src/mesa/drivers/dri/radeon DESTDIR="${pkgdir}" install
  make -C ${srcdir}/?esa-*/src/mesa/drivers/dri/r200 DESTDIR="${pkgdir}" install
  # gallium3D driver for r300,r600
  make -C ${srcdir}/?esa-*/src/gallium/targets/dri-r300 DESTDIR="${pkgdir}" install
  make -C ${srcdir}/?esa-*/src/gallium/targets/dri-r600 DESTDIR="${pkgdir}" install
}

package_intel-dri() {
  depends=("libgl=${pkgver}")
  pkgdesc="Mesa DRI drivers for Intel"

  make -C ${srcdir}/?esa-*/src/mesa/drivers/dri/i810 DESTDIR="${pkgdir}" install
  make -C ${srcdir}/?esa-*/src/mesa/drivers/dri/i915 DESTDIR="${pkgdir}" install
  make -C ${srcdir}/?esa-*/src/mesa/drivers/dri/i965 DESTDIR="${pkgdir}" install
}

package_unichrome-dri() {
  depends=("libgl=${pkgver}")
  pkgdesc="Mesa DRI drivers for S3 Graphics/VIA Unichrome"

  make -C ${srcdir}/?esa-*/src/mesa/drivers/dri/unichrome DESTDIR="${pkgdir}" install
}

package_mach64-dri() {
  depends=("libgl=${pkgver}")
  pkgdesc="Mesa DRI drivers for ATI Mach64"
  conflicts=('xf86-video-mach64<6.8.2')

  make -C ${srcdir}/?esa-*/src/mesa/drivers/dri/mach64 DESTDIR="${pkgdir}" install
}

package_mga-dri() {
  depends=("libgl=${pkgver}")
  pkgdesc="Mesa DRI drivers for Matrox"
  conflicts=('xf86-video-mga<1.4.11')

  make -C ${srcdir}/?esa-*/src/mesa/drivers/dri/mga DESTDIR="${pkgdir}" install
}

package_r128-dri() {
  depends=("libgl=${pkgver}")
  pkgdesc="Mesa DRI drivers for ATI Rage128"
  conflicts=('xf86-video-r128<6.8.1')

  make -C ${srcdir}/?esa-*/src/mesa/drivers/dri/r128 DESTDIR="${pkgdir}" install
}

package_savage-dri() {
  depends=("libgl=${pkgver}")
  pkgdesc="Mesa DRI drivers for S3 Sraphics/VIA Savage"
  conflicts=('xf86-video-savage<2.3.1')

  make -C ${srcdir}/?esa-*/src/mesa/drivers/dri/savage DESTDIR="${pkgdir}" install
}

package_sis-dri() {
  depends=("libgl=${pkgver}")
  pkgdesc="Mesa DRI drivers for SiS"
  conflicts=('xf86-video-sis<0.10.2')

  make -C ${srcdir}/?esa-*/src/mesa/drivers/dri/sis DESTDIR="${pkgdir}" install
}

package_tdfx-dri() {
  depends=("libgl=${pkgver}")
  pkgdesc="Mesa DRI drivers for 3dfx"
  conflicts=('xf86-video-tdfx<1.4.3')

  make -C ${srcdir}/?esa-*/src/mesa/drivers/dri/tdfx DESTDIR="${pkgdir}" install
}

package_nouveau-dri() {
  depends=("libgl=${pkgver}")
  pkgdesc="Mesa classic DRI + Gallium3D drivers for Nouveau"

  # classic mesa driver for nv10 , nv20 nouveau_vieux_dri.so
  make -C ${srcdir}/?esa-*/src/mesa/drivers/dri/nouveau DESTDIR="${pkgdir}" install
  # gallium3D driver for nv30 - nv40 - nv50 nouveau_dri.so
  make -C ${srcdir}/?esa-*/src/gallium/targets/dri-nouveau DESTDIR="${pkgdir}" install
}

#package_llvm-dri() {
#  depends=("libgl=${pkgver}")
#  pkgdesc="Mesa common LLVM support"

#if [ "${_git}" = "true" ]; then
#    cd ${srcdir}/mesa-*/src/gallium
#  else
#    cd "${srcdir}/Mesa-${pkgver}/src/gallium"
#fi

  # gallium llvmpipe
#if [ "${_git}" = "true" ]; then
#    make -C drivers/llvmpipe DESTDIR="${pkgdir}" install
#    #make -C targets/dri-swrast DESTDIR="${pkgdir}" install
#  else
#    make -C ${srcdir}/Mesa-${pkgver}/src/gallium/targets/dri-nouveau DESTDIR="${pkgdir}" install
#fi
#}
