FROM ruby:3.4.6-bookworm AS base

ENV LANG=C.UTF-8
ENV BUNDLE_PATH=/usr/local/bundle

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      git \
      libsodium23 \
    && rm -rf /var/lib/apt/lists/*

RUN gem install bundler -v 2.7.2 --no-document
RUN bundler _2.7.2_ --version

COPY *.gemspec ./
COPY Gemfile Gemfile.lock* ./

RUN bundler _2.7.2_ install

RUN bundle install

COPY . .

CMD ["bash"]
