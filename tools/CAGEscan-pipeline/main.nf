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
              path(assembled)
        path(index)

    output:
        tuple val(sampleName),
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

process CAGEscanCountHits {
    container = 'cagescan-pipeline:2020072701'
    publishDir "${params.outdir}/CAGEscan/hits",
        mode: "copy", overwrite: true
    input:
        tuple val(sampleName),
              path(mapped)

    output:
        tuple val(sampleName),
              path("*.hits.txt"),
              emit: CAGEscanCountedHits
    script:
    command = """
        cagescan-count-hits.sh ${mapped} |
           awk '{print \$0 "\t${sampleName}"}' > "${sampleName}".hits.txt
        """

    if (params.verbose){
        println ("[MODULE] CAGEscan count hits command: " + command)
    }

    """
    ${command}
    """
}

process CAGEscanBuildTranscripts {
    container = 'cagescan-pipeline:2020072701'
    publishDir "${params.outdir}/CAGEscan/transcripts",
        mode: "copy", overwrite: true
    input:
        tuple val(sampleName),
              path(mapped)

    output:
        tuple val(sampleName),
              path("*.transcripts.txt"),
              emit: CAGEscanCountedHits
    script:
    command = """
        cagescan-build-transcripts.py -b20 -m0.001 ${mapped} > ${sampleName}.transcripts.txt
        """

    if (params.verbose){
        println ("[MODULE] CAGEscan build transcripts command: " + command)
    }

    """
    ${command}
    """
}

process CAGEscanConvertToBED12 {
    container = 'cagescan-pipeline:2020072701'
    publishDir "${params.outdir}/CAGEscan/BED12",
        mode: "copy", overwrite: true
    input:
        tuple val(sampleName),
              path(transcripts)

    output:
        tuple val(sampleName),
              path("*.bed"),
              emit: CAGEscanBED12
    script:
    command = """
        cagescan-to-bed.py -s1e6 ${transcripts} |
           sort -k1,1 -k2,2n -k3,3n -k4,4 -k6,6 > ${sampleName}.bed
        """

    if (params.verbose){
        println ("[MODULE] CAGEscan convert to BED12 command: " + command)
    }

    """
    ${command}
    """
}
