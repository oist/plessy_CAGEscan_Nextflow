NextFlow pipeline for CAGEscan
==============================

Inspired from <https://github.com/luslab/luslab-nf-modules> and from our old
MOIRAI pipelines, such as OP-WORKFLOW-CAGEscan-short-reads-v2.0.

Input:
------

 - The compressed FASTQ files produced by the sequencer, demultiplexed by index.

FIXME: the globbing is tricky: for instance `test/*_L001_R` would work and `test/*_L001_R` would fail.

 - A text table that we call "multiplex file", indicating which barcode
   and index were used for each libraries.
 - A genome indexed for the LAST aligner.  The `--index` option must point to a
   *directory* containing a LAST index called `index`. 
 - A reference rRNA file in FASTA format.
 - A file with primer sequences in FASTA formats to remove primer artefacts.


Example "multiplex file":

```
samplename	group	barcode	index
exp1_rep1	exp1	ACAGAT	1_S1_L001_
exp1_rep2	exp1	ATCGTG	1_S1_L001_
exp1_rep3	exp1	CACGAT	1_S1_L001_
exp2_rep1	exp2	CACTGA	1_S1_L001_
exp2_rep2	exp2	CTGACG	1_S1_L001_
exp2_rep3	exp2	GAGTGA	1_S1_L001_
exp3_rep1	exp3	GTATAC	1_S1_L001_
exp3_rep2	exp3	TCGAGC	1_S1_L001_
exp3_rep3	exp3	ACATGA	1_S1_L001_
```

Note that the header line is necessary.

CAGEscan first reads of a pair start with `BBBBBBUUUUUUUUTATAGGG`, where
`BBBBBB` is the _barcode sequences_ that is given by the `barcode` column of
the _multiplex file_.

The `index` column originally contained the sequence of the Illumina index.
Here, it must be a string that will uniquely identify one pair of FASTQ files
produced by the sequencer.
