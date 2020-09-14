#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// Example: ./testFromPairs.nf --glob '../../../plessy_CAGEscan_Nextflow_testdata/1_S1_L001_R'

channel
  .fromFilePairs("${params.glob}{1,2}*")
  .map { row -> [ row[0], row[1][0], row[1][1] ] }
  .set { ch_input }

workflow {
  ch_input.view()
}
