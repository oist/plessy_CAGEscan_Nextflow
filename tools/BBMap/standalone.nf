#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir = "nf_results"
params.verbose = false

include { main_wf } from './workflow.nf'

testData = [ [ params.samplename
             , file(params.R1, checkIfExists: true)
             , file(params.R2, checkIfExists: true)
             ] ]

channel
  .from(testData)
  .set {ch_fastq}

workflow {
  main_wf(ch_fastq)
}
