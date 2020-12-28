#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir = "nf_results"
params.verbose = false

if (!params.input) { exit 1, 'Input samplesheet not specified!' }
if (!params.rRNAref)  { exit 1, 'rRNA sequence file not specified!' }
if (!params.outsubdir) { params.outsubdir = "tagdust2" }

include { removeRiboRNA as main_wf } from './workflow.nf'

channel
  .fromPath(params.input)
  .splitCsv(sep: "\t", header: true)
  .map { row -> [ row.name, file(row.R1, checkIfExists: true), file(row.R2, checkIfExists: true) ] }
  .set {ch_fastqPair}

channel
  .value(file(params.rRNAref, checkIfExists: true))
  .set {ch_refFile}

workflow {
    main_wf(ch_fastqPair, ch_refFile)
}
