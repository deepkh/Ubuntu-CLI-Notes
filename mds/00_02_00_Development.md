---------------------------------

## Development
### General

Install

```bash
sudo apt-get install build-essential fakeroot automake flex texinfo autoconf bison gawk libtool libtool-bin libncurses5-dev git yasm --no-install-recommends
```

---------------------------------

### libdrm-dev

Install

```bash
sudo apt install libgl1-mesa-dev libdrm-dev libegl1-mesa-dev
```

---------------------------------

### 32bit dev

Install

```bash
sudo apt-get install lib32z1 gcc-multilib rpm lib32stdc++6 lib32ncurses5 --no-install-recommends
```

---------------------------------

### AOSP dev

Install

```bash
sudo apt-get install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc unzip openjdk-8-jdk
```

---------------------------------

### SDL2 dev

Install

```bash
sudo apt-get install libsdl2-dev libsdl2-gfx-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-net-dev libsdl2-ttf-dev libcurl4-openssl-dev libjansson-dev libyaml-dev
```

---------------------------------


### SDL2 runtime

Install

```bash
sudo apt-get install libsdl2-2.0 libsdl2-gfx-1.0 libsdl2-image-2.0 libsdl2-mixer-2.0 libsdl2-net-2.0 libsdl2-ttf-2.0 libcurl4 libjansson4 libyaml-0-2
```

---------------------------------

### ffmpeg dev

Install

```bash
sudo apt-get install libavcodec-dev libavformat-dev libavdevice-dev libavfilter-dev libavutil-dev libswresample-dev libswscale-dev
```

---------------------------------

### OpenGL Headers

Install these things before install nVidia GPU driver.

```bash
sudo apt-get install libgl1-mesa-dev libgles2-mesa-dev 
```


---------------------------------

### wpa_supplicant-2.7 building

Install

```bash
sudo apt-get install dbus libdbus-1-3 libxml2-dev libssl-dev
```

and building by enter

```bash
cd wpa_supplicant

echo "CONFIG_BUILD_WPA_CLIENT_SO=y" >> .config
make -j4
sudo make LIBDIR=/usr/lib install
```

The `/usr/lib/libwpa_client.so` and `/usr/local/include/wpa_ctrl.h` will installed.

