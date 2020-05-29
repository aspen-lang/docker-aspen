# Quick Reference
- **Maintained by**: [the Aspen Developers](https://github.com/aspen-lang/docker-aspen)

# Supported tags and respective `Dockerfile` links
- [`0-debian`, `0.1-debian`, `0.1.0-debian`, `0`, `0.1`, `0.1.0`, `debian`, `latest`](https://github.com/aspen-lang/docker-aspen/blob/master/debian/Dockerfile)
- [`0-alpine`, `0.1-alpine`, `0.1.0-alpine`, `alpine`](https://github.com/aspen-lang/docker-aspen/blob/master/alpine/Dockerfile)

# How to use this image

```dockerfile
FROM aspenlang/aspen:alpine AS builder

RUN mkdir /MyProject
WORKDIR /MyProject

COPY pkg.yml .pkg.lock ./
RUN aspen pkg sync

COPY . .

RUN aspen build --static

FROM scratch

COPY --from=builder /MyProject/.aspen/out/MyProject /MyProject
CMD ["/MyProject"]
```
