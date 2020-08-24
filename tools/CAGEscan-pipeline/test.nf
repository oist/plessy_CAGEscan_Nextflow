#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir = "test_results"
params.verbose = true

include { CAGEscanFindMolecules
        ; CAGEscanAssemble
        ; CAGEscanMap
        ; CAGEscanCountHits
        ; CAGEscanBuildTranscripts
        ; CAGEscanConvertToBED12
        } from './main.nf'

include { bbmap_minlen } from '../BBMap/main.nf'

process gunzip {
    publishDir "${params.outdir}/unzip", mode: "copy", overwrite: true
    input:  tuple val(sName), path(fastqgz1), path(fastqgz2)
    output: tuple val(sName), path("*R1.fastq"), path("*R2.fastq"), emit: gunzipped
    script:
    """
    zcat ${fastqgz1} > ${sName}.gunzipped.R1.fastq
    zcat ${fastqgz2} > ${sName}.gunzipped.R2.fastq
    """
}


log.info ("Starting tests for CAGEscan pipeline...")

testData = [ [ 'Sample1', "../test/Sample1_BC_ACATGA_READ1.fq", "../test/Sample1_BC_ACATGA_READ2.fq" ] ,
             [ 'Sample2', "../test/Sample2_BC_ATCATA_READ1.fq", "../test/Sample2_BC_ATCATA_READ2.fq" ] ]

channel
  .fromList(testData)
  .map { row -> [ row[0], file(row[1], checkIfExists: true), file(row[2], checkIfExists: true) ] }
  .set {ch_fastq}

channel
  .value(file("../test/last"))
  .set {ch_index}

workflow {
    bbmap_minlen(ch_fastq) |
    gunzip |
    CAGEscanFindMolecules |
    CAGEscanAssemble
    CAGEscanMap(CAGEscanAssemble.out, ch_index)
    CAGEscanCountHits(CAGEscanMap.out)
    CAGEscanBuildTranscripts(CAGEscanMap.out)
    CAGEscanConvertToBED12(CAGEscanBuildTranscripts.out)
}
