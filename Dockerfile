FROM daocloud.io/library/ubuntu
MAINTAINER developerdong<developerdong@gmail.com>
WORKDIR /root
RUN apt update \
 && apt install wget gcc git shadowsocks curl sudo -y \
 && rm -rf /var/lib/apt/lists/* \
 && export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static \
 && export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup \
 && curl -sSf https://mirrors.ustc.edu.cn/rust-static/rustup.sh | sh -s -- --channel=nightly \
 && git clone https://github.com/net-reflow/reflow \
 && git clone https://github.com/qiuzi/dns2socks.git \
 && cd /root/dns2socks \
 && gcc -pthread -Wall -O2 -o dns2socks DNS2SOCKS.c \
 && cd /root/reflow \
 && cargo install
COPY config /root/config
EXPOSE 1080
CMD sslocal -s $SERVER_ADDR -p $SERVER_PORT -l 1081 -k $PASSWORD -m $METHOD & \
    /root/dns2socks/dns2socks 127.0.0.1:1081 8.8.8.8:53 127.0.0.1:54 & \ 
    /root/.cargo/bin/reflow --config /root/config
