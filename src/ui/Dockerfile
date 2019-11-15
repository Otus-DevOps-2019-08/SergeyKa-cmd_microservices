FROM alpine:3.10

ENV APP_HOME /app
RUN mkdir ${APP_HOME}
WORKDIR ${APP_HOME}
ADD Gemfile* ${APP_HOME}/

ENV BUILD_PACKAGES bash curl curl-dev ruby-dev build-base
ENV RUBY_PACKAGES \
  ruby ruby-io-console ruby-irb \
  ruby-json ruby-etc ruby-bigdecimal ruby-rdoc \
  libffi-dev zlib-dev
ENV TERM=linux
ENV PS1 "\n\n>> ruby \W \$ "

RUN apk --no-cache add $BUILD_PACKAGES $RUBY_PACKAGES

RUN echo 'gem: --no-document' > /etc/gemrc && \
    gem install bundler \
    && bundle update --bundler \
    && bundle install \
    && gem update --system \
    && bundle config --global silence_root_warning 1

ADD . ${APP_HOME}

ENV POST_SERVICE_HOST post_modified
ENV POST_SERVICE_PORT 5001
ENV COMMENT_SERVICE_HOST comment_modified
ENV COMMENT_SERVICE_PORT 9292

CMD [ "puma" ]
