FROM quay.io/fedora/fedora-bootc:41

#copy configs
COPY etc etc
RUN mkdir -p /var/roothome /data

#install rpmfusion
RUN dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

#install & configure packages
RUN dnf group install -y "KDE Plasma Workspaces" && \
	dnf install -y --skip-unavailable bash-completion bcache-tools bwm-ng cockpit cockpit-podman cockpit-storaged cockpit-ws cockpit-pcp cockpit-podman cockpit-machines cockpit-selinux cups cups-browsed dmraid ethtool firefox firewalld fuse-exfat fwupd gamemode gdb git htop input-leap kamera k3b libvirt-daemon lm_sensors nfs-utils nss-mdns pcp pcp-selinux powertop qemu-kvm samba sysstat thermald tuned vim-enhanced virt-install virt-manager vulkan-tools xdpyinfo wget && \
	dnf remove -y plasma-discover-offline-updates plasma-discover-packagekit plasma-pk-updates tracker tracker-miners plasma-x11 plasma-workspace-x11 && \
	dnf swap -y ffmpeg-free ffmpeg --allowerasing && dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin && dnf group install -y sound-and-video" && dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld && dnf swap -y mesa-vdpau-drivers mesa-vdpau-drivers-freeworld

#configure unit files
RUN systemctl enable lm_sensors sysstat tuned fstrim.timer podman.socket podman-auto-update.timer cockpit.socket libvirtd.socket && \
systemctl set-default graphical.target
