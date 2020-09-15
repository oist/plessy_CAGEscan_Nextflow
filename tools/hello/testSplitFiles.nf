#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir = "test_results"

process hello2 {
	input:
		path(fileToSplit)
	output:
		path "*{a,c}", emit: out1
		path "*{b,d}", emit: out2
	script:
	"""
	split -l 10 ${fileToSplit}
	"""
}

process listFilesFromInput {
	input:
		path(file1)
		path(file2)
	output:
		stdout
	script:
	"""
	echo "Next pair..."
	ls -l ${file1}
	ls -l ${file2}
	"""
}

channel
  .fromPath(params.glob)
  .set { ch_input }

workflow {
  hello2(ch_input) 
  listFilesFromInput(hello2.out.out1.flatten(), hello2.out.out2.flatten()) | view
}

