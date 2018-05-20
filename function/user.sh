#!/usr/bin/env bash
#==============================================================================
#
#         FILE:  user.sh
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

user_exists(){
	local which_getent="$(which getent)"
	local user="$1"
	local result=""
	
	if [[ -n $which_getent ]]; then
		[[ -n $($which_getent passwd $user) ]] && return 0 || return 1
	else
		result="$(awk -F: '{print $1}' /etc/passwd | grep -x $user)"
		[[ -n $result ]] && return 0 || return 1
	fi
}

user_add(){
	[[ $(user_exists $1) ]] && return 1

	local user="$1"
	local password="$2"
	local shell="${3:-/bin/false}" # default value /bin/false
	local hash_password=""
	local which_perl="$(which perl)"
	
	hash_password=$($which_perl -e 'print crypt("'${password}'","Q9")')
	useradd -g users -p ${hash_password} -d /home/${user} \
			-m ${user} -s ${shell} 2> $tmpfile 1> /dev/null
		
	if [[ $? == 0 ]]; then
		if [[ "$shell" != "/bin/false" ]];then
			touch "/var/mail/${user}"
			chown "${user}:users" "/var/mail/${user}"
		else
			# if shell=/bin/false -> FTP User
			rm --force "/home/${user}/.bash_logout" \
						"/home/${user}/.bashrc" \
						"/home/${user}/.profile"
		fi
		return 0
	else
		return 1
	fi
}

user_del(){
	[[ ! $(user_exists $1) ]] && return 1
	# . "${home_directory}/function/process.sh"
	# if process of user running -> kill process then del user
	local user="$1"
	
	userdel -r ${user} 2> $tmpfile 1> /dev/null
	[[ $? == 0 ]] && return 0 || return 1
	
	
}





