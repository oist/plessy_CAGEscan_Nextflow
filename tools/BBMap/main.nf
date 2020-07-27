#!/usr/bin/env nextflow

// Specify DSL2
nextflow.enable.dsl=2

params.outdir = "results"

// Clumpify
process bbmap_clumpify {

    container = 'bbmap:2020072002'

    publishDir "${params.outdir}/bbmap/clumpify",
        mode: "copy", overwrite: true

    input:
        tuple val(sampleName), path(reads1), path(reads2)

    output:
        tuple val(sampleName), path("*dedup*.fastq.gz"), emit: dedupFastqFiles

    script:

    // removed 'shortname' argument as it produces empty file on my system.
    command = """
        java -cp /usr/share/java/bbmap.jar clump.Clumpify \
            in=$reads1 \
            in2=$reads2 \
            out=${sampleName}_dedupR1.fastq.gz \
            out2=${sampleName}_dedupR2.fastq.gz \
            dedupe \
            addcount
         """

    if (params.verbose){
        println ("[MODULE] BBMap/clumpify command: " + command)
    }

    """
    ${command}
    """
}
