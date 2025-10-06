#!/usr/bin/env bash
set -euo pipefail

# -------------------------
# Simple Load & Memory Monitor
# -------------------------
THRESHOLD_LOAD_PERCENT=80   # نسبة الحمل مقارنة بعدد الـ CPUs (مثلاً: 80%)
THRESHOLD_MEM_PERCENT=80    # نسبة الذاكرة المستهلكة (مثلاً: 80%)
LOG="$HOME/backup-monitor-monitor.log"

# calc load %
load=$(awk '{print $1}' /proc/loadavg)
cpus=$(nproc)
load_pct=$(awk -v l="$load" -v c="$cpus" 'BEGIN{printf "%.0f", (l/c)*100}')

# calc memory %
read total available < <(awk '/MemTotal/ {t=$2} /MemAvailable/ {a=$2} END {print t, a}' /proc/meminfo)
mem_used_pct=$(awk -v t="$total" -v a="$available" 'BEGIN{printf "%.0f", ((t-a)/t)*100}')

now=$(date '+%F %T')
alert=0

if [ "$load_pct" -ge "$THRESHOLD_LOAD_PERCENT" ]; then
echo "$now ALERT: loadavg=$load (load%=$load_pct, cpus=$cpus)" | tee -a "$LOG"
alert=1
fi

if [ "$mem_used_pct" -ge "$THRESHOLD_MEM_PERCENT" ]; then
avail_mb=$((available/1024))
echo "$now ALERT: memory_used%=$mem_used_pct, available=${avail_mb}MB" | tee -a "$LOG"
alert=1
fi

# optional: send email if mail command available (configure MTA first)
#if [ "$alert" -eq 1 ] && command -v mail >/dev/null 2>&1; then
#subject="Server Alert on $(hostname): load%=${load_pct} mem%=${mem_used_pct}"
#tail -n 10 "$LOG" | mail -s "$subject" you@example.com
#fi
#
exit 0
