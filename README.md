# NCTU_2015_SA
2015 NCTU System Administration Practice homework

--------------------------------------------------------------
HW2<br>
ZFS Automatic snapshot script<br>
Write a script such that whenever the script is invoked, it will take a snapshot for the dataset; in addition, it will only preserve the most recent 7 snapshots took by this scrip.<br>
<br>
crontab -l<br>
00 00 * * 1 python /usr/home/sjfu/snapshot.py >> /var/log/sa_zfs.log<br>
<br>
file: zfs_snapshot.py<br>
execute: python zfs_snapshot.py

--------------------------------------------------------------
HW3-3 <br>
CLI GAME:2048 (https://gabrielecirulli.github.io/2048/)<br>
Make in Bourne Shell<br>

＊New Game<br>
New board with 2 random pieces. <br>
Move pieces and merge with "WASD" pressed.<br>
After each move, a new piece(2, 4) randomly shows up.<br>
"q" pressed, go back to main menu.<br>
＊Resume<br>
Can load previous saved game, and continue to play.<br>
＊Win Message<br>
When 64 to win<br>
＊Save & Load Game<br>
When you save game, you can load the previous game. And save and load last 5 Game.<br>
<br>
file: 2048.sh<br>
execute: ./2048.sh

--------------------------------------------------------------
