#!/usr/bin/bash

path_to_file=$1
prefix="_thumbnail"

resize_img() {
	
	image=$1
	img_height=$(identify $image | cut -d\  -f3 | cut -dx -f1)
	img_width=$(identify $image | cut -d\  -f3 | cut -dx -f2)
	if [ $img_height -gt $img_width ]
	then
		img_newheight=360
		convert $image -resize "$img_width"x"$img_newheight"\! ${image%.*}$prefix.${image##*.}
	elif [ $img_width -gt $img_height ]
	then
		img_newwidth=360
		convert $image -resize "$img_newwidth"x"$img_height"\! ${image%.*}$prefix.${image##*.}
	fi	
}

get_img() {
	for file in $(find . -iname "*.jpg")
 	do
			if [ -f $file ]
			then
				img=$(echo $file | sed "s/$prefix//g")
				resize_img $img
			fi
       	done
}

get_img_from_file() {
	
	list_files=$1
	if [ -e $list_files ]
	then
		while read file
		do
			if [ -f $file ] 
                        then
				if [ ${file##*.} == "JPG" ] || [ ${file##*.} == "jpg" ]
				then
					img=$(echo $file | sed "s/$prefix//g")
					resize_img $img
				else
					echo "File $file is not JPG"
				fi
			else
				echo "File $file is not existed"
			fi
		done < $list_files
	else 
		echo "File not exist"
	fi
}

if [ $# -eq "0" ]
then
	get_img

elif [ $# -eq "1" ]
then
	get_img_from_file $path_to_file
else
	echo "Too many arguments"
fi
