#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// Example: ./testFromPairs.nf --glob '../../../plessy_CAGEscan_Nextflow_testdata/*_L001_R' --verbose

params.verbose = false

if (params.verbose) {
  printf("Glob is: ${params.glob}{1,2}*\n")
}

channel
  .fromFilePairs("${params.glob}{1,2}*")
  .map { row -> [ row[0], row[1][0], row[1][1] ] }
  .set { ch_input }

workflow {
  ch_input.view()
}
