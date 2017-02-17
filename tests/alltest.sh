#!/bin/sh

allgood=0

# XXX extra per-test options

for i in [0-9]*txt; do
  b=${i%.txt}
  fnm=$b.out
  exp=$b.err
  tm1=$b.tm1
  tm2=$b.tmp
  rm -f ./$fnm
  ../metacurl --debug-summary --curl-command ./localfetch.sh $fnm 2>./$tm1
  sed -E 's/(.stored.):[0-9]+/\1:null/g' <./$tm1 >./$tm2
  rm -f ./$tm1
  diff -u $exp $tm2 >$fnm
  if [ "$?" = "0" ]; then
    echo $b OK
    rm -f ./$fnm ./$tm1 ./$tm2 # $exp
  else
    allgood=$?
    echo '!!' $b returned $allgood
    cat ./$fnm
    echo '--'
  fi
done
exit $allgood
