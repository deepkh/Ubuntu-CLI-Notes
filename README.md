# Debian/Ubuntu Setup

Some records for software install or configure on debian stretch.

* Software install
  * general
  * debootstrap
  * desktop
  * nfs, samba, avaiha
  * dev
  * 32bit dev
  * AOSP dev
* Network configure
  * Static IP
  * Set hostname
  * PPPoE ipv6 dual stack
* SSH server public key authentication configure
* Change time zone
* Samba configure
* NFS configure
* fixed user 'xxxx' not in the sudoers file
* Cloudflare sub-domain IPv4/IPV6 address updater bash script
* restore_rcs.sh: The /etc restore script

## Software install

#### general

```
sudo apt-get install nload tmux vim sudo wget curl ca-certificates xz-utils net-tools --no-install-recommends
```

#### debootstrap 

```
apt-get install  qemu-utils qemu qemu-user-static binfmt-support fakechroot debootstrap gperf help2man --no-install-recommends
```

And then you could got `qemu-aarch64-static`, `qemu-arm-static`, `qemu-armeb-static`.

#### desktop

```
sudo apt-get install ntfs-3g freerdp aptitude vim-gtk3 firmware-misc-nonfree vnc4server lm-sensors linux-headers-4.x.x.x-amd64 --no-install-recommends
```

#### x11vnc

```
sudo apt-get install x11vnc
```

Set default password for current user.

```
x11vnc -storepasswd
```

Start x11vnc command

```
/usr/bin/x11vnc -auth guess -forever -loop -noxdamage -repeat -rfbauth /home/YOUR_USER_NAME/.vnc/passwd -rfbport 5900 -shared
```

Use VNC Viewer for client connection

```
IP:5900
```
 

#### nfs, samba, avaiha

```
sudo apt-get install nfs-common nfs-kernel-server portmap cifs-utils avahi-daemon samba --no-install-recommends
```

list of nfs-server using port (some port would be cated dynamic)

```
rpcinfo -p | awk '{print $3" "$4}' | sort -k2n | uniq
```

fixed the NFS-Server port

