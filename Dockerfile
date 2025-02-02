FROM golang:1.13.0-alpine3.10 AS builder

WORKDIR /app
RUN apk --no-cache add git make

COPY Makefile go.mod go.sum ./
RUN make mod tools

COPY . .
RUN make test lint build

FROM alpine:3.10

MAINTAINER Soren Mathiasen <sorenm@mymessages.dk>

RUN apk --no-cache add ca-certificates

COPY --from=builder /app/bin/k8s-rds /k8s-rds

ENTRYPOINT ["/k8s-rds"]
