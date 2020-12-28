#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir = "nf_results"
params.verbose = false

if (!params.input) { exit 1, 'Input samplesheet not specified!' }

include { bbmap_minlen } from './main.nf'

channel
  .fromPath(params.input)
  .splitCsv(sep: "\t", header: true)
  .map { row -> [ row.name, file(row.R1, checkIfExists: true), file(row.R2, checkIfExists: true) ] }
  .set {input}

// expects tuple val(sampleName), path(reads1), path(reads2)
workflow {
  bbmap_minlen(input)
}
