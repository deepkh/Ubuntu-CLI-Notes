## Headless
### General

Install

```bash
sudo apt-get install nload tmux vim sudo wget curl ca-certificates xz-utils net-tools --no-install-recommends
```

---------------------------------
### debootstrap 

Install 

```bash
apt-get install  qemu-utils qemu qemu-user-static binfmt-support fakechroot debootstrap gperf help2man --no-install-recommends
```

---------------------------------
### nfs, samba, avaiha 

Install 

```bash
sudo apt-get install nfs-common nfs-kernel-server portmap cifs-utils avahi-daemon samba --no-install-recommends
```

List of nfs-server using port (some port would be cated dynamic)

```bash
rpcinfo -p | awk '{print $3" "$4}' | sort -k2n | uniq
```

Fixed the NFS-Server port

[https://wiki.ubuntu.com/How%20to%20get%20NFS%20working%20with%20Ubuntu-CE-Firewall]

Configure avahi-daemon `sudo vim.tiny /etc/avahi/avahi-daemon.conf`

```bash
[server]
host-name=debser
domain-name=local
```

Enable and restart

```bash
sudo systemctl enable avahi-daemon
sudo systemctl reart avahi-daemon
```

and then you can `ping debser.local` from windows after you installed the ITunes(mDNS).


---------------------------------

### Static IP

Edit 

```bash
/etc/network/interfaces
```

From

```bash
allow-hotplug ens33
iface ens33 inet dhcp
```

To

```bash
allow-hotplug ens33
auto ens33
iface ens33 inet static
address 192.168.4.14
netmask 255.255.255.0
gateway 192.168.4.1
```

Restart networking

```bash
sudo systemctl restart networking.service
sudo systemctl restart network-manager.service
```


---------------------------------

### Hostname

Change `deb9ser` as you want.

```bash
sudo hostnamectl set-hostname deb9ser
```

---------------------------------

### Hinet VDSL PPPoE with ipv6 dual stack

Make sure the followings line has been comments in `/etc/sysctl.conf`
    
```bash
#net.ipv6.conf.all.disable_ipv6 = 1
#net.ipv6.conf.default.disable_ipv6 = 1
#net.ipv6.conf.lo.disable_ipv6 = 1
#net.ipv6.conf.eth0.disable_ipv6 = 1
```
    
Append the following line to `/etc/ppp/option`
    
```bash
+ipv6 ipv6cp-use-ipaddr
```
    
Install PPPoE
    
```bash
sudo apt-get install pppoe pppoeconf
```

PPPoE Setup
    
```bash
sudo pppoeconf
```
    
PPPoE Default Routing
    
edit `/etc/ppp/peers/dsl-provider` and add the `replacedefaultroute ` to the line after `defaultroute`. It will be something like this.
    
```bash
# Use this connection as the default route.
# Comment out if you already have the correct default route installed.
defaultroute
replacedefaultroute
```
    
PPPoE Stop
    
```bash
sudo poff dsl-provider
```

PPPoE Sart
    
```bash
sudo pon dsl-provider
```
    
Get ipv6 address from curl

```bash
curl ifconfig.co
```
    
(Optional) Append ipv6 dns server to `/etc/resolv.conf`

```bash
nameserver 2001:b000:168::1
nameserver 2001:b000:168::2
```
    
(Optional) Disable enp4s0, enp0s31f6 public IPv6 address, only let IPv6 go throw intetnet by ppp0

Due to curretnly the Hinet VDSL has been assign public IPv6 address automaticlly to Ethernet. But, acconding our setting above, we set the default route to ppp0, this will make IPv6 go throw internet by Ethernet and IPv4 go throw internet by ppp0. This seen make some something confused. 

So here the following setting could be disable ethernet to obtain the public IPv6 address and still make IPv6 go throw internet by ppp0. 
    
```bash
# add the following line to /etc/sysctl.conf and then sysctl -p
net.ipv6.conf.enp4s0.disable_ipv6 = 1
net.ipv6.conf.enp0s31f6.disable_ipv6 = 1
```

---------------------------------

### SSH server public key authentication configure

Client: Generate the RSA public key, private key pair in the client side

The following command will generate RSA private key to `~/.ssh/ida_rsa` and RSA public key to `~/.ssh/ida_rsa.pub`

```bash
ssh-keygen -t rsa
```

Server: Append the client side's `~/.ssh/ida_rsa.pub` to server side's `~/.ssh/authorized_keys`. The server's account is which you would like to login from client side. The client's account is which you would like to connect to.

chmod to 600
    
```bash
chmod 600 ~/.ssh/authorized_keys
```
    
Server: Modified the `/etc/ssh/sshd_config` to look like as

```bash
PermitRootLogin without-password
AuthorizedKeysFile      .ssh/authorized_keys
ChallengeResponseAuthentication no
PasswordAuthentication no
```
    
and
    
```bash
/etc/init.d/ssh restart
```
    
Use the `ida_rsa.pub` public key from PuTTY

[use-ssh-keys-with-putty-on-windows](https://devops.profitbricks.com/tutorials/use-ssh-keys-with-putty-on-windows/)
    
    
---------------------------------
	
### SSHFS

If the ssh server is ready, then no need to do anything from server side. The followings command is for client side.

```bash
sudo apt-get install sshfs
```

Edit `sudo vim.tiny /etc/fuse.conf` and uncomment the followings line if you would like to running `sudo` over sshfs disk.

```bash
user_allow_other
```

Mounting SSHFS

```bash
sshfs -o allow_root dogi@IP:/opt/workspace /opt/workspace
```

Unmount

```bash
fusermount -u /opt/workspace_vm
```

If this way can work, then totally can instead of NFS Sucks. 
 <https://www.kernel.org/doc/ols/2006/ols2006v2-pages-59-72.pdf>
    
---------------------------------

### Change time zone to UTC

Configure

```bash
sudo dpkg-reconfigure tzdata
```

---------------------------------

### Samba Configure

Edit `/etc/samba/smb.conf`  

```bash
[global]
  allow insecure wide links = yes
```

Sharing `/opt` to the user of `user` 

```bash
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
    
Sharing `/home/%S` directory to the user of `%S`

```bash
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
    
Add user of `user` to samba server's list

```bash
useradd -m -d /home/user user
smbpasswd -a user
```
    
Restart samba server

```bash
useradd -m -d /home/user user
smbpasswd -a user
```
    
Start samba server after system boot-up

```bash
systemctl enable smbd
```
    
	
---------------------------------

### NFS Configure 

Sharing `/opt`. Edit `/etc/exports` to 

```bash
/opt   *(rw,insecure,fsid=0,async,no_root_squash,no_subtree_check)
```
    
Restart nfs server 

```bash
/etc/init.d/nfs-kernel-server restart
```
    
Start nfs server after system boot-up 

```bash
systemctl enable nfs-kernel-server
```
    
---------------------------------

### Fix user 'xxxx' not in the sudoers file

As root and run 

```bash
visudo
```
    
Append the file with

```bash
username	ALL=(ALL) ALL
```
