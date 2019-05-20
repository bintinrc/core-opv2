#! /bin/sh

# reload RVM & hiptest-publisher
# source ~/.rvm/scripts/rvm

rvmFile="~/.rvm/scripts/rvm"

if [[ -f "$rvmFile" ]]
then
    source ${rvmFile}
fi

hiptest-publisher \
  --config-file hiptest-publisher.config \
  --push "build/reports/cucumber-junit/*.xml" \
  --push-format junit
