# Maintainer: Philip Müller <philm[at]manjaro[dot]org>
# Maintainer: Mark Wagie <mark at manjaro dot org>

# Arch credits:
# Maintainer: Laurent Carlier <lordheavym@gmail.com>
# Maintainer: Felix Yan <felixonmars@archlinux.org>
# Contributor: Jan de Groot <jgc@archlinux.org>
# Contributor: Andreas Radke <andyrtr@archlinux.org>

codecs="vc1dec,h264dec,h264enc,h265dec,h265enc"
epoch=1
pkgbase=mesa
pkgname=(
  'vulkan-mesa-layers'
  'opencl-mesa'
  'vulkan-intel'
  'vulkan-radeon'
  'vulkan-swrast'
  'vulkan-virtio'
  'libva-mesa-driver'
  'mesa-vdpau'
  'mesa'
)
pkgver=23.1.3
pkgrel=3
pkgdesc="An open-source implementation of the OpenGL specification"
url="https://www.mesa3d.org/"
arch=('x86_64')
license=('custom')
makedepends=(
  'clang'
  'expat'
  'libdrm'
  'libelf'
  'libglvnd'
  'libunwind'
  'libva'
  'libvdpau'
  'libx11'
  'libxdamage'
  'libxml2'
  'libxrandr'
  'libxshmfence'
  'libxxf86vm'
  'llvm'
  'lm_sensors'
  'systemd'
  'vulkan-icd-loader'
  'wayland'
  'zstd'

  # shared with lib32-mesa
  'clang'
  'cmake'
  'elfutils'
  'glslang'
  'libclc'
  'meson'
  'python-mako'
  'wayland-protocols'
  'xorgproto'

  # valgrind deps
  'valgrind'

  # d3d12 deps
  'directx-headers'

  # gallium-omx deps
  'libomxil-bellagio'

  # gallium-rusticl deps
  'rust'
  'rust-bindgen'
  'spirv-tools'

  # intel-clc deps
  'python-ply'
  'spirv-llvm-translator'
)
options=('lto')
source=(
  https://mesa.freedesktop.org/archive/mesa-${pkgver}.tar.xz{,.sig}
  mesa-staging-23.1-20230628.patch
  https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/23923.patch
  LICENSE
)
sha256sums=('2f6d7381bc10fbd2d6263ad1022785b8b511046c1a904162f8f7da18eea8aed9'
            'SKIP'
            'ac2b0143df10ed1138b8a0371144e2fb2836eb844feed68cbfdbedc58c9fe045'
            'bd235491dbe14bccfcaeca3bcb27482bf3a40581837b45a6e51fe3ebb4b31314'
            '7052ba73bb07ea78873a2431ee4e828f4e72bda7d176d07f770fa48373dec537')
b2sums=('99ce2a458c049b60cf13278d5e2e04d9eebefe04d5cbfcba7ff13421724bfd7877ec24086e513d249f1e7b1d537acea90e2ae53d71ef420213a5764ce61d8c4f'
        'SKIP'
        '3d5889fd5c7a6c95c5c98fb42b4289cdba18ceafdd3f713d164ca6ae1bff9da3f97ec13c74b54dee70cd1545164ec1ef7264ee84dd266422fa8b9d1a70d42a94'
        '9f8b2e71f84c2ff6bf06f771e0bf10cd71dc9fbf938a07b179cd888f3449db46edb67b6566c09f6f60972e9c3cb0b64241a00128715a9627da3c0942e36fc64c'
        '1ecf007b82260710a7bf5048f47dd5d600c168824c02c595af654632326536a6527fbe0738670ee7b921dd85a70425108e0f471ba85a8e1ca47d294ad74b4adb')
validpgpkeys=('8703B6700E7EE06D7A39B8D6EDAE37B02CEB490D'  # Emil Velikov <emil.l.velikov@gmail.com>
              '946D09B5E4C9845E63075FF1D961C596A7203456'  # Andres Gomez <tanty@igalia.com>
              'E3E8F480C52ADD73B278EE78E1ECBE07D7D70895'  # Juan Antonio Suárez Romero (Igalia, S.L.) <jasuarez@igalia.com>
              'A5CC9FEC93F2F837CB044912336909B6B25FADFA'  # Juan A. Suarez Romero <jasuarez@igalia.com>
              '71C4B75620BC75708B4BDB254C95FAAB3EB073EC'  # Dylan Baker <dylan@pnwbakers.com>
              '57551DE15B968F6341C248F68D8E31AFC32428A6') # Eric Engestrom <eric@engestrom.ch>

