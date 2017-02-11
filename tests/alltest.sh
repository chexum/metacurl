#!/bin/sh

allgood=0

for i in [0-9]*txt; do
  b=${i%.txt}
  fnm=$b.out
  tmp=$b.tmp
  exp=$b.err
  ../metacurl --curl-command ./localfetch.sh $fnm 2>$tmp
  diff -u $exp $tmp >$fnm
  if [ "$?" = "0" ]; then
    echo $b OK
    rm -f $fnm $tmp # $exp
  else
    allgood=$?
    echo '!!' $b returned $allgood
    cat $fnm
    echo '--'
  fi
done
exit $allgood
