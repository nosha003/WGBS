## Test data with metaplot over genes
#23Aug2017
#methyl_metaplot_PH207
#generate gene based metaplot data for mnase data
	
#!/bin/bash
#PBS -l walltime=12:00:00,nodes=1:ppn=6,mem=10gb
#PBS -o /scratch.global/nosha003/e_o/methyl_P_o
#PBS -e /scratch.global/nosha003/e_o/methyl_P_e
#PBS -N methyl
#PBS -V
#PBS -r n

cd /home/springer/nosha003/wgbs_schmitz/PH207

module load bedtools/2.17.0
bedtools closest -D a -t first -a /home/springer/nosha003/wgbs_schmitz/PH207/PH207_V2_100.CG.bed -b /home/maize/shared/databases/genomes/Zea_mays/PH207/ZmaysPH207_443_v1.1.gene_exons.gff3 > /scratch.global/nosha003/wgbs_schmitz/PH207/CG_gene.txt
grep -v 'scaffold' /scratch.global/nosha003/wgbs_schmitz/PH207/CG_gene.txt > /scratch.global/nosha003/wgbs_schmitz/PH207/CG_gene_noscaffold.txt
perl /home/springer/nosha003/W22/scripts/metaplot_data.pl -i /scratch.global/nosha003/wgbs_schmitz/PH207/CG_gene_noscaffold.txt -o /scratch.global/nosha003/wgbs_schmitz/PH207/CG_gene_metaplot.txt
bedtools closest -D a -t first -a /home/springer/nosha003/wgbs_schmitz/PH207/PH207_V2_100.CHG.bed -b /home/maize/shared/databases/genomes/Zea_mays/PH207/ZmaysPH207_443_v1.1.gene_exons.gff3 > /scratch.global/nosha003/wgbs_schmitz/PH207/CHG_gene.txt
grep -v 'scaffold' /scratch.global/nosha003/wgbs_schmitz/PH207/CHG_gene.txt > /scratch.global/nosha003/wgbs_schmitz/PH207/CHG_gene_noscaffold.txt
perl /home/springer/nosha003/W22/scripts/metaplot_data.pl -i /scratch.global/nosha003/wgbs_schmitz/PH207/CHG_gene_noscaffold.txt -o /scratch.global/nosha003/wgbs_schmitz/PH207/CHG_gene_metaplot.txt
bedtools closest -D a -t first -a /home/springer/nosha003/wgbs_schmitz/PH207/PH207_V2_100.CHH.bed -b /home/maize/shared/databases/genomes/Zea_mays/PH207/ZmaysPH207_443_v1.1.gene_exons.gff3 > /scratch.global/nosha003/wgbs_schmitz/PH207/CHH_gene.txt
grep -v 'scaffold' /scratch.global/nosha003/wgbs_schmitz/PH207/CHH_gene.txt > /scratch.global/nosha003/wgbs_schmitz/PH207/CHH_gene_noscaffold.txt
perl /home/springer/nosha003/W22/scripts/metaplot_data.pl -i /scratch.global/nosha003/wgbs_schmitz/PH207/CHH_gene_noscaffold.txt -o /scratch.global/nosha003/wgbs_schmitz/PH207/CHH_gene_metaplot.txt

# qsub /home/springer/nosha003/scripts/methyl_metaplot_PH207.sh
