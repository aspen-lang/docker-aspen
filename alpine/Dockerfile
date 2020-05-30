FROM alpine:edge AS builder

RUN apk update && apk add \
  make \
  musl-dev \
  gcc \
  openssl-dev \
  llvm10-dev \
  llvm10-static \
  libffi-dev \
  g++ \
  zlib-static \
  libxml2-dev

ENV LLVM_SYS_100_PREFIX /usr/lib/llvm10

ENV RUSTFLAGS "-C target-feature=-crt-static"

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

FROM alpine:edge

RUN apk update && apk add \
  libffi-dev \
  openssl-dev \
  zlib-static \
  g++ \
  libxml2-dev

COPY --from=builder \
  /aspen/target/release/aspen \
  /usr/bin/aspen

COPY --from=builder \
  /aspen/target/release/libaspen_runtime.a \
  /usr/lib/libaspen_runtime.a

ENTRYPOINT ["/usr/bin/aspen"]
