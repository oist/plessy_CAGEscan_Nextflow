NextFlow pipeline for CAGEscan
==============================

Inspired from <https://github.com/luslab/luslab-nf-modules> and from our old
MOIRAI pipelines, such as OP-WORKFLOW-CAGEscan-short-reads-v2.0.

Input:
------

 - The compressed FASTQ files produced by the sequencer, demultiplexed by index.
 - A text table that we call "multiplex file", indicating which barcode
   and index were used for each libraries.
 - A genome indexed for the LAST aligner.
 - A reference rRNA file in FASTA format.
   (It may also contain reference primer artefacts).

Example "multiplex file":

```
samplename	group	barcode	index
exp1_rep1	exp1	ACAGAT	NNNNNNNN
exp1_rep2	exp1	ATCGTG	NNNNNNNN
exp1_rep3	exp1	CACGAT	NNNNNNNN
exp2_rep1	exp2	CACTGA	NNNNNNNN
exp2_rep2	exp2	CTGACG	NNNNNNNN
exp2_rep3	exp2	GAGTGA	NNNNNNNN
exp3_rep1	exp3	GTATAC	NNNNNNNN
exp3_rep2	exp3	TCGAGC	NNNNNNNN
exp3_rep3	exp3	ACATGA	NNNNNNNN
```

Note that the header line is necessary.
