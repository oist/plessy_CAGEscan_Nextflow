#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir = "nf_results"
params.verbose = false

include { removeRiboRNA_SE as main_wf } from './workflow.nf'

channel
  .fromPath("${params.glob}*")
  .set { ch_fastq }

channel
  .value(file(params.rRNAref, checkIfExists: true))
  .set {ch_refFile}

workflow {
    main_wf(ch_fastq, ch_refFile)
}
