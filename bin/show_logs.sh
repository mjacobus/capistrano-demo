#!/usr/bin/env bash

sudo tail -f /var/log/php5-fpm.log \
  /var/log/nginx/*.log
