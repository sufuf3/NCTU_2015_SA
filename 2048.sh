#!/bin/sh

dialog --title "" --ok-label "Play a Game" --msgbox "Game 2048\n
     ____    _    __  __ _____  \n
    / ___|  / \  |  \/  | ____| \n
   | |  _  / _ \ | |\/| |  _|   \n
   | |_| |/ ___ \| |  | | |___  \n
    \____/_/   \_\_|  |_|_____| \n
     ____   ___  _  _    ___  \n
    |___ \ / _ \| || |  ( _ ) \n
      __) | | | | || |_ / _ \ \n
     / __/| |_| |__   _| (_) |\n
    |_____|\___/   |_|  \___/ \n
" 20 60

is_exist=`ls | grep 'game_tmp'`
if [ -z is_exist ] ; then
TMPFILE=`mktemp game_tmp`
chmod 777 $TMPFILE
else
TMPFILE='game_tmp'
fi

printtable(){
        dialog --title "" --nook --no-collapse  --infobox "
	 --------------------------------------------------------------- \n
	|		|		|		|		|\n
	|	$1	|	$2	|	$3	|	$4	|\n
	|		|		|		|		|\n
	 ---------------------------------------------------------------\n
	|		|		|		|		|\n
	|	$5	|	$6	|	$7	|	$8	|\n
	|		|		|		|		|\n
	 --------------------------------------------------------------- \n
	|		|		|		|		|\n
	|	$9	|	${10}	|	${11}	|	${12}	|\n
	|		|		|		|		|\n
	 --------------------------------------------------------------- \n
	|		|		|		|		|\n
	|	${13}	|	${14}	|	${15}	|	${16}	|\n
	|		|		|		|		|\n
	 --------------------------------------------------------------- \n
" 20 85

}

addrandom(){
	IFS=','
        num1=`jot -r 1 2 1`
        num=`echo $(( $num1 * 2 ))`
	arr1=
	for i in ${arr} ; do
		IFS=$oIFS
		if [ -z $arr1 ]; then
			arr1=$i
		continue
		fi
		if [ -z $i ] ; then
			arr1=$arr1," "
		else
			arr1=$arr1,$i
		fi
	done
	arr=$arr1
	flag=0
	ranaddr=`jot -r 1 16 1`
	while [ $flag -eq 0 ] ; do
		ranaddr=`jot -r 1 16 1`
		isaddr=`echo ${arr},$ranaddr | awk -v ad=17 'BEGIN {FS=",";}{for(i=1;i<=16;i++)if(i==$ad && $i==" "){print "1"}}'`
		if [ -z $isaddr ] ; then
			continue
		else
			flag=1
		fi
	done
	arr1=`echo ${arr},$ranaddr,$num | awk -v ad=17 -v n=18 'BEGIN {FS=",";}{for(i=1;i<=16;i++)if(i==$ad){array[all++]=$n}else{array[all++]=$i;}}END{for(i=0;i<=15;i++)if(i==15){print array[i]}else{printf array[i]","}}'`
	arr=$arr1
}

