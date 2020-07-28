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