[https://wiki.ubuntu.com/How%20to%20get%20NFS%20working%20with%20Ubuntu-CE-Firewall]

Configure avahi-daemon `sudo vim.tiny /etc/avahi/avahi-daemon.conf`

```
[server]
host-name=debser
domain-name=local
```

and enable and restart

```
sudo systemctl enable avahi-daemon
sudo systemctl reart avahi-daemon
```

and then you can `ping debser.local` from windows after you installed the ITunes(mDNS).


#### dev

```
sudo apt-get install build-essential fakeroot automake flex texinfo autoconf bison gawk libtool libtool-bin libncurses5-dev git yasm --no-install-recommends
```

#### libdrm-dev

```
sudo apt install libgl1-mesa-dev libdrm-dev libegl1-mesa-dev
```

#### 32bit dev

```
sudo apt-get install lib32z1 gcc-multilib rpm lib32stdc++6 lib32ncurses5 --no-install-recommends
```

#### AOSP dev

```
sudo apt-get install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc unzip openjdk-8-jdk
```

#### SDL2 dev

```
sudo apt-get install libsdl2-dev libsdl2-gfx-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-net-dev libsdl2-ttf-dev libcurl4-openssl-dev libjansson-dev libyaml-dev
```


#### SDL2 runtime

```
sudo apt-get install libsdl2-2.0 libsdl2-gfx-1.0 libsdl2-image-2.0 libsdl2-mixer-2.0 libsdl2-net-2.0 libsdl2-ttf-2.0 libcurl4 libjansson4 libyaml-0-2
```

#### ffmpeg dev

```
sudo apt-get install libavcodec-dev libavformat-dev libavdevice-dev libavfilter-dev libavutil-dev libswresample-dev libswscale-dev
```

#### OpenGL Headers

Install these things before install nVidia GPU driver.

```
sudo apt-get install libgl1-mesa-dev libgles2-mesa-dev 
```

#### wpa_supplicant-2.7 building

```
sudo apt-get install dbus libdbus-1-3 libxml2-dev libssl-dev
```

and building by enter

```
cd wpa_supplicant

echo "CONFIG_BUILD_WPA_CLIENT_SO=y" >> .config
make -j4
sudo make LIBDIR=/usr/lib install
```

The `/usr/lib/libwpa_client.so` and `/usr/local/include/wpa_ctrl.h` will installed.

## Network configure

#### Static IP

1. edit `/etc/network/interfaces` and replace the followings line from

    ```
    allow-hotplug ens33
    iface ens33 inet dhcp
    ```

    to

    ```
    allow-hotplug ens33
    auto ens33
    iface ens33 inet static
    address 192.168.4.14
    netmask 255.255.255.0
    gateway 192.168.4.1
    ```

1. `reboot`

#### Set hostname

1. chaneg `deb9ser` as you want.
    ```
    sudo hostnamectl set-hostname deb9ser
    ```

#### PPPoE ipv6 dual stack

1. Make sure the followings line has been comments in `/etc/sysctl.conf`
    
    ```
    #net.ipv6.conf.all.disable_ipv6 = 1
    #net.ipv6.conf.default.disable_ipv6 = 1
    #net.ipv6.conf.lo.disable_ipv6 = 1
    #net.ipv6.conf.eth0.disable_ipv6 = 1
    ```
    
1. Append the following line to `/etc/ppp/option`
    
    ```
    +ipv6 ipv6cp-use-ipaddr
    ```
    
1. Install PPPoE
    
    ```
    sudo apt-get install pppoe pppoeconf
    ```

1. PPPoE Setup
    
    ```
    sudo pppoeconf
    ```
    
1. PPPoE Default Routing
    
    edit `/etc/ppp/peers/dsl-provider` and add the `replacedefaultroute ` to the line after `defaultroute`. It will be something like this.
    
    ```
    # Use this connection as the default route.
    # Comment out if you already have the correct default route installed.
    defaultroute
    replacedefaultroute
    ```
    
1. PPPoE Stop
    
    ```
    sudo poff dsl-provider
    ```

1. PPPoE Sart
    
    ```
    sudo pon dsl-provider
    ```
    
1. Get ipv6 address from curl

    ```
    curl ifconfig.co
    ```
    
1. (Optional) Append ipv6 dns server to `/etc/resolv.conf`

    ```
    nameserver 2001:b000:168::1
    nameserver 2001:b000:168::2
    ```
    
1. (Optional) Disable enp4s0, enp0s31f6 public IPv6 address, only let IPv6 go throw intetnet by ppp0

    Due to curretnly the Hinet ADSL has been assign public IPv6 address automaticlly to Ethernet. But, acconding our setting above, we set the default route to ppp0, this will make IPv6 go throw internet by Ethernet and IPv4 go throw internet by ppp0. This seen make some something confused. 
    
    So here the following setting could be disable ethernet to obtain the public IPv6 address and still make IPv6 go throw internet by ppp0. 
    
    ```
    # add the following line to /etc/sysctl.conf and then sysctl -p
    net.ipv6.conf.enp4s0.disable_ipv6 = 1
    net.ipv6.conf.enp0s31f6.disable_ipv6 = 1
    ```

## SSH server public key authentication configure

1. Client: Generate the RSA public key, private key pair in the client side

    The following command will generate RSA private key to `~/.ssh/ida_rsa` and RSA public key to `~/.ssh/ida_rsa.pub`

    ```
    ssh-keygen -t rsa
    ```

1. Server: Append the client side's `~/.ssh/ida_rsa.pub` to server side's `~/.ssh/authorized_keys`. The server's account is which you would like to login from client side. The client's account is which you would like to connect to.

    and chmod to 600
    
    ```
    chmod 600 ~/.ssh/authorized_keys
    ```
    
1. Server: Modified the `/etc/ssh/sshd_config` to look like as

    ```
    PermitRootLogin without-password
    AuthorizedKeysFile      .ssh/authorized_keys
    ChallengeResponseAuthentication no
    PasswordAuthentication no
    ```
    
    and
    
    ```
    /etc/init.d/ssh restart
    ```
    
1. Use the `ida_rsa.pub` public key from PuTTY

    <https://devops.profitbricks.com/tutorials/use-ssh-keys-with-putty-on-windows/>
    
    
## SSHFS

If the ssh server is ready, then no need to do anything from server side. The followings command is for client side.

```
sudo apt-get install sshfs
```

Edit `sudo vim.tiny /etc/fuse.conf` and uncomment the followings line if you would like to running `sudo` over sshfs disk.

```
user_allow_other
```

Mounting SSHFS

```
sshfs -o allow_root dogi@IP:/opt/workspace /opt/workspace
```

Unmount

```
fusermount -u /opt/workspace_vm
```

If this way can work, then totally can instead of NFS Sucks. 
 <https://www.kernel.org/doc/ols/2006/ols2006v2-pages-59-72.pdf>
    

## Change time zone to UTC

    sudo dpkg-reconfigure tzdata

## Samba configure

    ```
    [global]
      allow insecure wide links = yes
    ```

1. Sharing `/opt` to the user of `user`. Edit `/etc/samba/smb.conf` to look like as

    ```
    [opt]
       comment = opt
       path = /opt
       browseable = yes
       read only = no
       create mask = 0644
       directory mask = 0755
       valid users = USER
       force user = root
       force group = root
       admin users = dogi
       follow symlinks = yes
       wide links = yes
       oplocks = no
    ```
    
1. Sharing `/home/%S` directory to the user of `%S`

    ```
    [homes]
       comment = Home Directories
       browseable = yes
       read only = no
       create mask = 0700
       directory mask = 0700
       valid users = %S
       follow symlinks = yes
       wide links = yes
       oplocks = no
    ```
    
1. Add user of `user` to samba server's list

    ```
    useradd -m -d /home/user user
    smbpasswd -a user
    ```
    
1. Restart samba server

    ```
    useradd -m -d /home/user user
    smbpasswd -a user
    ```
    
1. Start samba server after system boot-up

    ```
    systemctl enable smbd
    ```
    
## NFS configure (May be use SSHFS instead)

1. Sharing `/opt`. Edit `/etc/exports` to 

    ```
    /opt   *(rw,insecure,fsid=0,async,no_root_squash,no_subtree_check)
    ```
    
1. Restart nfs server 

    ```
    /etc/init.d/nfs-kernel-server restart
    ```
    
1. Start nfs server after system boot-up 

    ```
    systemctl enable nfs-kernel-server
    ```
    


## fixed user 'xxxx' not in the sudoers file

1. As root and run 

    ```
    visudo
    ```
    
1. Append the file with

    ```
    username	ALL=(ALL) ALL
    ```

## Cloudflare sub-domain IPv4/IPV6 address updater bash script

The script provide a way to be something like Dynamic DNS. 

1. Download `cloudflare-v4v6_dns-updater`  
1. Modify the `AUTH_EMAIL`, `AUTH_KEY`, `ZONE_NAME`, `RECORD_NAME`, `RECORD_NAME6`, `IP_IS_NOT` as you want
1. Move `cloudflare-v4v6_dns-updater` to `/etc/ppp/ip-up.d` 
1. The script could be executed after ppp0 was bring up

## restore_rcs.sh: The /etc restore script

The scenario is, assuming I have the `/opt/rcs` dir and file structures as below.

```
user@debser:/opt/rcs$ ls *
bin:
adb  aosp_helper.sh  aosp_make.sh  aosp_media_server.mk  aosp_mmm.sh  backup_5tb.sh  backup_rcs.sh  debian_helper.sh

etc:
init.d  ipsec.conf  ipsec.d  ipsec.secrets  network  ppp  rc5.d  samba  ssh  strongswan.conf  sysctl.conf

home:
user

root:
```

This script could restore any file from `/opt/*` to `/*` when I have a fresh installed linux distribution just via compare the `md5sum` and lastest modified timestamp. The script will not cover any file if the `/*` lastest modified timestamp is newer than `/opt/rcs/*` even the md5sum is not same.

Due to the most of file stored from `/opt/rcs/*` is text, so the `/opt/rcs` could easily backup by git or rsync. 
