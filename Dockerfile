FROM daocloud.io/library/ubuntu
MAINTAINER developerdong<developerdong@gmail.com>
RUN apt update \
 && apt install wget gcc git shadowsocks curl sudo -y \
 && rm -rf /var/lib/apt/lists/*
RUN export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static \
 && export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup \
 && curl -sSf https://mirrors.ustc.edu.cn/rust-static/rustup.sh | sh -s -- --channel=nightly \
 && git clone https://github.com/net-reflow/reflow \
 && cd reflow \
 && cargo install
COPY config /root/config
EXPOSE 53 1080
CMD sslocal -s $SERVER_ADDR -p $SERVER_PORT -l 1081 -k $PASSWORD -m $METHOD \
 && /root/.cargo/bin/reflow --config /root/config
