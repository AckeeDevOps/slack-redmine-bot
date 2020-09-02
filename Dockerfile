# build binary

FROM golang:alpine AS builder

RUN apk --update --no-cache add --virtual build-dependencies \
    git make \
    && git clone https://github.com/muxx/slack-redmine-bot /root/repo \
    && make build -C /root/repo \
    && cp /root/repo/bin/slack-redmine-bot / \
    && rm -rf /root/repo \
    && apk update && apk del build-dependencies

# build image

FROM alpine

ENV REDMINE_URL=
ENV REDMINE_API_KEY=
ENV SLACK_TOKEN=

RUN apk --update --no-cache add gettext # install envsubst

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /slack-redmine-bot /slack-redmine-bot
COPY ./config.yml.template /
COPY ./docker-entrypoint.sh /

WORKDIR /

ENTRYPOINT [ "/docker-entrypoint.sh" ]
