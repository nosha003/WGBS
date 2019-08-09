#!/bin/bash -l
#PBS -l walltime=48:00:00,nodes=1:ppn=8,mem=20gb
#PBS -N trim_galore
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

module load fastqc/0.11.5
module load cutadapt/1.8.1

########## Set up dirs #################

#get job ID
#use sed, -n supression pattern space, then 'p' to print item number {PBS_ARRAYID} eg 2 from {list}
ID="$(/bin/sed -n ${PBS_ARRAYID}p ${LIST} | cut -f 1)"
ID2="$(/bin/sed -n ${PBS_ARRAYID}p ${LIST} | cut -f 2)"
NAME="$(/bin/sed -n ${PBS_ARRAYID}p ${LIST} | cut -f 3)"
DIR="$(/bin/sed -n ${PBS_ARRAYID}p ${LIST} | cut -f 4)"

#make trimmed folder
trimmedfolder=analysis/trimmed
mkdir -p $trimmedfolder

fastqcfolder=analysis/fastqc
mkdir -p $fastqcfolder

#uncompress reads because trim_galore throws the error `gzip: stdout: Broken pipe` if I input .gz files
#gunzip /scratch.global/nosha003/reads/${ID}.fastq.gz
#gunzip /scratch.global/nosha003/reads/${ID2}.fastq.gz

########## Run #################
/home/springer/nosha003/software/TrimGalore-0.4.3/trim_galore \
--phred33 \
--fastqc \
--fastqc_args "--noextract --outdir $fastqcfolder" \
-o $trimmedfolder --paired /home/springer/data_release/umgc/hiseq/${DIR}/Springer_Project_053/${ID}.fastq /home/springer/data_release/umgc/hiseq/${DIR}/Springer_Project_053/${ID2}.fastq

#/home/springer/nosha003/software/TrimGalore-0.4.3/trim_galore \
#--phred33 \
#--fastqc \
#--fastqc_args "--noextract --outdir $fastqcfolder" \
#-o $trimmedfolder --paired /home/springer/data_release/umgc/hiseq/170602_D00635_0242_ACB1FBANXX/Springer_Project_053/${ID}.fastq /home/springer/data_release/umgc/hiseq/170602_D00635_0242_ACB1FBANXX/Springer_Project_053/${ID2}.fastq

#/home/springer/nosha003/software/TrimGalore-0.4.3/trim_galore \
#--phred33 \
#--fastqc \
#--fastqc_args "--noextract --outdir $fastqcfolder" \
#-o $trimmedfolder --paired /scratch.global/nosha003/wgbs/w22/${ID}.fastq /scratch.global/nosha003/wgbs/w22/${ID2}.fastq

#compress original reads again
#gzip /scratch.global/nosha003/wgbs/reads/${ID}.fastq
#gzip /scratch.global/nosha003/wgbs/reads/${ID2}.fastq

echo Done trimming
