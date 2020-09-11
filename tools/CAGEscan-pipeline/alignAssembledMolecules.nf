#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir = "nf_results"
params.verbose = true

include { alignAssembledMolecules } from './workflow.nf'

channel
  .fromPath("${params.glob}*")
  .map { row -> [ row.baseName, row ] }
  .set { ch_fastq }

channel
  .value(params.indexdir)
  .set {ch_index}

workflow {
  alignAssembledMolecules(ch_fastq, ch_index)
}
