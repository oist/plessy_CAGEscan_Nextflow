#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir = "test_results"

process hello2 {
	input:
		tuple val(basename), path(R1), path(R2)
	output:
		tuple val("blah"), path("*", includeInputs:true)
	script:
	"""
	"""
}

channel
  .fromFilePairs("${params.glob}*{1,2}*")
  .map { row -> [ row[0], row[1][0], row[1][1] ] }
  .set { ch_input }

workflow {
  hello2(ch_input) | view
}