moveup(){
	for s in 1 2 3 ; do
		for i in 1 2 3 4 ; do
			for t in $i $(( $i + 4 )) $(( $i + 8 )) ; do
				addr1=`echo ${arr}| awk -v n=$t 'BEGIN {FS=","}{print $n }'`
				addr2=`echo ${arr}| awk -v n=$(( $t + 4 )) 'BEGIN {FS=","}{print $n }'`
				if [ $addr1 = " " ] && [ $addr2 != " " ]  ; then
					arr1=`echo ${arr},$addr2,$t,$(( $t + 4 ))| awk -v a=17 -v b=18 -v d=19 'BEGIN {FS=",";}{for(i=1;i<=16;i++)if(i==$b){array[all++]=$a}else if(i==$d){array[all++]=" "}else{array[all++]=$i;}}END{for(i=0;i<=15;i++)if(i==15){print array[i]}else{printf array[i]","}}'`
					arr=$arr1
					moved=1
				fi
			done
		done
	done
}
makeup(){
	moveup
	for i in 1 2 3 4 ; do
		for t in $i $(( $i + 4 )) $(( $i + 8 )) ; do
			addr1=`echo ${arr}| awk -v n=$t 'BEGIN {FS=","}{print $n }'`
			addr2=`echo ${arr}| awk -v n=$(( $t + 4 )) 'BEGIN {FS=","}{print $n }'`
			if [ $addr1 = $addr2 ] && [ $addr1 != " " ]; then
				arr1=`echo ${arr},$addr1,$t,$(( $t + 4 )) | awk -v a=17 -v ad1=18 -v ad2=19 'BEGIN {FS=",";}{for(i=1;i<=16;i++)if(i==$ad1){array[all++]=$a*2}else if(i==$ad2){array[all++]=" "}else{array[all++]=$i;}}END{for(i=0;i<=15;i++)if(i==15){print array[i]}else{printf array[i]","}}'`
                                arr=$arr1
                                moved=1
			fi
		done	
	done
	moveup	
}
movedown(){
        for s in 1 2 3 ; do
                for i in 1 2 3 4 ; do
                        for t in $(( $i + 12 )) $(( $i + 8 )) $(( $i + 4 )) ; do
                                addr1=`echo ${arr}| awk -v n=$t 'BEGIN {FS=","}{print $n }'`
                                addr2=`echo ${arr}| awk -v n=$(( $t - 4 )) 'BEGIN {FS=","}{print $n }'`
                                if [ $addr1 = " " ] && [ $addr2 != " " ]  ; then
                                        arr1=`echo ${arr},$addr2,$t,$(( $t - 4 ))| awk -v a=17 -v b=18 -v d=19 'BEGIN {FS=",";}{for(i=1;i<=16;i++)if(i==$b){array[all++]=$a}else if(i==$d){array[all++]=" "}else{array[all++]=$i;}}END{for(i=0;i<=15;i++)if(i==15){print array[i]}else{printf array[i]","}}'`
                                        arr=$arr1
                                        moved=1
                                fi
                        done
                done
        done
}
makedown(){
	movedown
        for i in 1 2 3 4 ; do
                for t in $(( $i + 12 )) $(( $i + 8 )) $(( $i + 4 )) ; do
                        addr1=`echo ${arr}| awk -v n=$t 'BEGIN {FS=","}{print $n }'`
                        addr2=`echo ${arr}| awk -v n=$(( $t - 4 )) 'BEGIN {FS=","}{print $n }'`
                        if [ $addr1 = $addr2 ] && [ $addr1 != " " ]; then
                                arr1=`echo ${arr},$addr1,$t,$(( $t - 4 )) | awk -v a=17 -v ad1=18 -v ad2=19 'BEGIN {FS=",";}{for(i=1;i<=16;i++)if(i==$ad1){array[all++]=$a*2}else if(i==$ad2){array[all++]=" "}else{array[all++]=$i;}}END{for(i=0;i<=15;i++)if(i==15){print array[i]}else{printf array[i]","}}'`
                                arr=$arr1
                                moved=1
                        fi
                done
        done
	movedown
}
moveleft(){
	for s in 1 2 3 ; do
		for i in 0 1 2 3 ; do
			t1=$(( $i * 4 + 1 ))
                        for t in $t1 $(( $t1 + 1 )) $(( $t1 + 2 )) ; do
                                addr1=`echo ${arr}| awk -v n=$t 'BEGIN {FS=","}{print $n }'`
                                addr2=`echo ${arr}| awk -v n=$(( $t + 1 )) 'BEGIN {FS=","}{print $n }'`
                                if [ $addr1 = " " ] && [ $addr2 != " " ]  ; then
                                        arr1=`echo ${arr},$addr2,$t,$(( $t + 1 ))| awk -v a=17 -v b=18 -v d=19 'BEGIN {FS=",";}{for(i=1;i<=16;i++)if(i==$b){array[all++]=$a}else if(i==$d){array[all++]=" "}else{array[all++]=$i;}}END{for(i=0;i<=15;i++)if(i==15){print array[i]}else{printf array[i]","}}'`
                                        arr=$arr1
                                        moved=1
                                fi
                        done
                done
        done
}
makeleft(){ 
	moveleft
	for i in 0 1 2 3 ; do
		t1=$(( $i * 4 + 1 ))
		for t in $t1 $(( $t1 + 1 )) $(( $t1 + 2 )) ; do
			addr1=`echo ${arr}| awk -v n=$t 'BEGIN {FS=","}{print $n }'`
			addr2=`echo ${arr}| awk -v n=$(( $t + 1 )) 'BEGIN {FS=","}{print $n }'`
			if [ $addr1 = $addr2 ] && [ $addr1 != " " ]; then
				arr1=`echo ${arr},$addr1,$t,$(( $t + 1 )) | awk -v a=17 -v ad1=18 -v ad2=19 'BEGIN {FS=",";}{for(i=1;i<=16;i++)if(i==$ad1){array[all++]=$a*2}else if(i==$ad2){array[all++]=" "}else{array[all++]=$i;}}END{for(i=0;i<=15;i++)if(i==15){print array[i]}else{printf array[i]","}}'`
				arr=$arr1
				moved=1
			fi
		done
	done
	moveleft
}
moveright(){
        for s in 1 2 3 ; do
                for i in 4 3 2 1 ; do
                        t1=$(( $i * 4 ))
                        for t in $t1 $(( $t1 - 1 )) $(( $t1 - 2 )) ; do
                                addr1=`echo ${arr}| awk -v n=$t 'BEGIN {FS=","}{print $n }'`
                                addr2=`echo ${arr}| awk -v n=$(( $t - 1 )) 'BEGIN {FS=","}{print $n }'`
                                if [ $addr1 = " " ] && [ $addr2 != " " ]  ; then
                                        arr1=`echo ${arr},$addr2,$t,$(( $t - 1 ))| awk -v a=17 -v b=18 -v d=19 'BEGIN {FS=",";}{for(i=1;i<=16;i++)if(i==$b){array[all++]=$a}else if(i==$d){array[all++]=" "}else{array[all++]=$i;}}END{for(i=0;i<=15;i++)if(i==15){print array[i]}else{printf array[i]","}}'`
                                        arr=$arr1
                                        moved=1
                                fi
                        done
                done
        done
}
makeright(){
	moveright
        for i in 4 3 2 1 ; do
                t1=$(( $i * 4 ))
                for t in $t1 $(( $t1 - 1 )) $(( $t1 - 2 )) ; do
                        addr1=`echo ${arr}| awk -v n=$t 'BEGIN {FS=","}{print $n }'`
                        addr2=`echo ${arr}| awk -v n=$(( $t - 1 )) 'BEGIN {FS=","}{print $n }'`
                        if [ $addr1 = $addr2 ] && [ $addr1 != " " ]; then
                                arr1=`echo ${arr},$addr1,$t,$(( $t - 1 )) | awk -v a=17 -v ad1=18 -v ad2=19 'BEGIN {FS=",";}{for(i=1;i<=16;i++)if(i==$ad1){array[all++]=$a*2}else if(i==$ad2){array[all++]=" "}else{array[all++]=$i;}}END{for(i=0;i<=15;i++)if(i==15){print array[i]}else{printf array[i]","}}'`
                                arr=$arr1
                                moved=1
                        fi
                done
        done
	moveright
}
game(){
	IFS=','
	printtable ${arr}
	while true ; do
		arr1=
		for i in ${arr} ; do
			IFS=$oIFS
			if [ -z $arr1 ]; then
				arr1=$i
				continue
			fi
			if [ -z $i ] ; then
				arr1=$arr1," "
			else
				arr1=$arr1,$i
			fi
		done
		arr=$arr1
		gameover=`echo ${arr}|awk 'BEGIN {FS=",";}{for(i=1;i<=16;i++)array[all++]=$i;}END{for(i=0;i<=15;i++)if(array[i]==64){print "1"}}'`
                if [ -z $gameover ] ; then

		stty -icanon
		argument1=$(head -c1)
		moved=0
		case $argument1 in
			w) 
			    makeup
				;;
			s) 
			    makedown
				;;
			a) 
			    makeleft
				;;
			d) 
			    makeright
				;;
			q) main_page
				;;
		esac
	if [ $moved -eq 1 ]; then
		addrandom
	fi

		clear
		IFS=','
		printtable ${arr}

		else
			dialog --title "" --ok-label "You Win" --msgbox " 
  ____                            _         _       _   _                  \n
 / ___|___  _ __   __ _ _ __ __ _| |_ _   _| | __ _| |_(_) ___  _ __  ___  \n
