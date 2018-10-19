ENV RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
ENV RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
RUN curl -sSf https://mirrors.ustc.edu.cn/rust-static/rustup.sh | sh -s -- --channel=nightly
RUN apt update && apt install wget gcc git shadowsocks -y
RUN git clone https://github.com/net-reflow/reflow
WORKDIR reflow
RUN cargo install
ADD config ~
RUN mkdir -p ~/config/ipregion.chinalist ~/config/region.chinalist 
 && wget -P ~/config/ipregion.chinalist https://raw.githubusercontent.com/17mon/china_ip_list/master/china_ip_list.txt
EXPOSE 53 1080
CMD sslocal -s $SERVER_ADDR -p $SERVER_PORT -l 1081 -k $PASSWORD -m $METHOD
 && ~/.cargo/bin/reflow --config ~/config  
