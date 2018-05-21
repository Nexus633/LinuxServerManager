#!/usr/bin/env bash
#==============================================================================
#
#         FILE:  lsm.sh
#
#        USAGE:  
#
#  DESCRIPTION:  
#                
#                 
#
#      OPTIONS:  see function ’usage’ below
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Andre Rohlf, Andre_rohlf@msn.com
#      COMPANY:  ---
#      VERSION:  0.1
#      CREATED:  17.05.2018 - 21:00
#     REVISION:  ---
#==============================================================================

# trap to cleanup tmpfile
trap cleanup_tmpfile  SIGHUP SIGINT SIGPIPE SIGTERM EXIT RETURN


# Directorys
home_directory="$(cd $(dirname ${BASH_SOURCE[0]} ) && pwd )"
log_directory="${home_directory}/logs"
log_archiv_directory="${log_directory}/archiv"
cache_directory="${home_directory}/cache"
image_game_directory="${cache_directory}/game"
image_game_mod_directory="${cache_directory}/game/mod"
image_voice_directory="${cache_directory}/voice"

# Logs
logtime="$(date +"%d.%m.%y %T")"
logdate="$(date +"%Y-%m-%d")"
logfile="${log_directory}/${logdate}.log"

# Every 7 days the logs are archived
# 1 = every Day, 2.. 3.. 4.. 5.. 6.. 7..
log_archiv_interval=7


# Make a tempfile for cacheing
tmpfile="$(mktemp /tmp/lsm.XXXXX)"

#
# @function		cleanup_tmpfile()
# @discription	after this job clean tmpfile
# @see 			trap
#
cleanup_tmpfile() {
	[[ -e $tmpfile ]] && rm --force $tmpfile
	unset pid
	unset pids
}

#
# @function		function_exists()
# @discription	check function is exists for include
# @see 			trap
#
function_exists() {
    declare -f -F $1 > /dev/null
    return $?
}

# Set Debugmode on
set -x

. "${home_directory}/function/user.sh"

if ! function_exists kill_process; then
	. "${home_directory}/function/process.sh"
fi

user_add "Nexusf" "1234" "/bin/bash" && echo "User add" || echo "user not add"
#user_del "Nexusf" && echo "User del" || echo "user not del"
kill_process "Nexusf" "test-test-test" && echo "server stop" || echo "server not stop"

# Set Debugmode off
set +x



# install=false
# remove=false
# 
# while (( $# > 0 )); do
#	case $1 in
#		-i|--install)
#			[[ $remove == "true" ]] # && usage
#			install=true;;
#		-r|--remove)
#			[[ $install == "true" ]] # && usage
#			remove=true;;
#	esac
#	shift
# done


















