#! /bin/sh

# reload RVM & hiptest-publisher
source ~/.rvm/scripts/rvm

hiptest-publisher \
  --config-file hiptest-publisher.config \
  --push build/reports/cucumber-junit/cucumber.xml \
  --push-format junit
