FROM alpine:latest

RUN wget https://github.com/tsuru/tsuru-client/releases/download/1.8.1/tsuru_1.8.1_linux_amd64.tar.gz -O tsuru.tar.gz

RUN tar -zxvf tsuru.tar.gz tsuru && rm tsuru.tar.gz

COPY /tsuru /bin/tsuru

RUN apk update

RUN apk add --no-cache ca-certificates

RUN set -ex \
     && apk add --no-cache \
        openssl \
        go \
        cyrus-sasl-dev
RUN rm /var/cache/apk/*

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH