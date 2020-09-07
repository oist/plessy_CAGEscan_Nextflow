#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir = "nf_results"
params.verbose = false

include { main_wf } from './workflow.nf'

Data = [ [ params.samplename
         , file(params.R1, checkIfExists: true)
         , file(params.R2, checkIfExists: true)
         ] ]

channel
  .from(Data)
  .set {ch_fastq}

channel
  .value(file(params.arch))
  .set {ch_arch}

channel
  .value(file(params.ref))
  .set {ch_ref}

workflow {
    main_wf(ch_fastq, ch_arch, ch_ref)
}
