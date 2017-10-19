#!/bin/bash

#----------------------------------------------
# V1.0 -- Sep 7,2010
# Hughes: this script is used to check who has 
#         compiling errors and warning.
#----------------------------------------------

VER=V1.0

if [ $# -ne 1 ]; then
    echo "Usage: $0 [LogFileName]"
    echo "Please contact Hughes if you have trouble using it."
    exit 1
else
    LOG_FILE=$1
fi

if [ ! -f ${LOG_FILE} ]; then
    echo "File ${LOG_FILE} does not exist!"
    exit 2
fi

ERROR_DETECT=0

ERR_KEY_STR='error:'
WARN_KEY_STR='warning:'

WARNING_FILE=warning.log
ERROR_FILE=error.log

>${WARNING_FILE}
>${ERROR_FILE}

echo "Parsing log files..."

cat ${LOG_FILE} | grep "${ERR_KEY_STR}"  > ${ERROR_FILE}
cat ${LOG_FILE} | grep "${WARN_KEY_STR}"  > ${WARNING_FILE}

echo "Parsing done!"

echo "Checking errors and warnings..."

RESULT_FILE=log_err_warning.txt

>${RESULT_FILE}


echo "******************************************************" >> ${RESULT_FILE}
echo "* R51 Compiling Error&Warnning checking utility ${VER} *" >> ${RESULT_FILE}
echo "******************************************************" >> ${RESULT_FILE}
echo "" >>$RESULT_FILE


# get error owner....

echo "=============================" >> ${RESULT_FILE}
echo "~~~~~~~~ Error stats ~~~~~~~~" >> ${RESULT_FILE}
echo "=============================" >> ${RESULT_FILE}

ERR_NUM=1
while read MY_LINE
do
     FILE_NAME=`echo ${MY_LINE} | awk -F'[:]' '{print $1}'`
     LINE_NUM=`echo ${MY_LINE} | awk -F'[:]' '{print $2}'`
     ERR_IDENT=`echo ${MY_LINE} | awk -F'[:]' '{print $3}'`
     ERR_DESC=`echo ${MY_LINE} | awk -F'[:]' '{print $4}'`

     if [ "${ERR_IDENT}" == " error" ]; then

       if [ ! -f ${FILE_NAME} ]; then
         echo "File ${FILE_NAME} does not exist! Please check your working path."
         ERROR_DETECT=1
         break
       fi

       OWNER=`svn blame ${FILE_NAME} | awk NR==${LINE_NUM} | awk '{print $2}'`

       # print out to screen 
       echo "--Err#${ERR_NUM}: ${FILE_NAME}, line ${LINE_NUM}: ${ERR_DESC}"
       OWNER=`echo $OWNER | tr a-z A-Z`
       echo "@@ murderer is <<<${OWNER}>>>"
       
       # store to file
       echo "--Err#${ERR_NUM}:" >> ${RESULT_FILE}
       ERR_NUM=$((ERR_NUM+1))

       echo "onwer:<<<${OWNER}>>>, file=${FILE_NAME}, line=${LINE_NUM}, error:${ERR_DESC}"  >> $RESULT_FILE
       echo "" >>$RESULT_FILE
     fi
done < ${ERROR_FILE}


# get warnning owner....

echo "" >> ${RESULT_FILE}
echo "=============================" >> ${RESULT_FILE}
echo "~~~~~~~ Warning stats ~~~~~~~" >> ${RESULT_FILE}
echo "=============================" >> ${RESULT_FILE}

WARN_NUM=1
while read MY_LINE
do
     FILE_NAME=`echo ${MY_LINE} | awk -F'[:]' '{print $1}'`
     LINE_NUM=`echo ${MY_LINE} | awk -F'[:]' '{print $2}'`
     WARN_IDENT=`echo ${MY_LINE} | awk -F'[:]' '{print $3}'`
     WARN_DESC=`echo ${MY_LINE} | awk -F'[:]' '{print $4}'`

     if [ "$WARN_IDENT" == " warning" ]; then

       if [ ! -f ${FILE_NAME} ]; then
         echo "File ${FILE_NAME} does not exist! Please check your working path."
         ERROR_DETECT=1
         break
       fi

       OWNER=`svn blame ${FILE_NAME} | awk NR==${LINE_NUM} | awk '{print $2}'`
       
       # print out to screen 
       echo "--Warning#${WARN_NUM}: ${FILE_NAME}, line ${LINE_NUM}: ${WARN_DESC}"
       OWNER=`echo $OWNER | tr a-z A-Z`
       echo "@@ murderer is <<<${OWNER}>>>"

       # store to file
       echo "--Warning#${WARN_NUM}:" >> ${RESULT_FILE}
       WARN_NUM=$((WARN_NUM+1))

       echo "onwer:<<<${OWNER}>>>, file=${FILE_NAME}, line=${LINE_NUM}, warning:${WARN_DESC}"  >> ${RESULT_FILE}
       echo "" >>${RESULT_FILE}
     fi
done < ${WARNING_FILE}

rm -r ${WARNING_FILE}
rm -r ${ERROR_FILE}

if [ ${ERROR_DETECT} -eq 0 ]; then
  echo "Checking done!"
  unix2dos ${RESULT_FILE} 2>/dev/null
  echo "Finished! Please check the output file ${RESULT_FILE}"
fi