| |   / _ \| '_ \ / _  | '__/ _  | __| | | | |/ _  | __| |/ _ \| '_ \/ __| \n
| |__| (_) | | | | (_| | | | (_| | |_| |_| | | (_| | |_| | (_) | | | \__ \ \n
 \____\___/|_| |_|\__, |_|  \__,_|\__|\__,_|_|\__,_|\__|_|\___/|_| |_|___/ \n
                  |___/ \n
" 10 80
			main_page
		fi
	done
}

new_game(){
#	IFS=','
	addrandom
	addrandom
	game ${arr}
}

resume(){
	game ${arr}
}

load_game(){
	dialog --title "" --msgbox "Game have been loaded." 10 60
is_chioce=`tail ${TMPFILE} | sed -e 1d`
if [ -z $is_chioce ] ; then
	arr=`tail -1 ${TMPFILE}`
else
	exec 3>&1
	load=$(dialog --clear --title "Load Game" --menu "Choce Load Game" 20 50 5 \
		"1" "The Last Game" \
		"2" "The Last-1 Game" \
		"3" "The Last-2 Game" \
		"4" "The Last-3 Game" \
		"5" "The Last-4 Game" 2>&1 1>&3)
	exec 3>&-
	case $load in
		1) arr=`tail -1 ${TMPFILE}` ;;
		2) 
		   arr=`tail -2 ${TMPFILE} | sed -e 2d` ;;
		3) 
		   check=`tail ${TMPFILE} | sed -e 1,2d`
			if [ -z $check ] ; then
			   warm_load
			else
			   arr=`tail -3 ${TMPFILE} | sed -e 2,3d` 
			fi;;
		4) 
		   check=`tail ${TMPFILE} | sed -e 1,3d`
                        if [ -z $check ] ; then
                           warm_load
                        else
			   arr=`tail -4 ${TMPFILE} | sed -e 2,4d` 
			fi;;
		5) 
		   check=`tail ${TMPFILE} | sed -e 1,4d`
                        if [ -z $check ] ; then
                           warm_load
                        else
			   arr=`tail -5 ${TMPFILE} | sed -e 2,5d` 
			fi;;
	esac
fi
	game ${arr}
}

warm_load(){
dialog --title "" --msgbox "You don't save the choice game." 10 60
main_page
}

save_game(){
	dialog --title "" --msgbox "Your game progress have been saved." 10 60
	echo ${arr} >> ${TMPFILE}
	main_page
}

quit_game(){
	clear
	echo "quit Game"
	exit 0
}

main_page(){
### display main menu ###
exec 3>&1
choice=$(dialog --clear --title "meau" --menu "Command Line 2048" 20 50 5 \
"N" "New Game - Start a new 2048 game" \
"R" "Resume - Resume previous game" \
"L" "Load - Load from previous saved game" \
"S" "Save - Save current game state" \
"Q" "Quit" 2>&1 1>&3)
exec 3>&-
case $choice in
        N)
		arr=" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "
                new_game
                ;;
        R)
                resume
                ;;
        L)
                load_game
                ;;
        S)
                save_game
                ;;
        Q)
                quit_game
                ;;
esac
}
main_page
