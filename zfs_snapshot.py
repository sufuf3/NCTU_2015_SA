import sys
import os
import datetime
from datetime import datetime
import subprocess, re

CURRENT = datetime.strftime(datetime.now(), '%Y%m%d_%H%M')

sasnapshot = subprocess.check_output('zfs snapshot mypool/ftp@sademo_'+CURRENT , shell=True, stderr=subprocess.STDOUT)

listcheck = subprocess.check_output('zfs list -t snapshot' , shell=True, stderr=subprocess.STDOUT)

if len(listcheck.split('\n')) > 9:
    deletesnap =  listcheck.split('\n')[1].split(' ')[0]
    byebye = subprocess.check_output('zfs destroy '+deletesnap , shell=True, stderr=subprocess.STDOUT)
    print deletesnap + ' at ' + CURRENT + 'is gone.'
