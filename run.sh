#!/usr/bin/env bash

bundle check >/dev/null || bundle install 
bundle exec exe/compare 10000 1000

