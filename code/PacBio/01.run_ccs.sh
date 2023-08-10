#!/bin/bash

#Usage
if [ ! -n "$4" ]
then
	echo "	Part 1: generate ccs "
	echo "	We only set useful parameters, if you want to know the detail of all parameters."
	echo "	Please run below command in terminal [I suggest you do this]"
	echo "	/home/data/vip6t05/soft/smrtlink/smrtcmds/bin/ccs -h"
	echo "	Usage: bash `basename $0` [Subreas.bam] [OutputPrefix] [TopPasses|num|0-50] [minrq|0-1]"
	echo "	Example: bash `basename $0` Subreads.bam JJ27_Tes 3 0.9"
	echo "	Output: OutputPrefix.ccs.bam; report.summary"
else
	data=$1
	out=$2
	pass=$3
	rq=$4
	echo "`basename $0`"
	echo ">>Starting the pipeline to generate CCS using ccs "
	echo "	Input data: "$data
	st=`date`
	if [[ -e ${data}.pbi ]]
	then
		/home/data/vip6t05/soft/smrtlink/smrtcmds/bin/ccs $data ${out}.ccs.bam --top-passes $pass --min-rq $rq --num-threads 2 --report-file ${out}.ccs_report.txt
	else
		echo "Index lost:"$data
		echo "Generating index"
		/home/data/vip6t05/soft/smrtlink/smrtcmds/bin/pbindex $data && \
			echo "Index generated" && \
			/home/data/vip6t05/soft/smrtlink/smrtcmds/bin/ccs $data ${out}.ccs.bam --top-passes $pass --min-rq $rq --num-threads 2 --report-file ${out}.ccs_report.txt
	fi
	ed=`date`
	if [[ -s ${out}.ccs_report.txt ]]
	then
		echo "  **Summary:"
		cat ${out}.ccs_report.txt|head -3
		echo "Start time: "$st
		echo "End time: "$ed
		echo "Done running `basename $0`"
		echo "**********************************************************************************"
	else
		echo "Wrong!!! Please check input data"
	fi
fi

