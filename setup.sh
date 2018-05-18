#!/bin/sh
###############################################################################
#
# 第一引数に、IPを指定し、hostsと、site.ymlを更新する。
# 前提として、IPは一つ
#
###############################################################################
NAME=${0##*/}

MAIN() {
  IP=$1

  if [ -e hosts.org ]; then
    if ! diff hosts.org hosts > /dev/null; then
      cp -pf hosts.org /tmp
    fi
  fi
  cp -p hosts hosts.org

  if [ -e site.yml.org ]; then
    if ! diff site.yml.org site.yml > /dev/null; then
      cp -pf site.yml.org /tmp
    fi
  fi
  cp -p site.yml site.yml.org

  sed 's%[0-9]\+\(\.[0-9]\+\)\{3\}%'${IP:?}'%' hosts.org    > hosts
  sed 's%[0-9]\+\(\.[0-9]\+\)\{3\}%'${IP:?}'%' site.yml.org > site.yml

  CHECK
  return $?
}

CHECK() {
  HOSTS_FILE=$(grep -oE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" hosts)
  SITE_YML=$(grep -oE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" site.yml)

  # :?によるチェック
  echo ${HOSTS_FILE:?} > /dev/null
  echo ${SITE_YML:?}   > /dev/null

  if [ ${HOSTS_FILE:?} = ${SITE_YML:?} ]; then
    echo "CHECK OK"
    return 0
  fi
  return 1
}

MAIN "$@"
exit $?
