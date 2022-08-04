FROM golang:1.17-buster AS builder

ENV GOARCH=arm64
WORKDIR /src
COPY . /src/
RUN go build -o bin/huawei-csi ./src/csi

# FROM debian:buster
FROM --platform=linux/arm64 debian:buster
COPY --from=builder /src/bin/huawei-csi /huawei-csi
RUN apt-get install e2fsprogs
RUN apt-get update && apt-get install -y \
    e2fsprogs \
    multipath-tools \
    nfs-common \
    xfsprogs \
    gawk \
    && rm -rf /var/lib/apt/lists/*
ENTRYPOINT [ "/huawei-csi" ]