#!/bin/bash
#title           : ssl_cert_checker_macos.sh
#description     : Checks validity and lifetimes of SSL certificates of your web servers.
#arg             : -
#author          : YoyaYOSHIDA(https://github.com/YoyaYOSHIDA)
#usage           : Execute manually.
#notes           : For MacOS.
#==============================================================================

# script dir
SCRIPT_DIR=$(cd $(dirname $0); pwd)

# dates
DATE_TODAY_UNIX=$(date +%s)

for CLIENT_URL in $(cat ${SCRIPT_DIR}/clients.list); do
  if openssl s_client -connect ${CLIENT_URL}:443 < /dev/null 2> /dev/null | openssl x509 -text -noout -enddate > /dev/null 2>&1; then
    PRE_RESULT="$(openssl s_client -connect ${CLIENT_URL}:443 < /dev/null 2> /dev/null | openssl x509 -text -noout -enddate | grep "Not After")"
    PRE_VALID_UNTIL="$(echo ${PRE_RESULT} | gsed -E "s/^Not\sAfter\s+:\s+//g" | awk '{print $1" "$2" "$4}')"
    VALID_UNTIL="$(gdate -d "${PRE_VALID_UNTIL}" '+%Y%m%d')"
    VALID_UNTIL_UNIX="$(gdate --date "${VALID_UNTIL} 00:00" +%s)"
    
    if [ ${DATE_TODAY_UNIX} -lt ${VALID_UNTIL_UNIX} ]; then
      echo "${CLIENT_URL},Valid,${VALID_UNTIL}"
    else
      echo "${CLIENT_URL},Expired,${VALID_UNTIL}"
    fi
  else
    echo "${CLIENT_URL},Unavailable,00000000"
  fi
done

