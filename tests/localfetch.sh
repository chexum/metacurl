#!/bin/sh
for i in "$@"; do
  case "x$i" in
    x-*) ;;
    x[0-9]*)
	i="${i%.out}"
	if [ -f "$i.txt" ]; then
	  cat "$i.txt";
	  exit 0
	fi
	;;
  esac
done
exit 0
