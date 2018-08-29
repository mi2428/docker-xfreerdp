# docker-xfreerdp
xfreerdpをDockerコンテナ内で実行する．

## ビルド
```
% git clone https://github.com/mi2428/docker-xfreerdp
% cd docker-xfreerdp
% docker build -t xfreerdp .
```

## 使い方
オーディオ転送＋JP106キーボードで接続するにはこんな感じでOK．  
最終行の`user`，`domain`，`password`，`IP address`を適宜変更すること．
```
% docker run -it --rm --privileged \
  --device /dev/snd \
  --group-add $(getent group audio | cut -d: -f3) \
  -e DISPLAY=$DISPLAY \
  -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
  -v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  xfreerdp \
  xfreerdp -f --ignore-certificate -u [user] -d [domain] -p [password] -k 0xE0010411 -sound [IP address]
```