prepare() {
  cd mesa-$pkgver
  patch -p1 -i ../mesa-staging-23.1-20230628.patch
  patch -p1 -i ../23923.patch
}

_libdir=usr/lib

build() {
  local meson_options=(
    --libdir=/$_libdir
    -D android-libbacktrace=disabled
    -D b_ndebug=true
    -D dri3=enabled
    -D egl=enabled
    -D gallium-drivers=r300,r600,radeonsi,nouveau,virgl,svga,swrast,i915,iris,crocus,zink,d3d12
    -D gallium-extra-hud=true
    -D gallium-nine=true
    -D gallium-omx=bellagio
    -D gallium-opencl=icd
    -D gallium-rusticl=true
    -D gallium-va=enabled
    -D gallium-vdpau=enabled
    -D gallium-xa=enabled
    -D gbm=enabled
    -D gles1=disabled
    -D gles2=enabled
    -D glvnd=true
    -D glx=dri
    -D intel-clc=enabled
    -D libunwind=enabled
    -D llvm=enabled
    -D lmsensors=enabled
    -D microsoft-clc=disabled
    -D osmesa=true
    -D platforms=x11,wayland
    -D rust_std=2021
    -D shared-glapi=enabled
    -D video-codecs=$codecs \
    -D valgrind=enabled
    -D vulkan-drivers=amd,intel,intel_hasvk,swrast,virtio-experimental
    -D vulkan-layers=device-select,intel-nullhw,overlay
  )

  arch-meson mesa-$pkgver build "${meson_options[@]}"
  meson configure --no-pager build # Print config
  meson compile -C build

  # fake installation to be seperated into packages
  # outside of fakeroot but mesa doesn't need to chown/mod
  DESTDIR="${srcdir}/fakeinstall" meson install -C build
}

_install() {
  local src f dir
  for src; do
    f="${src#fakeinstall/}"
    dir="${pkgdir}/${f%/*}"
    install -m755 -d "${dir}"
    mv -v "${src}" "${dir}/"
  done
}

package_vulkan-mesa-layers() {
  pkgdesc="Mesa's Vulkan layers"
  depends=(
    'libdrm'
    'libxcb'
    'wayland'

    'python'
  )
  conflicts=('vulkan-mesa-layer')
  replaces=('vulkan-mesa-layer')

  _install fakeinstall/usr/share/vulkan/explicit_layer.d
  _install fakeinstall/usr/share/vulkan/implicit_layer.d
  _install fakeinstall/$_libdir/libVkLayer_*.so
  _install fakeinstall/usr/bin/mesa-overlay-control.py

  install -m644 -Dt "${pkgdir}/usr/share/licenses/${pkgname}" LICENSE
}

package_opencl-mesa() {
  pkgdesc="OpenCL support with clover and rusticl for mesa drivers"
  depends=(
    'clang'
    'expat'
    'libdrm'
    'libelf'
    'zstd'

    'libclc'
    'spirv-llvm-translator'
  )
  optdepends=('opencl-headers: headers necessary for OpenCL development')
  provides=('opencl-driver')

  _install fakeinstall/etc/OpenCL
  _install fakeinstall/$_libdir/lib*OpenCL*
  _install fakeinstall/$_libdir/gallium-pipe

  install -m644 -Dt "${pkgdir}/usr/share/licenses/${pkgname}" LICENSE
}

package_vulkan-intel() {
  pkgdesc="Intel's Vulkan mesa driver"
  depends=(
    'libdrm'
    'libx11'
    'libxshmfence'
    'systemd'
    'wayland'
    'zstd'
  )
  optdepends=('vulkan-mesa-layers: additional vulkan layers')
  provides=('vulkan-driver')

  _install fakeinstall/usr/share/vulkan/icd.d/intel_*.json
  _install fakeinstall/$_libdir/libvulkan_intel*.so

  install -m644 -Dt "${pkgdir}/usr/share/licenses/${pkgname}" LICENSE
}

package_vulkan-radeon() {
  pkgdesc="Radeon's Vulkan mesa driver"
  depends=(
    'libdrm'
    'libelf'
    'libx11'
    'libxshmfence'
    'llvm-libs'
    'systemd'
    'wayland'
    'zstd'
  )
  optdepends=('vulkan-mesa-layers: additional vulkan layers')
  provides=('vulkan-driver')

  _install fakeinstall/usr/share/drirc.d/00-radv-defaults.conf
  _install fakeinstall/usr/share/vulkan/icd.d/radeon_icd*.json
  _install fakeinstall/$_libdir/libvulkan_radeon.so

  install -m644 -Dt "${pkgdir}/usr/share/licenses/${pkgname}" LICENSE
}

