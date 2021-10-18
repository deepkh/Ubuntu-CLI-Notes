---------------------------------

## Desktop
### general

Install

```bash
sudo apt-get install ntfs-3g freerdp aptitude vim-gtk3 firmware-misc-nonfree vnc4server lm-sensors linux-headers-4.x.x.x-amd64 --no-install-recommends
```

---------------------------------

### x11vnc

Install

```bash
sudo apt-get install x11vnc
```

Set default password for current user.

```bash
x11vnc -storepasswd
```

Start x11vnc command

```bash
/usr/bin/x11vnc -auth guess -forever -loop -noxdamage -repeat -rfbauth /home/YOUR_USER_NAME/.vnc/passwd -rfbport 5900 -shared
```

Use VNC Viewer for client connection

```bash
IP:5900
```
 