#!/bin/bash -l
#PBS -l walltime=96:00:00,nodes=1:ppn=6,mem=48gb
#PBS -N fix-sort
#PBS -r n
#PBS -m abe

########## QC #################
set -xeuo pipefail

echo ------------------------------------------------------
echo -n 'Job is running on node '; cat $PBS_NODEFILE
echo ------------------------------------------------------
echo PBS: qsub is running on $PBS_O_HOST
echo PBS: originating queue is $PBS_O_QUEUE
echo PBS: executing queue is $PBS_QUEUE
echo PBS: working directory is $PBS_O_WORKDIR
echo PBS: execution mode is $PBS_ENVIRONMENT
echo PBS: job identifier is $PBS_JOBID
echo PBS: job name is $PBS_JOBNAME
echo PBS: node file is $PBS_NODEFILE
echo PBS: current home directory is $PBS_O_HOME
echo PBS: PATH = $PBS_O_PATH
echo PBS: array_ID is ${PBS_ARRAYID}
echo ------------------------------------------------------

echo working dir is $PWD

#cd into work dir
echo changing to PBS_O_WORKDIR
cd "$PBS_O_WORKDIR"
echo working dir is now $PWD

########## Modules #################

#bsmap requires samtools < 1.0.0
#module load samtools/0.1.18
#module load /home/springer/nosha003/software/bsmap-2.74/samtools

########## Set up dirs #################

#get job ID
#use sed, -n supression pattern space, then 'p' to print item number {PBS_ARRAYID} eg 2 from {list}
NAME="$(/bin/sed -n ${PBS_ARRAYID}p ${LIST} | cut -f 1)"

echo sample being mapped is $ID

cd analysis/bsmapped

########## Run #################

# make bam
/home/springer/nosha003/software/bsmap-2.74/samtools/samtools view -bS ${NAME}.sam > ${NAME}.bam

# sort by read name (needed for fixsam)
/home/springer/nosha003/software/bsmap-2.74/samtools/samtools sort -n ${NAME}.bam ${NAME}_nameSrt

# fix mate pairs
/home/springer/nosha003/software/bsmap-2.74/samtools/samtools fixmate ${NAME}_nameSrt.bam ${NAME}_nameSrt_fixed.bam

# co-ordinate sort
/home/springer/nosha003/software/bsmap-2.74/samtools/samtools sort ${NAME}_nameSrt_fixed.bam ${NAME}_sorted

# index
/home/springer/nosha003/software/bsmap-2.74/samtools/samtools index ${NAME}_sorted.bam

# remove intermediate files
rm ${NAME}.sam ${NAME}_nameSrt.bam ${NAME}_nameSrt_fixed.bam ${NAME}.bam
