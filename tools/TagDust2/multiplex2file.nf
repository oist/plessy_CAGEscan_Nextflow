#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir = "nf_results"
params.verbose = false

include { multiplex2arch as main_wf } from './workflow.nf'

channel
  .value(params.indexSequence)
  .set {ch_indexSequence}

channel
  .value(file(params.multiplexFile, checkIfExists: true))
  .set {ch_multiplexFile}

workflow {
    main_wf(ch_multiplexFile, ch_indexSequence)
}
