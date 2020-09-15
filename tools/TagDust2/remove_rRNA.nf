#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir = "nf_results"
params.verbose = false

include { removeRiboRNA as main_wf } from './workflow.nf'

channel
  .fromFilePairs("${params.glob}{1,2}*")
  .map { row -> [ row[0], row[1][0], row[1][1] ] }
  .set { ch_fastqPair }

channel
  .value(file(params.rRNAref, checkIfExists: true))
  .set {ch_refFile}

workflow {
    main_wf(ch_fastqPair, ch_refFile)
}
