FROM gitpod/workspace-full:latest
LABEL version="1.1.16"

RUN mkdir -p ~/.local/bin
RUN curl -L -o ~/.local/bin/soroban https://github.com/stellar/soroban-tools/releases/download/v0.4.0/soroban-cli-0.4.0-aarch64-unknown-linux-gnu
RUN chmod +x ~/.local/bin/soroban
RUN curl -L https://github.com/mozilla/sccache/releases/download/v0.3.3/sccache-dist-v0.3.3-x86_64-unknown-linux-musl.tar.gz | tar xz --strip-components 1 -C ~/.local/bin sccache-v0.3.1-x86_64-unknown-linux-musl/sccache
RUN chmod +x ~/.local/bin/sccache

RUN curl -LO https://github.com/denoland/deno/releases/download/v1.30.0/deno-x86_64-unknown-linux-gnu.zip
RUN unzip deno-x86_64-unknown-linux-gnu.zip -d ~/.local/bin

RUN git clone https://github.com/silence48/soroban-quest--pioneer ~/.local/soroban-quest && \
    ln -s ~/.local/_tmp/soroban-quest/_client ~/.local && \
    cd ~/.local/_tmp/soroban-quest/_squirtle && \
    ln -s bash-hook ~/.local && \
    npm run package && \

ENV RUSTC_WRAPPER=sccache
ENV SCCACHE_CACHE_SIZE=5G
ENV SCCACHE_DIR=/workspace/.sccache

RUN rustup install stable
RUN rustup target add --toolchain stable wasm32-unknown-unknown
RUN rustup component add --toolchain stable rust-src
RUN rustup install nightly
RUN rustup target add --toolchain nightly wasm32-unknown-unknown
RUN rustup component add --toolchain nightly rust-src
RUN rustup default stable

RUN sudo apt-get update && sudo apt-get install -y binaryen
