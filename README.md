> This is repository is now obsolete. Manjaro is back to the arch version of the mesa packages.

## How to return to the stock repos

```sh
PKGS="$(pacman -Sl mesa-nonfree | grep 'installed' | awk '{print $2}')"
sudo sed -i '/mesa-nonfree/d' /etc/pacman.conf
sudo pacman -Sy $(echo ${PKGS//$'\n'/ })
```

# mesa-nonfree

![release](https://img.shields.io/github/v/release/mesa-freeworld/mesa-nonfree)

> This builds the latest version available on the [arch repository](https://gitlab.archlinux.org/archlinux/packaging/packages/mesa.git) on the manjaro `unstable` branch. Using it on the `unstable` channel is thus strictly recommended!
