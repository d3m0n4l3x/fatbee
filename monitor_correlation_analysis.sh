#!/bin/sh
watch -n 1 "echo 'Command: tail -n 10 /usr/local/sbin/fatbee/correlation/all.log'; tail -n 10 /usr/local/sbin/fatbee/correlation/all.log; echo '+++++'; echo 'Command: tail -n 10 /usr/local/sbin/fatbee/correlation/correlation_analysis_log.log'; tail -n 10 /usr/local/sbin/fatbee/correlation/correlation_analysis_log.log; echo '+++++'; echo 'Command: tail -n 10 /usr/local/sbin/fatbee/correlation/dangerous_ip_log_after_analyzing.log'; tail -n 10 /usr/local/sbin/fatbee/correlation/dangerous_ip_log_after_analyzing.log" 

