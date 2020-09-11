#!/usr/bin/env nextflow

nextflow.enable.dsl=2

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

workflow justAssembleUnzipped {
  take: ch_fastq
  main:
    bbmap_minlen(ch_fastq) |
    gunzip |
    CAGEscanFindMolecules |
    CAGEscanAssemble
}

workflow alignAssembledMolecules {
  take: ch_fastq
  take: ch_index
  main:
    CAGEscanMap(ch_fastq, ch_index)
    CAGEscanCountHits(CAGEscanMap.out)
    CAGEscanBuildTranscripts(CAGEscanMap.out)
    CAGEscanConvertToBED12(CAGEscanBuildTranscripts.out)
}

workflow main_nf {
  take: ch_fastq
  take: ch_index
  main:
    bbmap_minlen(ch_fastq) |
    gunzip |
    CAGEscanFindMolecules |
    CAGEscanAssemble
    CAGEscanMap(CAGEscanAssemble.out, ch_index)
    CAGEscanCountHits(CAGEscanMap.out)
    CAGEscanBuildTranscripts(CAGEscanMap.out)
    CAGEscanConvertToBED12(CAGEscanBuildTranscripts.out)
}
