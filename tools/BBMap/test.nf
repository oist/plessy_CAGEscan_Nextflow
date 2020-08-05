#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir = "test_results"
params.verbose = true

include { bbmap_clumpify
        ; bbmap_minlen
        ; bbmap_version  } from './main.nf'

testData = [
    [ 'Sample1', "../test/test_R1.fastq.gz",               "../test/test_R2.fastq.gz" ] ,
    [ 'Sample2', "../test/Embryo_S2_L001_R1_001.fastq.gz", "../test/Embryo_S2_L001_R2_001.fastq.gz" ]
]

Channel
  .from(testData)
  .map { row -> [ row[0], file(row[1], checkIfExists: true), file(row[2], checkIfExists: true) ] }
  .set {ch_fastq}

workflow {
    bbmap_version | view
    bbmap_clumpify(ch_fastq) |
    bbmap_minlen
}
