#!/usr/bin/bash

source /etc/profile
rm -rf *


curl --data "package=${PACKAGE//+/%2b}&repo=${REPO}&jenkins_id=$BUILD_NUMBER&status=2" http://162.243.149.218:52573/results/submit/

wget http://162.243.149.218:52573/results/$REPO/${PACKAGE//+/%2b}/download/ -O ${PACKAGE}.zip
unzip ${PACKAGE}.zip || exit 2

START=`date +"%s" --utc`

cd $PACKAGE || exit 2
sudo /usr/bin/makechrootpkg -c -u -r /var/lib/archbuild/chroots/ -l $EXECUTOR_NUMBER -- --nocolor

STATUS=$?

END=`date +"%s" --utc`

TIME=`expr $END - $START`



curl --data "package=${PACKAGE//+/%2b}&repo=${REPO}&jenkins_id=$BUILD_NUMBER&status=$STATUS&time=$TIME" http://162.243.149.218:52573/results/submit/

exit $STATUS
