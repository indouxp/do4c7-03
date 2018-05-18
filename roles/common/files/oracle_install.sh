#!/bin/sh
NAME=${0##*/}

/home/oracle/database/runInstaller -ignoreSysPrereqs -waitforcompletion -silent -responseFile /home/oracle/oracle_install.rsp
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  logger local0.err "${NAME:?} runInstaller fail. ${RC:?}"
  exit ${RC:?}
fi

exit 0
