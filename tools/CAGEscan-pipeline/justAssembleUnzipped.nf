#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir = "nf_results"
params.verbose = true

include { justAssembleUnzipped } from './workflow.nf'

channel
  .fromFilePairs("${params.glob}*{1,2}*")
  .map { row -> [ row[0], row[1][0], row[1][1] ] }
  .set { ch_fastqPair }

workflow {
  justAssembleUnzipped(ch_fastqPair)
}
