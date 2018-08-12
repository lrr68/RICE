#!/bin/bash

#Notes CRUD
#script for taking simple notes in the terminal

#TODO
#remove function

NOTES_PATH="/home/lucca/.scripts/"

add_note()
{
	if [ ! -f $NOTES_PATH.notes ]; then
		touch $NOTES_PATH.notes
	fi
	read NOTE_NUMBER<<<$(awk 'END{print $1}' $NOTES_PATH.notes)
	NOTE_NUMBER=$((NOTE_NUMBER+1))
	DATE=`date +%Y-%m-%d`
	NOTE=$1
	shift
	TAG=$1
	shift
	echo "$NOTE_NUMBER--	$DATE	'$NOTE'	'$TAG'">>$NOTES_PATH.notes
	
}

list_notes()
{
	if test -f $NOTES_PATH.notes; then
		awk -F"\t" '{print $1. "\033[34m "$3"\033[0m"}' $NOTES_PATH.notes
	else
		echo 'No Notes'
	fi
}

filter_notes()
{
	if test -f $NOTES_PATH.notes; then
		echo "Notes with $1:"
		cat $NOTES_PATH.notes | grep "$1" | awk -F"\t" '{print $1. "\033[34m "$3"\033[0m"}'
		shift
	else
		echo 'No Notes'
	fi
}

show_help()
{
	echo "						aNote 	 [SOME NOTE] [SOME TAG]: Adds a note to a specific Tag"
	echo "						aNote -l : List all Notes"
	echo "						aNote -f [WORD/DATE]: Search for notes with that word, tag or date"
	echo "						aNote -r [NUMBER OF NOTE]: remove note"
}

remove_note()
{
	if test -f $NOTES_PATH.notes; then
		sed -i '/"$1"--/d' $NOTES_PATH.notes
		read ALL_NOTES<<<$(cat $NOTES_PATH.notes)
		if [ -n "$ALL_NOTES" ]; then
			rm $NOTES_PATH.notes
		fi
	else
		echo 'No Notes'
	fi
}

case $1 in
	-l) list_notes
		;;
	-f) shift; filter_notes "$1"
		;;
	-h) show_help
		;;
	-r) shift; remove_note "$1"
		;;
	*) add_note "$1" "$2"
		;;
esac
