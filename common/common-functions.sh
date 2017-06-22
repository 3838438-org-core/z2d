#!/bin/sh

c_tzone () {
  echo "$1" > /etc/timezone
  dpkg-reconfigure -f noninteractive tzdata
}


c_hostname () {
  echo $1 > /etc/hostname
  echo "127.0.0.1       $1 localhost" >> /etc/hosts
}

c_apt_list () {
  echo "deb http://ports.ubuntu.com/ ${1} main restricted universe multiverse" > /etc/apt/sources.list
  echo "deb http://ports.ubuntu.com/ ${1}-security main restricted universe multiverse" >> /etc/apt/sources.list
  echo "deb http://ports.ubuntu.com/ ${1}-updates main restricted universe multiverse" >> /etc/apt/sources.list
  echo "deb http://ports.ubuntu.com/ ${1}-backports main restricted universe multiverse" >> /etc/apt/sources.list
}

c_apt_list_debian () {
  echo "deb http://ftp.debian.org/debian/ ${1} main contrib non-free" > /etc/apt/sources.list
  echo "deb http://ftp.debian.org/debian/ ${1}-updates main contrib non-free" >> /etc/apt/sources.list
  echo "deb http://ftp.debian.org/debian/ ${1}-backports main contrib non-free" >> /etc/apt/sources.list
  echo "deb http://security.debian.org/ ${1}/updates main contrib non-free" >> /etc/apt/sources.list

#  echo "APT::Default-Release \"${1}\";" > /etc/apt/apt.conf.d/99defaultrelease

#  echo "deb http://ftp.debian.org/debian/ stable main contrib non-free" > /etc/apt/sources.list.d/stable.list
#  echo "deb http://security.debian.org/ stable/updates main contrib non-free" >> /etc/apt/sources.list.d/stable.list

#  echo "deb http://ftp.debian.org/debian/ testing main contrib non-free" > /etc/apt/sources.list.d/testing.list
#  echo "deb http://security.debian.org/ testing/updates main contrib non-free" >> /etc/apt/sources.list.d/testing.list
}

c_yum_list_f23_prim () {
  echo \
'[warning:fedora23]
name=fedora
mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-23&arch=$basearch
enabled=0
gpgcheck=1
gpgkey=https://getfedora.org/static/34EC9CBA.txt' \
  > /etc/yum.repos.d/Fedora23Repo.repo
}

c_yum_list_f23_second () {
  echo \
'[warning:fedora23]
name=fedora
mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-23&arch=$basearch
enabled=0
gpgcheck=1
gpgkey=https://getfedora.org/static/873529B8.txt' \
  > /etc/yum.repos.d/Fedora23Repo.repo
}

c_yum_list_f24_prim () {
  echo \
'[warning:fedora24]
name=fedora
mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-24&arch=$basearch
enabled=0
gpgcheck=1
gpgkey=https://getfedora.org/static/81B46521.txt' \
  > /etc/yum.repos.d/Fedora24Repo.repo
}

c_yum_list_f24_second () {
  echo \
'[warning:fedora24]
name=fedora
mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-24&arch=$basearch
enabled=0
gpgcheck=1
gpgkey=https://getfedora.org/static/030D5AED.txt' \
  > /etc/yum.repos.d/Fedora24Repo.repo
}

c_yum_list_f25_prim () {
  echo \
'[warning:fedora25]
name=fedora
mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-25&arch=$basearch
enabled=0
gpgcheck=1
gpgkey=https://getfedora.org/static/FDB19C98.txt' \
  > /etc/yum.repos.d/Fedora25Repo.repo
}

c_yum_list_f25_second () {
  echo \
'[warning:fedora25]
name=fedora
mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-25&arch=$basearch
enabled=0
gpgcheck=1
gpgkey=https://getfedora.org/static/E372E838.txt' \
  > /etc/yum.repos.d/Fedora25Repo.repo
}

# yum install epel-release
c_yum_list_epel_aarch64 (){
  echo \
'[unofficial-builds]
name=CentOS unofficial extra package rebuild
baseurl=https://dl.fedoraproject.org/pub/epel/7/aarch64/
metadata_expire=6h
gpgcheck=0
skip_if_unavailable=True' \
  > /etc/yum.repos.d/EPEL.repo
}

c_yum_list_epel_armhf (){
  echo \
'[unofficial-builds]
name=CentOS unofficial extra package rebuild
baseurl=https://armv7.dev.centos.org/repodir/epel-pass-1/
metadata_expire=6h
gpgcheck=0
skip_if_unavailable=True' \
  > /etc/yum.repos.d/EPEL.repo
}

