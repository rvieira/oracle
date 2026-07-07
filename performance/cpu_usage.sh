ps -eo pcpu,args \
| awk '
/ora_/ && !/awk/ {
  sid="unknown"
  for (i=1;i<=NF;i++) {
    if ($i ~ /ora_.*_/) {
      split($i,a,"_")
      sid=a[length(a)]
    }
  }
  cpu[sid]+=$1
}
END {
  for (s in cpu) printf "%-20s %8.2f%%\n", s, cpu[s]
}' | sort -k2 -nr