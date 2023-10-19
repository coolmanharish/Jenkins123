    ##  --------------------Moving Files MCS Work TO inputDir_process Folder------------##
        
###====START===## 
        ##----Create List of files from work and delete them from Envelop table----##

mkdir -p /home/mcsuser/scripts/dds/circle
DBUSER=mcsuser
y=`cat /appserver/mcs/scripts/paswd.txt`
DBPASS=`/appserver/mcs/scripts/decrypt.pl $y`
HOST_NAME=`hostname`
db2 connect to PRODLTRA user $DBUSER using $DBPASS
db2 "select distinct(root_name) from mcsuser.DIM_MCS_ENVELOP_2" with ur |grep -v ROOT_NAME|grep -v record |grep -v "-" > bb.txt
for i in `cat bb.txt`
do  
cd /home/mcsuser/scripts/dds/circle
db2 "Select name from mcsuser.DIM_MCS_ENVELOP_2 where status=2 and root_name='$i' " with ur |grep -v NAME > $i.txt
done
rm bb.txt 
db2 "delete from mcsuser.DIM_MCS_ENVELOP_2 where status=2" with ur
db2 terminate

yyyymmdd=`date +%Y +%m +%d`;
hour=`date +%H`;


                      ## ----Moving Files from inputDir to inputDir_process------##

echo Moving Files from Work to inputDir_process 
cd /appserver/mcs/ltra-input/inputDir
for j in `ls`
do
cd /home/mcsuser/scripts/dds/circle 
for i in `cat $j.txt`
do
  cd /appserver/mcs/ltra-input/inputDir/$j
  mkdir -p /appserver/mcs/ltra-input/inputDir_process/$j/$yyyymmdd/$hour
  find . -type f -name "$i*" -exec mv {} /appserver/mcs/ltra-input/inputDir_process/$j/$yyyymmdd/$hour \;
done
cd /appserver/mcs/ltra-input/inputDir/
done

cd /home/mcsuser/scripts/dds/circle

for o in `cat ericssonin.txt`
do
cd /appserver/mcs/ltra-input/inputDir/ERICSSION_IN_MOBILITY
 mkdir -p /appserver/mcs/ltra-input/inputDir_process/ERICSSION_IN_MOBILITY/$yyyymmdd/$hour
 find . -type f -name "$o*" -exec mv {} /appserver/mcs/ltra-input/inputDir_process/ERICSSION_IN_MOBILITY/ \;
done

cd /appserver/mcs/ltra-input/inputDir_process
find . -name "*.rdy_2" -print | sed "s/\(.*\)\.rdy_2/ & \1.rdy/" | \xargs -L1 mv

    

                   ## -----Deleteing Files From OutputDir-----##


cd /appserver/mcs/ltra-output/outputDir 
for j in `ls`
do
cd /home/mcsuser/scripts/dds/circle
for i in `cat $j.txt`
do
 cd /appserver/mcs/ltra-output/outputDir/$j
 find . -type f -name "$i*" -exec rm {} \;
done
cd /appserver/mcs/ltra-output/outputDir 
done

echo "Script Completed...."

###=====END===##
