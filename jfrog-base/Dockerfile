FROM alpine:latest AS build

RUN apk add curl bash

WORKDIR /jfrog

RUN curl -fL https://install-cli.jfrog.io | sh
COPY hack/cp-jf.sh .

RUN cat ./cp-jf.sh | sh

#############################

FROM alpine:latest

WORKDIR /jfrog

COPY --from=build /jfrog/jf .

ENTRYPOINT [ "./jf" ]