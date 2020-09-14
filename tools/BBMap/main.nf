#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process bbmap_version {
    container = 'cagescan/bbmap:38.86'
    input:
    output:
        stdout()
    script:
    command = ''
    if (params.verbose){
        command = "bbmap.sh -version 2>&1 | grep 'BBMap version'"
    }
    """
    ${command}
    """
}

process bbmap_clumpify {

    container = 'cagescan/bbmap:38.86'

    publishDir "${params.outdir}/bbmap/clumpify",
        mode: "copy", overwrite: true

    input:
        tuple val(sampleName), path(reads1), path(reads2)

    output:
        tuple val(sampleName),
        path("*dedupR1.fastq.gz"),
        path("*dedupR2.fastq.gz"),
        emit: dedupFastqFiles

    script:

    command =
    """
    clumpify.sh \
        in=$reads1 \
        in2=$reads2 \
        out=${sampleName}_dedupR1.fastq.gz \
        out2=${sampleName}_dedupR2.fastq.gz \
        dedupe=t \
        shortname=t \
        addcount=t
    """

    if (params.verbose){
        println ("[MODULE] BBMap/clumpify command: " + command)
    }

    """
    ${command}
    """
}

process bbmap_minlen {

    container = 'cagescan/bbmap:38.86'

    publishDir "${params.outdir}/bbmap/minlen",
        mode: "copy", overwrite: true

    input:
        tuple val(sampleName), path(reads1), path(reads2)

    output:
        tuple val(sampleName),
        path("*minlenR1.fastq.gz"),
        path("*minlenR2.fastq.gz"),
        emit: minlenFastqFiles

    script:

    command = """
        bbduk.sh \
            in=$reads1 \
            in2=$reads2 \
            out=${sampleName}_minlenR1.fastq.gz \
            out2=${sampleName}_minlenR2.fastq.gz \
            minlen=28
         """

    if (params.verbose){
        println ("[MODULE] BBDuk minlen command: " + command)
    }

    """
    ${command}
    """
}
