#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir = "test_results"

process hello2 {
	input:
		tuple val(basename), path(R1)
	output:
		stdout
	script:
	"""
        echo "name: ${basename}"
        echo "file: ${R1}"
	"""
}

channel
  .fromPath("${params.glob}*", checkIfExists: true)
  .map { row -> [row.baseName, row] }
  .set { ch_input }

workflow {
  hello2(ch_input) | view
}

