#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

include {bbmap_clumpify} from './main.nf'

log.info ("Starting tests for BBMap clumpify...")

testData = [ [ 'Sample1', "../test/test_R1.fastq.gz", "../test/test_R2.fastq.gz" ] ]


Channel
  .from(testData)
  .map { row -> [ row[0], file(row[1], checkIfExists: true), file(row[2], checkIfExists: true) ] }
  .set {ch_fastq}

workflow {
params.verbose = true
    bbmap_clumpify(ch_fastq)
}
