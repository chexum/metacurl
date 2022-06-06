#!/bin/sh

allgood=0

# XXX extra per-test options

# make sure we don't leave garbage around
unset FLDB
unset FLMETADIR
export TZ=UTC

export FLMETADIR=$(pwd)/.fl
mkdir -p $FLMETADIR
rm -f $FLMETADIR/2018-*
export FLDB=$(pwd)/.fl/meta.sdb
rm -f $FLDB
cat <<EOF|sqlite3 $FLDB
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "meta" (
path varchar(120),
fn varchar(80),                 --file
size integer,                   --size
stamp time,                     --stamp
md5 varchar(16),                --dig
sha1 varchar(20),
sha256 varchar(32),
githash varchar(20),
sig text,
mimetype varchar(20),           --type
mimecs varchar(20),
mimeenc varchar(20),            --encoding
url varchar(120),               --url
stored time,                    --present
server varchar(80),
etag varchar(80));
COMMIT;
EOF

rm -f .meta 030_*.html dup.030_*.html 032_*.html dup.032_*.html

export PYTHONIOENCODING=utf8
export PYTHON=$(PATH=/usr/local/bin:/usr/bin:$PATH which python3)

#or i in "$@"; do
for i in [0-9]*txt; do
  b=${i%.txt}
  fnm=$b.out
  exp=$b.err
  tm1=$b.tm1
  tm2=$b.tmp
  rm -f ./$fnm ./.dl_*
  $PYTHON ../metacurl --debug-summary --curl-command ./localfetch.sh $fnm 2>./$tm1
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

rm -f 030_*.html dup.030_*.html 032_*.html dup.032_*.html

exit $allgood
