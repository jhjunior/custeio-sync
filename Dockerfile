FROM golang:1.14-alpine AS builder

WORKDIR /go/src/github.com/tsuru/tsuru-client

RUN apk add --update gcc git make musl-dev

RUN git clone https://github.com/tsuru/tsuru-client.git .
    
RUN make build

FROM alpine:latest

COPY --from=builder /go/src/github.com/tsuru/tsuru-client/bin/tsuru /bin/tsuru

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

CMD ["tsuru"]
