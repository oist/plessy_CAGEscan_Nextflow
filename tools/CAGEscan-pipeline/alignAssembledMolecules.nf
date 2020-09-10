#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir = "nf_results"
params.verbose = true

include { alignAssembledMolecules } from './workflow.nf'

channel
  .fromPath("${params.glob}*")
  .map { row -> [ getBaseName(row[0]), row[0] ] }  
  .set { ch_fastq }

channel
  .value(params.index)
  .set {ch_index}

workflow {
  alignAssembledMolecules(ch_fastq, ch_index)
}
