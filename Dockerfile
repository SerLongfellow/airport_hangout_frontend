FROM ruby:2.6-alpine

ENV WORK_DIR airport-hangout-frontend
ENV ENVIRONMENT test

RUN mkdir $WORK_DIR
WORKDIR $WORK_DIR

COPY Gemfile Gemfile.lock ./

RUN apk add --update nodejs ruby-dev build-base libxml2-dev libxslt-dev && \
    gem install bundler && \
    bundle config build.nokogiri --use-system-libraries && \
    gem install rails && \
    bundle install

COPY . .

EXPOSE 3000
CMD ["sh", "-c", "rails server -e ${ENVIRONMENT}"]
