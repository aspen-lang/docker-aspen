FROM debian AS builder

RUN apt-get update && apt-get install -y \
  software-properties-common \
  wget \
  gnupg2 \
  make \
  openssl \
  gcc \
  pkg-config \
  libssl-dev \
  libz-dev

RUN wget -O- https://apt.llvm.org/llvm.sh | bash -s - 10

RUN wget -O- https://sh.rustup.rs | sh -s - -y \
  --default-toolchain nightly

ENV PATH $PATH:/root/.cargo/bin

RUN mkdir -p /aspen/aspen/src
RUN mkdir -p /aspen/aspen-runtime/src
RUN mkdir -p /aspen/aspen-cli/src

WORKDIR /aspen

RUN touch aspen-runtime/src/lib.rs
RUN touch aspen/src/lib.rs
RUN echo "fn main() {}" > aspen-cli/src/main.rs

COPY aspen/Cargo.toml aspen/
COPY aspen-runtime/Cargo.toml aspen-runtime/
COPY aspen-cli/Cargo.toml aspen-cli/
COPY Cargo.toml Cargo.lock ./

RUN cargo build --release

RUN rm target/release/deps/libaspen_runtime-*
RUN rm target/release/deps/libaspen-*
RUN rm target/release/deps/aspen-*

COPY . .

RUN cargo build --release

WORKDIR /

FROM debian

RUN apt update && apt install -y \
  libssl-dev \
  libz-dev

COPY --from=builder \
  /aspen/target/release/aspen \
  /usr/bin/aspen

COPY --from=builder \
  /aspen/target/release/libaspen_runtime.a \
  /usr/lib/libaspen_runtime.a

ENTRYPOINT ["/usr/bin/aspen"]
