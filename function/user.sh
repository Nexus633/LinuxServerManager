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

#
# @function		user_exists()
# @discription	Check if User exists
# @param 		(string) user
#
user_exists(){
	local which_getent="$(which getent)"
	local user="$1"
	local result=""
	
	if [[ -n $which_getent ]]; then
		result=$($which_getent passwd $user)
		[[ -n $result ]] && return 0 || return 1

	else
		result="$(awk -F: '{print $1}' /etc/passwd | grep -x $user)"
		[[ -n $result ]] && return 0 || return 1
	fi
}

#
# @function		user_add()
# @discription	Add user if not exists
# @param 		(string) user
# @param 		(string) password
# @param 		(string) shell
# 	- @default		(string) /bin/false
#
user_add(){
	user_exists $1 && return 1

	local user="$1"
	local password="$2"
	local shell="${3:-/bin/false}" # default value /bin/false
	local hash_password=""
	local which_perl="$(which perl)"
	local timestamp="user add at: $(date +"%d.%m.%y %T")"
	
	hash_password=$($which_perl -e 'print crypt("'${password}'","Q9")')
	useradd -g users -p ${hash_password} -d /home/${user} \
			-m ${user} -c ${timestamp} -s ${shell} 2> $tmpfile 1> /dev/null
		
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

#
# @function		user_del()
# @discription	Delete User if exists
# @param 		(string) user
#
user_del(){
	user_exists $1 || return 1
	[[ $1 == "root" ]] && return 1
	local user="$1"
	
	. "${home_directory}/function/process.sh"

	kill_all_process_of_user $user
	
	userdel -r ${user} 2> $tmpfile 1> /dev/null
	
	[[ $? == 0 ]] && return 0 || return 1

	
}

#
# @function		user_passwd()
# @discription	change password from user
# @param		(string) user
# @param		(string) password
#
user_passwd(){
	user_exists $1 || return 1
	[[ "$1" == "root" ]] && return 1
	
	local user="$1"
	local password="$2"
	local which_perl="$(which perl)"
	local hash_password=$($which_perl -e 'print crypt("'${password}'","Q9")')
	
	usermod -p ${hash_password} $user
		
	[[ $? == 0 ]] && return 0 || return 1
}



