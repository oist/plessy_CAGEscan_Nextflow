#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir = "results"

process hello1 {
	input: val(input1)
	script:
	"""
	echo $input1
	ls $input1
	"""
}

process hello2 {
	input: tuple val(input1), file(input2)
	script:
	"""
	echo $input1
	pwd
	ls -lahrt $input2
	"""
}

process hello3 {
	input: tuple val(input1), val(input2), val(input3)
	script:
	"""
	echo $input1
	ls $input2
	ls $input3
	"""
}

process listOfFiles {
	input: path(files)
	output: path("*", includeInputs = true)
	script:
	"""
	echo hello
	"""
}
