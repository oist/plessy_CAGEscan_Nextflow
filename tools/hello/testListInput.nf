#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir = "test_results"

process hello2 {
	input:
		path file1
	output:
		tuple val("blah"), path(file1, includeInputs:true)
//		path "*"
	script:
	"""
	echo ${file1}
	pwd
	ls -lahrt ${file1}
	"""
}

channel
  .from ([file(params.files)])
  .set { ch_input }

workflow {
  hello2(ch_input) | view
}

