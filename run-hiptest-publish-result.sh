#! /bin/sh

hiptest-publisher \
  --config-file hiptest-publisher.config \
  --push build/reports/cucumber-junit/cucumber.xml \
  --push-format junit
