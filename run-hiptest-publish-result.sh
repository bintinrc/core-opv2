#! /bin/sh

# reload RVM & hiptest-publisher

hiptest-publisher \
  --config-file hiptest-publisher.config \
  --push "build/reports/cucumber-junit/*.xml" \
  --push-format junit
