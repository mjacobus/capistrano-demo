#!/usr/bin/env bash

cd /vagrant/vagrant

################################################################################
# Functions
################################################################################

function inform() {
  # echo -e '\E[32m'"\033[1m"
  echo "#############################################################################"
  echo "# $@"
  echo "#############################################################################"
  # echo -e "\033[0m"
}

function install() {
  inform "installing '$@'"
  DEBIAN_FRONTEND=noninteractive sudo apt-get install -y "$@"

  if (($? != 0)); then
    inform "Failed installing $@"
    exit $?
  fi
}

function include_or_exit_on_failure() {
  source $1 | exit 1
}

function exit_on_failure() {
  if (($1 != 0)); then

    if (($# > 1)); then
      inform $2
    else
      inform "Failed"
    fi

    exit $1
  fi
}

function template() {
  inform "Coping template $1"
  echo $PWD
  sudo cp -rfp  "templates/${1}" $1

  exit_on_failure $?
}

function backup() {
  local file=$1
  local backup=$file.bkp

  if [ ! -f $backup ]; then
    sudo cp -rfp $file $backup
    exit_on_failure $?
  fi
}

function restart_service() {
  sudo service $1 restart
  exit_on_failure $? "unable to restart service $1"
}

function run_or_fail() {
  local command="$@"
  $($command)
  exit_on_failure $? "Command '$command' failed"
}

function append_if_not_exists() {
  local content=$1
  local file=$2

  if !  grep -Fqs "$content" "$file" ; then
     printf "%s\n" "$content" >> "$file"
  fi
}

function as_vagrant_append_if_not_exists() {
  local content=$1
  local file=$2

  if ! grep -Fqs "$content" "$file" ; then
    as_vagrant "printf \"%s\n\" '$content' >> '$file'"
  fi
}

function as_vagrant() {
  local command="$@"
  # sudo -H -s -u vagrant bash -c "$command"
  sudo su vagrant --login -c "$command"
}

function as_vagrant_check() {
  local command="$2 > /dev/null 2>&1"
  as_vagrant $command

  if (( $? == 0 )); then
    echo "OK: $1"
  else
    echo "FAILED (code: $?): $1"
  fi
}

has() {
  type "$1" > /dev/null 2>&1
  return $?
}

vagrant_check() {
  local command="$1 > /dev/null 2>&1"
  as_vagrant $command
  return $?
}

has_ruby() {
  vagrant_check 'ruby --version | grep "ruby 2.3"'
  return $?
}

has_nginx() {
  vagrant_check 'curl -I localhost | grep "Server: nginx/1.8"'
  return $?
}

has_php() {
  vagrant_check 'php --version | grep "5.6"'
  return $?
}

has_npm() {
  vagrant_check 'npm --version | grep "^2\."'
  return $?
}

################################################################################
# Basic
################################################################################

sudo apt-get update -y
install git

################################################################################
# PHP
################################################################################

install python-software-properties
sudo add-apt-repository ppa:ondrej/php5-5.6
sudo apt-get -y update && sudo apt-get -y upgrade

install php5-fpm       \
        php5           \
        php5-cli       \
        php5-curl      \
        php5-gd        \
        php5-mysql     \
        php5-sqlite    \
        php5-intl      \
        php5-xsl       \
        php5-mcrypt    \
        php5-xdebug    \
        php5-mhash     \
        php5-memcache  \
        php5-memcached \
        php-apc

sudo php5enmod mcrypt
sudo php5enmod xdebug

exit_on_failure $?

function php_replace() {
  local find=$1
  local replace=$2
  local regexp="s/^$find$/$replace/g"

  sudo sed -i "$regexp" /etc/php5/fpm/php.ini
  exit_on_failure $?

  sudo sed -i "$regexp" /etc/php5/cli/php.ini
  exit_on_failure $?
}

php_replace "error_reporting =.*" "error_reporting = E_ALL"
php_replace "display_errors =.*" "display_errors = On"
php_replace "display_startup_errors =.*" "display_startup_errors = On"

sudo service php5-fpm restart
exit_on_failure $?

inform "Installing composer..."
if [ ! -f /usr/bin/composer ]; then
  curl -sS https://getcomposer.org/installer | php
  sudo mv composer.phar /usr/bin
  sudo ln -s /usr/bin/composer.phar /usr/bin/composer
fi

sudo composer self-update

sudo rm -f /etc/php5/cli/conf.d/20-xdebug.ini

################################################################################
# nginx
################################################################################
sudo add-apt-repository -y ppa:nginx/stable
sudo apt-get -y update
install nginx

PATH_AVAILABLE=/etc/nginx/sites-available
PATH_ENABLED=/etc/nginx/sites-enabled
TARGET_AVAILABLE=$PATH_AVAILABLE/vagrant
TARGET_ENABLED=$PATH_ENABLED/vagrant

sudo rm -f "${PATH_ENABLED}/default"
template $TARGET_AVAILABLE

sudo ln -sf $TARGET_AVAILABLE $TARGET_ENABLED
exit_on_failure $?

sudo service nginx restart
exit_on_failure $?

sudo ln -sf $TARGET_AVAILABLE $TARGET_ENABLED
exit_on_failure $?

# change ownership of services
sudo sed -i 's/www-data/vagrant/g' /etc/php5/fpm/pool.d/www.conf
sudo sed -i 's/www-data/vagrant/g' /etc/nginx/nginx.conf

PUBLIC_FOLDER=''

if [ -d /vagrant/public ]; then
  PUBLIC_FOLDER='\/public'
fi

sudo sed -i "s/_my_public_folder/$PUBLIC_FOLDER/g" $TARGET_AVAILABLE

# http://stackoverflow.com/questions/21422426/i-add-a-line-of-text-to-my-css-file-garbage-comes-through-the-browser
sudo sed -i 's/sendfile on/sendfile off/g' /etc/nginx/nginx.conf

sudo chown vagrant:vagrant /var/www

restart_service php5-fpm
restart_service nginx
