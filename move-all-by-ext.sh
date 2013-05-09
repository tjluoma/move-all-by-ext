#!/usr/bin/env zsh
# move all files of a specific extension to a certain directory
#
# From:	Timothy J. Luoma
# Mail:	luomat at gmail dot com
# Date:	2013-05-09

	# This refers to the name of this shell script, without the path or the extension.
NAME="$0:t:r"

	# Change this to the directory that you want the files to be moved to. Use $HOME to refer to
	# your home directory.
MOVE_TO="$HOME/Desktop/$NAME"



	# If you want to search for a different extension (such as GIF or DOC) then change the next line.
	# Please note that this is case insensitive, so JPG=jpg=JpG
	#
	# Do NOT include a '.' !!
EXT=JPG






####|####|####|####|####|####|####|####|####|####|####|####|####|####|####
####|####|####|####|####|####|####|####|####|####|####|####|####|####|####
####|####|####|####|####|####|####|####|####|####|####|####|####|####|####
####|####|####|####|####|####|####|####|####|####|####|####|####|####|####
####|####|####|####|####|####|####|####|####|####|####|####|####|####|####
#
#
#
#
#
#	You should not have to edit anything below this line











	## Check to make sure that MOVE_TO exists, or try to create it

	# this will not complain if MOVE_TO is already exists as a directory
mkdir -p "$MOVE_TO"

	# if it still does not exist, bail out
if [ ! -d "$MOVE_TO" ]
then

	echo "	$NAME: $MOVE_TO is not a directory"

	exit 1
fi

#
#

if [ "$#" = "0" ]
then
		command tput bel

		echo "\n$NAME: Error: You must tell me the name of at least one folder to check.\n"

		echo "	$NAME will move any files which end with .$EXT which are found in the folder(s) you tell me to search, (and their subfolders, if any).\n"

		echo "	Currently $NAME it set to move all ${EXT}s to '$MOVE_TO/' but you can change that by editing the 'MOVE_TO=' line in $0. You can also change the types of files which $NAME looks for by changing the line 'EXT='.\n\n"

		echo "	Example:\n\n\t$0:t $HOME/Downloads/"

		exit 1
fi

COUNT=0

for DIR in "$@"
do

	if [ -d "$DIR" ]
	then

			echo "\n	$NAME: Looking for files ending with .${EXT} in ${DIR}..."

				# this will look in the directory for any file which ends in .${EXT} (regardless of case)
				# and move it to the folder we have designated above.
				#
				#	`man mv` on OS X says:
				#
				#      The -n and -v options are non-standard and their use in scripts is not recommended.
				#
				#	-v is fairly universal these days
				#	-n is OSX-specific, but this script was written explicitly for OS X
				#	-i (interactive) would probably have been better, but I prefer -n
				#
			find "$DIR" -type f -iname \*.${EXT} -exec /bin/mv -vn {} "$MOVE_TO/" \;

				# Now, let's see if we got them all
			LEFTOVERS=$(find "$DIR" -type f -iname \*.${EXT} -print | wc -l | tr -dc '[0-9]')

				# check for any leftovers
			if [ "$LEFTOVERS" = "0" ]
			then
					echo "	$NAME: Success! No ${EXT}s remain in $DIR or any sub-folders.\n"
			elif [ "$LEFTOVERS" = "1" ]
			then
					echo "\n\n	$NAME: WARNING! One ${EXT} file remains in $DIR or one of its sub-folders.\n"
					((COUNT++))

			else
					echo "\n\n	$NAME: WARNING! There are $LEFTOVERS ${EXT} files remaining in $DIR (or subfolders).\n"
					((COUNT++))
			fi

	else
			echo "	$NAME: $DIR is not a directory"

	fi

done



ERROR_MSG="Usually this happens when a file could not be moved because it would have overwritten an existing file. Checking the same folders with $0:t again may help track down the error."

DONE_MSG="$NAME is done. Any files which were found were moved to $MOVE_TO/"


if [ "$COUNT" = "0" ]
then

		echo "\n	$DONE_MSG. No errors were recorded.\n"
		exit 0

elif [ "$COUNT" = "1" ]
then

		echo "\n	$DONE_MSG. \n\n	$NAME encountered 1 error. $ERROR_MSG\n\n"

else
		echo "\n	$DONE_MSG.\n\n	$NAME encountered $COUNT errors. $ERROR_MSG\n\n"
fi


exit 1
#
#EOF
