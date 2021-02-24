FROM ruby:2.7-alpine

LABEL autor="Vitaly Kuzminov" maintainer="Repz2010@gmail.com"

RUN apk add --no-cache build-base \
    bash \
    chromium \
    chromium-chromedriver \
    curl

RUN mkdir /home/linkedin
WORKDIR /home/linkedin
COPY . .
RUN bundle

WORKDIR /tmp