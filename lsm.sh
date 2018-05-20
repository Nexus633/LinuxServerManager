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
trap cleanup_tmpfile SIGHUP SIGINT SIGPIPE SIGTERM EXIT RETURN


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

cleanup_tmpfile() {
	[[ -e $tmpfile ]] && rm --force $tmpfile
}

. "${home_directory}/function/user.sh"

user_add "Nexusf" "1234" "/bin/bash" && echo yo || echo no


install=false
remove=false
 
while (( $# > 0 )); do
	case $1 in
		-i|--install)
			[[ $remove == "true" ]] # && usage
			install=true;;
		-r|--remove)
			[[ $install == "true" ]] # && usage
			remove=true;;
	esac
	shift
done


















