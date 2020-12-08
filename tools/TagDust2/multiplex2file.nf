#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// Example: ./multiplex2file.nf --glob ../../../plessy_CAGEscan_Nextflow_testdata/*_L001_R --multiplexFile ../../../plessy_CAGEscan_Nextflow_testdata/NC_SAKAI1.multiplex.txt
// Example: ./multiplex2file.nf --reads ../../../plessy_CAGEscan_Nextflow_testdata/*_L001_R --multiplex ../../../plessy_CAGEscan_Nextflow_testdata/NC_SAKAI1.multiplex.txt

params.outdir = "nf_results"
params.verbose = false

include { multiplex2arch as main_wf } from './workflow.nf'

channel
  .fromFilePairs("${params.reads}{1,2}*")
  .map { row -> [ row[0], row[1][0], row[1][1] ] }
  .set { ch_fastqPair }

channel
  .value(file(params.multiplex, checkIfExists: true))
  .set {ch_multiplexFile}

workflow {
    main_wf(ch_fastqPair, ch_multiplexFile)
}