package_vulkan-swrast() {
  pkgdesc="Vulkan software rasteriser driver"
  depends=(
    'libdrm'
    'libunwind'
    'libx11'
    'libxshmfence'
    'llvm-libs'
    'systemd'
    'wayland'
    'zstd'
  )
  optdepends=('vulkan-mesa-layers: additional vulkan layers')
  conflicts=('vulkan-mesa')
  replaces=('vulkan-mesa')
  provides=('vulkan-driver')

  _install fakeinstall/usr/share/vulkan/icd.d/lvp_icd*.json
  _install fakeinstall/$_libdir/libvulkan_lvp.so

  install -m644 -Dt "${pkgdir}/usr/share/licenses/${pkgname}" LICENSE
}

package_vulkan-virtio() {
  pkgdesc="Venus Vulkan mesa driver for Virtual Machines"
  depends=(
    'libdrm'
    'libx11'
    'libxshmfence'
    'systemd'
    'wayland'
    'zstd'
  )
  optdepends=('vulkan-mesa-layers: additional vulkan layers')
  provides=('vulkan-driver')

  _install fakeinstall/usr/share/vulkan/icd.d/virtio_icd*.json
  _install fakeinstall/$_libdir/libvulkan_virtio.so

  install -m644 -Dt "${pkgdir}/usr/share/licenses/${pkgname}" LICENSE
}

package_libva-mesa-driver() {
  pkgdesc="VA-API drivers"
  depends=(
    'expat'
    'libdrm'
    'libelf'
    'libx11'
    'libxshmfence'
    'llvm-libs'
    'zstd'
  )
  provides=('libva-driver')

  _install fakeinstall/$_libdir/dri/*_drv_video.so

  install -m644 -Dt "${pkgdir}/usr/share/licenses/${pkgname}" LICENSE
}

package_mesa-vdpau() {
  pkgdesc="VDPAU drivers"
  depends=(
    'expat'
    'libdrm'
    'libelf'
    'libx11'
    'libxshmfence'
    'llvm-libs'
    'zstd'
  )
  provides=('vdpau-driver')

  _install fakeinstall/$_libdir/vdpau

  install -m644 -Dt "${pkgdir}/usr/share/licenses/${pkgname}" LICENSE
}

package_mesa() {
  depends=(
    'libdrm'
    'libelf'
    'libglvnd'
    'libunwind'
    'libxdamage'
    'libxshmfence'
    'libxxf86vm'
    'llvm-libs'
    'lm_sensors'
    'vulkan-icd-loader'
    'wayland'
    'zstd'

    'libomxil-bellagio'
  )
  optdepends=(
    'libva-mesa-driver: for accelerated video playback'
    'mesa-vdpau: for accelerated video playback'
    'opengl-man-pages: for the OpenGL API man pages'
  )
  provides=(
    'mesa-libgl'
    'opengl-driver'
  )
  conflicts=('mesa-libgl')
  replaces=('mesa-libgl')

  _install fakeinstall/usr/share/drirc.d/00-mesa-defaults.conf
  _install fakeinstall/usr/share/glvnd/egl_vendor.d/50_mesa.json

  # ati-dri, nouveau-dri, intel-dri, svga-dri, swrast, swr
  _install fakeinstall/$_libdir/dri/*_dri.so

  _install fakeinstall/$_libdir/bellagio
  _install fakeinstall/$_libdir/d3d
  _install fakeinstall/$_libdir/lib{gbm,glapi}.so*
  _install fakeinstall/$_libdir/libOSMesa.so*
  _install fakeinstall/$_libdir/libxatracker.so*

  _install fakeinstall/usr/include
  _install fakeinstall/$_libdir/pkgconfig

  # libglvnd support
  _install fakeinstall/$_libdir/libGLX_mesa.so*
  _install fakeinstall/$_libdir/libEGL_mesa.so*

  # indirect rendering
  ln -sr "$pkgdir"/$_libdir/libGLX_{mesa,indirect}.so.0

  # make sure there are no files left to install
  find fakeinstall -depth -print0 | xargs -0 rmdir

  install -m644 -Dt "${pkgdir}/usr/share/licenses/${pkgname}" LICENSE
}

