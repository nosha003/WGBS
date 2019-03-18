#28June2017
#all_bins.sh
#make counts for complete list of 100bp tiles (including those without data)
###
	
#!/bin/bash
#PBS -l walltime=08:00:00,nodes=1:ppn=1,mem=5gb
#PBS -o /scratch.global/nosha003/e_o/bins_o
#PBS -e /scratch.global/nosha003/e_o/bins_e
#PBS -N bins
#PBS -V
#PBS -r n

SAMPLE="$(/bin/sed -n ${PBS_ARRAYID}p ${LIST} | cut -f 1)"
NAME="$(/bin/sed -n ${PBS_ARRAYID}p ${LIST} | cut -f 3)"

# make complete 100bp bin files including no data bins
# chr, start, stop, sites, C, CT, ratio
perl /home/springer/nosha003/seqcap/scripts/bincounts3.pl -i /home/springer/nosha003/database/B73v4/B73v4_100bp_bins.gff -I /scratch.global/nosha003/wgbs_schmitz/analysis/tiles/${SAMPLE}_BSMAP_out.txt.100.CG.bed -o /scratch.global/nosha003/wgbs_schmitz/analysis/tiles/${NAME}_BSMAP_100bp.CG.bed
perl /home/springer/nosha003/seqcap/scripts/bincounts3.pl -i /home/springer/nosha003/database/B73v4/B73v4_100bp_bins.gff -I /scratch.global/nosha003/wgbs_schmitz/analysis/tiles/${SAMPLE}_BSMAP_out.txt.100.CHG.bed -o /scratch.global/nosha003/wgbs_schmitz/analysis/tiles/${NAME}_BSMAP_100bp.CHG.bed
perl /home/springer/nosha003/seqcap/scripts/bincounts3.pl -i /home/springer/nosha003/database/B73v4/B73v4_100bp_bins.gff -I /scratch.global/nosha003/wgbs_schmitz/analysis/tiles/${SAMPLE}_BSMAP_out.txt.100.CHH.bed -o /scratch.global/nosha003/wgbs_schmitz/analysis/tiles/${NAME}_BSMAP_100bp.CHH.bed

#qsub -t 1-6 -v LIST=/home/springer/nosha003/wgbs_schmitz/wgbs_schmitz_names.txt /home/springer/nosha003/wgbs_schmitz/scripts/all_bins.sh
