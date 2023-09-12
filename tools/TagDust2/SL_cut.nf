#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir = "nf_results/SL"
params.verbose = false

if (!params.input) { exit 1, 'Input samplesheet not specified!' }
if (!params.arch)  { exit 1, 'Architecture file not specified!' }

include { TagDust2_cutAdapt } from './main.nf'

channel
  .fromPath(params.input)
  .splitCsv(sep: "\t", header: true)
  .map { row -> [ row.name, file(row.R1, checkIfExists: true), file(row.R2, checkIfExists: true) ] }
  .set {input}

channel
  .value(file(params.arch, checkIfExists: true))
  .set {arch}

workflow {
  TagDust2_cutAdapt(input, arch)
}
