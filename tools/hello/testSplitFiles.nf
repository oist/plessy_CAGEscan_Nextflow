#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir = "test_results"

process hello2 {
	input:
		path(fileToSplit)
	output:
		path("*")
	script:
	"""
	split -l 10 ${fileToSplit}
	"""
}

process listFilesFromInput {
	input:
		path(file)
	output:
		stdout
	script:
	"""
	ls -l ${file}
	"""
}

channel
  .fromPath(params.glob)
  .set { ch_input }

workflow {
  hello2(ch_input)
  listFilesFromInput(hello2.out.flatten()) | view
}

