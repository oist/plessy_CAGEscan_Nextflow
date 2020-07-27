#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir = "test_results"

include {TagDust2} from './main.nf'

log.info ("Starting tests for TagDust2...")

testData = [ [ 'Sample1', "../test/test_R1.fastq.gz", "../test/test_R2.fastq.gz" ] ]

params.verbose = true

channel
  .from(testData)
  .map { row -> [ row[0], file(row[1], checkIfExists: true), file(row[2], checkIfExists: true) ] }
  .set {ch_fastq}

channel
  .value(file("../test/tagdust.arch"))
  .set {ch_arch}

channel
  .value(file("../test/tagdust.fa"))
  .set {ch_ref}

workflow {
    TagDust2(ch_fastq, ch_arch, ch_ref)
}
