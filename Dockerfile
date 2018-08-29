FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential git-core cmake sudo x11-xserver-utils libssl-dev libx11-dev libxext-dev libxinerama-dev \
        libxcursor-dev libxdamage-dev libxv-dev libxkbfile-dev libasound2-dev libcups2-dev libxml2 libxml2-dev \
        libxrandr-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
        libxi-dev libavutil-dev \
        libavcodec-dev libxtst-dev libgtk-3-dev libgcrypt11-dev libssh-dev libpulse-dev \
        libvte-2.91-dev libxkbfile-dev libtelepathy-glib-dev libjpeg-dev \
        libgnutls28-dev libgnome-keyring-dev libavahi-ui-gtk3-dev libvncserver-dev \
        libappindicator3-dev intltool libsecret-1-dev libwebkit2gtk-4.0-dev libsystemd-dev \
        libsoup2.4-dev libjson-glib-dev libavresample-dev

RUN git clone https://github.com/FreeRDP/FreeRDP.git /tmp/FreeRDP

WORKDIR /tmp/FreeRDP
RUN cmake -DWITH_SSE2=ON -DWITH_CUPS=on -DWITH_WAYLAND=off -DWITH_PULSE=on -DCMAKE_INSTALL_PREFIX:PATH=/opt/freerdp . && \
    make && \
    make install && \
    echo /opt/freerdp/lib > /etc/ld.so.conf.d/freerdp.conf && \
    ldconfig && \
    ln -sf /opt/freerdp/bin/xfreerdp /usr/local/bin/

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/rdp && \
    echo "rdp:x:${uid}:${gid}:rdp,,,:/home/rdp:/bin/bash" >> /etc/passwd && \
    echo "rdp:x:${uid}:" >> /etc/group && \
    echo "rdp ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/rdp && \
    chmod 0440 /etc/sudoers.d/rdp && \
    chown ${uid}:${gid} -R /home/rdp

USER rdp 
ENV HOME /home/rdp
WORKDIR /opt/freerdp