c_nameserver () {
  for ((i = 1; i <= $#; i++)); do
    if (($i == 1)); then
      echo "nameserver ${!i}" > /etc/resolv.conf
    else
      echo "nameserver ${!i}" >> /etc/resolv.conf
    fi
  done
}

r_pkg_upgrade () {
  apt-get -q=2 update
  apt-get -q=2 -y upgrade
  apt-get -q=2 -y dist-upgrade
}

i_base () {
  apt-get -q=2 -y install ubuntu-minimal software-properties-common curl u-boot-tools ssh linux-firmware vim libpam-systemd
}

i_base_debian () {
  apt-get -q=2 -y install curl xz-utils u-boot-tools sudo openssh-server ntpdate ntp usbutils pciutils less lsof most sysfsutils ntfs-3g exfat-utils exfat-fuse firmware-linux libpam-systemd
}

i_base_centos () {
  yum update -y
  yum install -y bc bridge-utils docker dtc iw lzop rcs screen sysfsutils usbutils pciutils wget lsof ntfs-3g net-tools
  yum install -y uboot-tools --enablerepo=warning:fedora25
  yum clean all
}

i_base_fedora () {
  dnf update && dnf upgrade -y
  dnf install -y tar ntp bc bridge-utils docker dtc iw lzop rcs screen sysfsutils usbutils pciutils wget lsof ntfs-3g gcc most uboot-tools net-tools
  dnf clean all
}

i_extra () {
  apt-get -q=2 -y install dialog screen wireless-tools iw libncurses5-dev cpufrequtils rcs aptitude gcc make bc lzop man-db ntp usbutils pciutils lsof most sysfsutils
}

i_gcc_6 () {
  add-apt-repository ppa:ubuntu-toolchain-r/test
  apt-get update
  apt-get -y install gcc-6 g++-6
  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60
  update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-6 60
}

# Install HK default distro kernel
i_kernel_odroid_c1 () {
  apt-get -q=2 -y install initramfs-tools
# <HK quirk>
  echo "#!/bin/sh" > /etc/initramfs-tools/hooks/e2fsck.sh
  echo ". /usr/share/initramfs-tools/hook-functions" >> /etc/initramfs-tools/hooks/e2fsck.sh
  echo "copy_exec /sbin/e2fsck /sbin" >> /etc/initramfs-tools/hooks/e2fsck.sh
  echo "copy_exec /sbin/fsck /sbin" >> /etc/initramfs-tools/hooks/e2fsck.sh
  echo "copy_exec /sbin/fsck.ext2 /sbin" >> /etc/initramfs-tools/hooks/e2fsck.sh
  echo "copy_exec /sbin/fsck.ext4 /sbin" >> /etc/initramfs-tools/hooks/e2fsck.sh
  echo "copy_exec /sbin/logsave /sbin" >> /etc/initramfs-tools/hooks/e2fsck.sh
  chmod +x /etc/initramfs-tools/hooks/e2fsck.sh
# </HK quirk>
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AB19BAC9
  echo "deb http://deb.odroid.in/c1/ trusty main" > /etc/apt/sources.list.d/odroid.list
  echo "deb http://deb.odroid.in/ trusty main" >> /etc/apt/sources.list.d/odroid.list
  apt-get -q=2 update
  mkdir -p /media/boot
  apt-get -q=2 -y install linux-image-3.10.80-142 linux-headers-3.10.80-142 bootini
# <HK quirk>
  cp /boot/uImage* /media/boot/uImage
# </HK quirk>
# U-571
  mkdir -p /boot/conf.d/system.default
  curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/odroid-c1/uEnv.txt > /boot/conf.d/system.default/uEnv.txt
  (cd /boot/conf.d/ ; ln -s system.default default)
  (cd /boot/conf.d/system.default; ln -s /media/boot/ kernel)
}

i_kernel_odroid_c1_31080142 () {
  curl -sSL https://www.dropbox.com/s/cbp1ibtrxohjxc5/linux-3.10.80-142-c1.tar.xz?dl=0 | tar --numeric-owner -xhJpf -
# U-571
  mkdir -p /boot/conf.d/system.default
  curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/odroid-c1/uEnv.txt > /boot/conf.d/system.default/uEnv.txt
  (cd /boot/conf.d/ ; ln -s system.default default)
  (cd /boot/conf.d/system.default; ln -s ../../kernel.d/linux-*-c1 kernel)
}


# Install HK default distro kernel
i_kernel_odroid_c2 () {
  apt-get -q=2 -y install initramfs-tools
# <HK quirk>
  echo "#!/bin/sh" > /etc/initramfs-tools/hooks/e2fsck.sh
  echo ". /usr/share/initramfs-tools/hook-functions" >> /etc/initramfs-tools/hooks/e2fsck.sh
  echo "copy_exec /sbin/e2fsck /sbin" >> /etc/initramfs-tools/hooks/e2fsck.sh
  echo "copy_exec /sbin/fsck /sbin" >> /etc/initramfs-tools/hooks/e2fsck.sh
  echo "copy_exec /sbin/fsck.ext2 /sbin" >> /etc/initramfs-tools/hooks/e2fsck.sh
  echo "copy_exec /sbin/fsck.ext4 /sbin" >> /etc/initramfs-tools/hooks/e2fsck.sh
  echo "copy_exec /sbin/logsave /sbin" >> /etc/initramfs-tools/hooks/e2fsck.sh
  chmod +x /etc/initramfs-tools/hooks/e2fsck.sh
# </HK quirk>
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AB19BAC9
  echo "deb http://deb.odroid.in/c2/ xenial main" > /etc/apt/sources.list.d/odroid.list
  apt-get -q=2 update
  mkdir -p /media/boot
  apt-get -q=2 -y install linux-image-c2 bootini
# U-571
  mkdir -p /boot/conf.d/system.default
  curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/odroid-c2/uEnv.txt > /boot/conf.d/system.default/uEnv.txt
  (cd /boot/conf.d/ ; ln -s system.default default)
  (cd /boot/conf.d/system.default; ln -s /media/boot/ kernel)
}

i_kernel_odroid_kvim_31429 () {
  curl -sSL https://www.dropbox.com/s/beda84t9cfj89t9/linux-3.14.29-kvim-g2e7dc31-dirty.tar.xz?dl=0 | tar --numeric-owner -xhJpf -
}

i_kernel_odroid_c2_412 () {
  curl -sSL https://www.dropbox.com/s/9i4atdzmpgts9cv/linux-4.12.0-rc1-gx-g32c9d83.tar.xz?dl=0 | tar --numeric-owner -xhJpf -
# U-571
  mkdir -p /boot/conf.d/system.default
  curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/odroid-c2/uEnv.txt > /boot/conf.d/system.default/uEnv.txt
  (cd /boot/conf.d/ ; ln -s system.default default)
  (cd /boot/conf.d/system.default; ln -s ../../kernel.d/linux-*-gx* kernel)
  (cd /boot; ln -s kernel.d/linux-*/config-* .)
}

i_kernel_odroid_xu4 () {
  apt-get -q=2 -y install initramfs-tools
# <HK quirk>
  echo "#!/bin/sh" > /etc/initramfs-tools/hooks/e2fsck.sh
  echo ". /usr/share/initramfs-tools/hook-functions" >> /etc/initramfs-tools/hooks/e2fsck.sh
  echo "copy_exec /sbin/e2fsck /sbin" >> /etc/initramfs-tools/hooks/e2fsck.sh
  echo "copy_exec /sbin/fsck /sbin" >> /etc/initramfs-tools/hooks/e2fsck.sh
  echo "copy_exec /sbin/fsck.ext2 /sbin" >> /etc/initramfs-tools/hooks/e2fsck.sh
  echo "copy_exec /sbin/fsck.ext4 /sbin" >> /etc/initramfs-tools/hooks/e2fsck.sh
  echo "copy_exec /sbin/logsave /sbin" >> /etc/initramfs-tools/hooks/e2fsck.sh
  chmod +x /etc/initramfs-tools/hooks/e2fsck.sh
# </HK quirk>
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AB19BAC9
  echo "deb http://deb.odroid.in/5422/ wily main" > /etc/apt/sources.list.d/odroid.list
  echo "deb http://deb.odroid.in/ wily main" >> /etc/apt/sources.list.d/odroid.list
  apt-get -q=2 update
  mkdir -p /media/boot
  apt-get -q=2 -y install linux-image-xu3 bootini
# U-571
  mkdir -p /boot/conf.d/system.default
  curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/odroid-xu4/uEnv.txt > /boot/conf.d/system.default/uEnv.txt
  (cd /boot/conf.d/ ; ln -s system.default default)
  (cd /boot/conf.d/system.default; ln -s /media/boot/ kernel)
}

i_kernel_odroid_xu3_31096 () {
  curl -sSL https://www.dropbox.com/s/dq3txlc498i9c41/linux-3.10.96-xu3.tar.xz?dl=0 | tar --numeric-owner -xhJpf -
# U-571
  mkdir -p /boot/conf.d/system.default
  curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/odroid-xu4/uEnv.txt > /boot/conf.d/system.default/uEnv.txt
  (cd /boot/conf.d/ ; ln -s system.default default)
  (cd /boot/conf.d/system.default; ln -s ../../kernel.d/linux-*-xu3 kernel)
}

i_kernel_odroid_xu4_490 () {
  curl -sSL https://www.dropbox.com/s/ytny7vvriorv1ac/linux-4.9.33-xu4-00008-gf0e77c0.tar.xz?dl=0 | tar --numeric-owner -xhJpf -
# U-571
  mkdir -p /boot/conf.d/system.default
  curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/odroid-xu4/uEnv.txt > /boot/conf.d/system.default/uEnv.txt
  (cd /boot/conf.d/ ; ln -s system.default default)
  (cd /boot/conf.d/system.default; ln -s ../../kernel.d/linux-*-xu4* kernel)
}

i_kernel_utilite_pro () {
  curl -sSL https://www.dropbox.com/s/misb27zuqt304k8/linux-4.11.0-imx6-g68e0679.tar.xz?dl=0 | tar --numeric-owner -xhJpf -
# U-571
  mkdir -p /boot/conf.d/system.default
  curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/utilite-pro/uEnv.txt > /boot/conf.d/system.default/uEnv.txt
  (cd /boot/conf.d/ ; ln -s system.default default)
  (cd /boot/conf.d/system.default; ln -s ../../kernel.d/linux-*-imx6* kernel)
}

i_kernel_cubox_i () {
  curl -sSL https://www.dropbox.com/s/misb27zuqt304k8/linux-4.11.0-imx6-g68e0679.tar.xz?dl=0 | tar --numeric-owner -xhJpf -
# U-571
  mkdir -p /boot/conf.d/system.default
  curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/cubox-i/uEnv.txt > /boot/conf.d/system.default/uEnv.txt
  (cd /boot/conf.d/ ; ln -s system.default default)
  (cd /boot/conf.d/system.default; ln -s ../../kernel.d/linux-*-imx6* kernel)
}

i_kernel_pine64 () {
  curl -sSL https://www.dropbox.com/s/g4tkogrbawueu6q/linux-4.9.22-p64-g9a1638e.tar.xz?dl=0 | tar --numeric-owner -xhJpf -
# U-571
  mkdir -p /boot/conf.d/system.default
  curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/pine64%2B/uEnv.txt > /boot/conf.d/system.default/uEnv.txt
  (cd /boot/conf.d/ ; ln -s system.default default)
  (cd /boot/conf.d/system.default; ln -s ../../kernel.d/linux-*-p64* kernel)
}

c_if_lo () {
  echo "auto lo" > /etc/network/interfaces.d/lo
  echo "iface lo inet loopback" >> /etc/network/interfaces.d/lo
}

c_if_dhcp () {
  echo "auto $1" >/etc/network/interfaces.d/$1
  echo "iface $1 inet dhcp" >>/etc/network/interfaces.d/$1
}

c_ttyS () {
  echo "start on stopped rc or RUNLEVEL=[12345]" > /etc/init/${1}.conf
  echo "stop on runlevel [!12345]" >> /etc/init/${1}.conf
  echo "respawn" >> /etc/init/${1}.conf
  echo "exec /sbin/getty -L 115200 $1 vt102" >> /etc/init/${1}.conf
}

c_ttyS_debian () {
  echo T0:2345:respawn:/sbin/getty -L $1 115200 vt100 >> etc/inittab
}

c_fw_utils () {
  echo "$1" > /etc/fw_env.config
}

c_user () {
  adduser --gecos '' $1
  usermod -aG adm,cdrom,dialout,sudo,plugdev $1
}

c_docker_centos () {
  echo "STORAGE_DRIVER=overlay" >> /etc/sysconfig/docker-storage-setup
  docker-storage-setup
  systemctl enable docker
  systemctl start docker
}

c_locale () {
  for s in $@; do
    locale-gen $s
  done
  export LC_ALL="$1"
  update-locale LC_ALL="$1" LANG="$1" LC_MESSAGES=POSIX
  dpkg-reconfigure -f noninteractive locales
}

c_locale_debian () {
  for ((i = 1; i <= $#; i++)); do
    if (($i == 1)); then
      echo "${!i} UTF-8" > /etc/locale.gen
    else
      echo "${!i} UTF-8" >> /etc/locale.gen
    fi
  done
  locale-gen
  debconf-set-selections <<< "locales locales/default_environment_locale select $1"
  dpkg-reconfigure -f noninteractive locales
}

