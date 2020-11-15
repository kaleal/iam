FROM alpine:3.12.1
RUN adduser -D -h /iam run
RUN apk --update add --no-cache --virtual .build-deps \
        build-base \
        linux-headers \
        python3-dev \
        py3-pip \
    && apk add --no-cache \
        pcre-dev \
        python3 \
    && pip install --no-cache-dir \
        flask \
        uwsgi \
    && apk del .build-deps
WORKDIR /iam
COPY iam ./
USER run
CMD ["/usr/bin/uwsgi", "--master", "--enable-threads", "--socket", "0.0.0.0:5000", "--protocol=http", "-w", "wsgi:app", "--disable-logging"]
