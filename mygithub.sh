#!/bin/bash
# by Wiesław Magusiak, 2013-11-05
# Download your stuff from github.com
#
VERSION=0.01
function usage () {
	echo -ne "\n\e[1m${0##*/}\e[0m [\e[1m-u \e[0;4mOWNER\e[0m] ["
	echo -e "\e[1m-r \e[0;4mREPO\e[0m] [\e[1m-f \e[0;4mFILE\e[0m]"
	echo -e "\tOWNER defaults to \$USER."
	echo -e "\tAt least one of the REPO and FILE pair must be invoked."
}

while getopts "o:r:f:pzvh" flag; do
	case $flag in
		o) OWNER="$OPTARG";;
		r) REPO="$OPTARG";;
		f) FILE="$OPTARG";;
		p) PKG=1;;
		z) GZIP=1;;			# Download a gzipped repo
		v) echo -e "\n\t${0##*/}, v$VERSION"; exit;;
		h) usage; exit;;
	esac
done
FILE=${FILE=""}; REPO=${REPO-""}
WWW="github.com"/${OWNER-$USER}
WWW=${WWW%/}
[[ -n "$REPO" && -z "$FILE" ]] && GZIP=1 || GZIP=${GZIP-0}
PKG=${PKG-0}

if [[ -z "$FILE" && -z "$REPO" ]]; then
	usage
	echo -e "\t\e[31;1m\$REPO and \$FILE cannot both be empty.\e[0m"
	exit
fi

if [[ -n "$FILE" && -n "$REPO" ]]; then
	A="Y"
	if [[ -e "$FILE" ]]; then
		echo -n "The file $FILE exists. "
		read -p "Overwrite?  (N/y) " -n1 A
	fi
	if [[ $A = [yY] ]]; then
		echo -e "\nTrying to download $FILE"
		curl -silent -o ${FILE} -L --fail "https://raw.${WWW}/${REPO}/master/${FILE}"
		[[ $? == 22 ]] && echo File $FILE not found.
	else
		[[ -z "${A}" ]] || A="\n"
		echo -e "${A}Aborting download..."
	fi
fi

# FILE is defined, and REPO is not. Look for a REPO containing FILE name.
if [[ -z "$REPO" ]]; then
	echo "Making a repository list..."
	x=$(curl -silent -L "https://${WWW}?tab=repositories" |grep "/${OWNER}/" |grep "</a>")
	x=${x//<\/a>/}
	x=${x//<a href=\"\/${OWNER}\//}
	x=$(echo -e "$x"|cut -d">" -f2|sort) 				# List of all repositories
	LEN=0
	for f in $x; do
		LEN0=${#f}
		[[ $LEN0 -gt $LEN ]] && LEN=$LEN0 				# Longest repo name length
	done

	echo -e "Looking for \e[1m${FILE}\e[0m in..."
	i=0
	for f in $x; do
		printf "%5d.  %s %$((${#f}-${LEN}-1))s " $((++i)) ${f} " "
		curl -silent -o "${FILE}_in_${f}" -L -fail "https://raw.${WWW}/${f}/master/${FILE}"
		if [[ $? == 0 ]]; then
			echo -e "\e[1mFound and downloaded.\e[0m"
			REPO="${REPO} ${f}"
		else
			echo Not found.
		fi
		#y=${y}"\n"$f:$(curl -silent -L "https://${WWW}/${f}" | grep "blob/master" | \
		#	sed "s/^.*master\///"|sed "s/\".*$//"|grep $FILE)
	done
	#REPO=$(echo -e "$y"|grep -v :$|cut -d: -f1) 		# List of repos holding $FILE
fi

if [[ -n "$REPO" ]]; then
	if [[ $GZIP == 1 ]]; then
		echo "Downloading tar.gz's..."
		for f in $REPO; do 
			y=$(curl -silent -L https://${WWW}/${f}/releases |grep -m1 tar.gz|cut -d\" -f2)
			TAG=${y##*/}; TAG=${TAG%.tar.gz}
			if [[ -n $TAG ]]; then
				#echo $y
				echo -e "\t${f} $TAG"
				curl --silent --fail -o ${f}_${y##*/} -L https://github.com${y}
				#https://github.com/${OWNER}/${REPO}/archive/${TAG}.tar.gz
				#https://codeload.github.com/${OWNER}/${REPO}/tar.gz/${TAG}
			fi
		done
	fi
	if [[ $PKG == 1 ]]; then
		x="PKGBUILD"
		echo "Looking for ${x}s..."
		for f in $REPO; do
			curl -silent -o "${x}.${f}" -L \
				-fail "https://raw.github.com/${OWNER}/${x}s/master/${x}.${f}"
			[[ $? == 0 ]] && echo -e "\t${x}.${f} downloaded."
		done
	fi
fi