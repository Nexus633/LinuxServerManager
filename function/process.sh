#!/usr/bin/env bash
#==============================================================================
#
#         FILE:  process.sh
#
#        USAGE:  do not use this file standalone
#
# REQUIREMENTS:  lsm.sh
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Andre Rohlf, Andre_rohlf@msn.com
#      COMPANY:  ---
#      VERSION:  see lsm.sh
#      CREATED:  20.05.2018 - 14:57
#     REVISION:  ---
#==============================================================================

# Singel ProzessID
pid=""

# sub ProzessID of pid
ppid=""

# Multi ProzessID
pids=()

#
# @function		kill_all_process_of_user()
# @discription	kill all serverprocess bei user
# @param 		(string) user
# @param 		(string) screen_name
#
kill_all_process_of_user(){
	local user="$1"
	user_exists $user || return 1
	
	get_all_process_ids $user
	
	if [[ -n ${pids} ]]; then
		for p in ${pids[*]}; do
			kill -9 $p 2> /dev/null
			[[ $? > 0 ]] && return 1
		done
	fi
	return 0
}

#
# @function		kill_process()
# @discription	kill serverprocess bei user and screen_name
# @param 		(string) user
# @param 		(string) screen_name
#
kill_process(){
	local user="$1"
	local screen_name="$2"
	user_exists $user || return 1
	
	get_process_id $user $screen_name && kill $pid 2> $tmpfile 
	if [ -z $(cat $tmpfile) ]; then
		return 0
	else
		return 1
	fi
}

#
# @function		get_process_id()
# @discription	get pid by user and screen
# @param 		(string) user
# @param 		(string) screen_name
#
get_process_id(){
	local user="$1"
	local user_id="$(id -u $user)"
	local screen_name="$2"
	local search_pattern='((/SCREEN/)&&(/'${screen_name}'/))'

	user_exists $user || return 1
	
	[[ -z $user_id ]] && return 1
	
	pid=$(ps xa -o uid,pid,cmd | awk '
			'$search_pattern'{
				if( $1 == '${user_id}' ){
					print $2
				}
			}'
		)
	
	if [[ -n $pid ]]; then
		ppid=$(ps --ppid ${pid} | tail -n1 | awk '{print $1}')
		return 0
	else
 		return 1
	fi
}

_check_java_process(){
	local user="$1" 
}

#
# @function 	get_all_process_ids()
# @discription 	get all pids by user
# @param		(string) user
#
get_all_process_ids(){
	local user="$1"
	local user_id="$(id -u $user)"
	
	user_exists $user || return 1
	[[ -z $user_id ]] && return 1
	
	pids=$(ps xa -o uid,pid | awk '{
			if( $1 == '${user_id}' ){
				print $2
			} 
		}')
	echo $pids
}

get_used_mem(){
	local user="$1"
	local screen_name="$2"
	
	get_process_id $user $screen_name || {
		echo 0
		return 0
	}
	
	use_pid="$pid"
	
	[[ -n $ppid ]] && use_pid=$ppid
	
	mem=$(ps xa -o pid,rss | awk '{
			if( $1 == '${use_pid}' ){
			
				if( ($2/1024) ~ /^0/ ){
					printf "%dKb", $2
				}else{
					printf "%.0fMb", ($2/1024)
				}
			}
		}')
	
	
	echo  $mem
}

