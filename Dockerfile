# TAG 0.2

FROM alpine:latest

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
ENV PYCURL_SSL_LIBRARY=openssl

ENV TSURU_VERSION 1.8.1

RUN apk update

RUN apk add --no-cache ca-certificates

RUN set -ex \
     && apk add --no-cache \
        openssl \
        go \
        make \
        tzdata \
        curl \
        cyrus-sasl-dev
RUN rm /var/cache/apk/*

RUN set -ex \
  && cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
  && curl -L -O https://github.com/tsuru/tsuru-client/releases/download/${TSURU_VERSION}/tsuru_${TSURU_VERSION}_linux_386.tar.gz \
  && tar -xvzf tsuru_${TSURU_VERSION}_linux_386.tar.gz \
  && mv tsuru /usr/bin \
  && chmod a+x /usr/bin/tsuru \
  && rm tsuru_${TSURU_VERSION}_linux_386.tar.gz \
  && tsuru --version

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH
