#!/usr/bin/bash
#===============================================================================
#
#          FILE:  move.sh
#
#         USAGE:  move.sh <Source inputDir> <Dest. inputDir> <no. of files to move> <Date of Files>
#
#       Example:  sh move.sh inputDir_process inputDir 20 20090203
#
#===============================================================================
yyyymmdd=`date +%Y +%m +%d`;
hour=`date +%H`;
if [ $# -lt 4 ]; then
echo "invalid usage:sh  move.sh <Source inputDir> <Dest. inputDir> <no. of files to move> <Date of Files>
echo "e.g. sh move.sh inputDir_process inputDir 20 20090203
exit
else
cd /appserver/mcs/ltra-input/$1
if [ $? -eq 0 ]
 then
   cd /appserver/mcs/ltra-input/$2
    if [ $? -eq 0 ]
     then 
          cd /appserver/mcs/ltra-input/$1
          count=0
            for i in `ls`
              do
                 cd /appserver/mcs/ltra-input/$1/$i
                 mkdir -p /appserver/mcs/ltra-input/$2/$i/$yyyymmdd/$hour
                 count=0
                    for files in `find . -name "*$4*.rdy"`
                      do
                         mv $files /appserver/mcs/ltra-input/$2/$i/$yyyymmdd/$hour 
                         count=`expr $count + 1` 

                             if [ $count -gt $3 ]
                               then
                                break 
                             fi
                     done

                   cd ..
               done

     else
       echo "Please Check Directory name $2 is not Valid"
    fi
fi
fi
