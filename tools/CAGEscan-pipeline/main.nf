#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process CAGEscanFindMolecules {
    container = 'cagescan-pipeline:2020072701'
    publishDir "${params.outdir}/CAGEscan/find-molecules",
        mode: "copy", overwrite: true
    input:
        tuple val(sampleName),
              path(reads1),
              path(reads2)
    output:
        tuple val(sampleName),
              path(reads1),
              path(reads2),
              path("*.molecules.txt"),
              emit: CAGEscanMolecules
    script:
    command = """
        cagescan-find-molecules.sh -d 1 -g 0.5 -n 2 -p 20 ${reads1} > ${sampleName}.molecules.txt
        """

    if (params.verbose){
        println ("[MODULE] CAGEscan find-molecules command: " + command)
    }

    """
    ${command}
    """
}

process CAGEscanAssemble {
    container = 'cagescan-pipeline:2020072701'
    publishDir "${params.outdir}/CAGEscan/assemble",
        mode: "copy", overwrite: true
    input:
        tuple val(sampleName),
              path(reads1),
              path(reads2),
              path(molecules)
    output:
        tuple val(sampleName),
              path(reads1),
              path(reads2),
              path("*.assembled.fq"),
              emit: CAGEscanAssembled
    script:
    command = """
        cagescan-assemble.sh ${reads1} ${reads2} ${molecules} > ${sampleName}.assembled.fq
        """

    if (params.verbose){
        println ("[MODULE] CAGEscan assemble command: " + command)
    }

    """
    ${command}
    """
}

process CAGEscanMap {
    container = 'cagescan-pipeline:2020072701'
    publishDir "${params.outdir}/CAGEscan/map",
        mode: "copy", overwrite: true
    input:
        tuple val(sampleName),
              path(reads1),
              path(reads2),
              path(assembled)
        path(index)

    output:
        tuple val(sampleName),
              path(reads1),
              path(reads2),
              path("*.maf"),
              emit: CAGEscanMapped
    script:
    command = """
        cagescan-map.sh ${index}/index ${assembled} > ${sampleName}.maf
        """

    if (params.verbose){
        println ("[MODULE] CAGEscan map command: " + command)
    }

    """
    ${command}
    """
}
