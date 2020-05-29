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
COPY aspen/Cargo.toml aspen/Cargo.lock aspen/
COPY aspen-runtime/Cargo.toml aspen-runtime/Cargo.lock aspen-runtime/
COPY aspen-cli/Cargo.toml aspen-cli/Cargo.lock aspen-cli/

WORKDIR /aspen/aspen-runtime
RUN touch src/lib.rs
RUN cargo build --release
RUN rm target/release/deps/libaspen_runtime-*

WORKDIR /aspen/aspen
RUN touch src/lib.rs
RUN cargo build --release
RUN rm target/release/deps/libaspen-*

WORKDIR /aspen/aspen-cli
RUN echo "fn main() {}" > src/main.rs
RUN cargo build --release
RUN rm target/release/deps/aspen-*

WORKDIR /aspen
COPY . .

RUN make

WORKDIR /

FROM debian

RUN apt update && apt install -y \
  libssl-dev \
  libz-dev

COPY --from=builder \
  /aspen/aspen-cli/target/release/aspen \
  /usr/bin/aspen

COPY --from=builder \
  /aspen/aspen-runtime/target/release/libaspen_runtime.a \
  /usr/lib/libaspen_runtime.a

ENTRYPOINT ["/usr/bin/aspen"]
