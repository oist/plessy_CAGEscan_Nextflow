#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { bbmap_clumpify
        ; bbmap_minlen
        ; bbmap_version  } from './main.nf'

workflow main_wf {
    take: ch_fastq
    main:
    bbmap_version | view
    bbmap_clumpify(ch_fastq) |
    bbmap_minlen
}
