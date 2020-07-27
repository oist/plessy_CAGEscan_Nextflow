#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process TagDust2 {

    container = 'tagdust2:2020071401'

    publishDir "${params.outdir}/tagdust2",
        mode: "copy", overwrite: true

    input:
        tuple val(sampleName), path(reads1), path(reads2)
        path(tagdust_arch)
        path(tagdust_ref)

    output:
        tuple val(sampleName),
        path("*_BC_*_READ1.fq"),
        path("*_BC_*_READ2.fq"),
            emit: dedupFastqFiles

    script:

    // removed 'shortname' argument as it produces empty file on my system.
    command = """
        tagdust                            \
            -show_finger_seq               \
            -ref $tagdust_ref              \
            -arch $tagdust_arch            \
            -o ${sampleName}               \
            ${reads1}                      \
            ${reads2}                      \
         """

    if (params.verbose){
        println ("[MODULE] TagDust2 command: " + command)
    }

    """
    ${command}
    """
}
