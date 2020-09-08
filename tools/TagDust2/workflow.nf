#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { TagDust2
        ; TagDust2_getSampleNames
        ; TagDust2_multiplex2arch  } from './main.nf'

workflow main_wf {
  take: ch_fastq
  take: ch_arch
  take: ch_ref
  main:
    TagDust2( ch_fastq
            , ch_arch
            , ch_ref)
    //TagDust2_getSampleNames( TagDust2.out.demultiplexedFastqFilesR1
    //                       , TagDust2.out.demultiplexedFastqFilesR2) | view
}

workflow multiplex2arch {
  take: multiplexFile
  take: indexSequence
  main: TagDust2_multiplex2arch(multiplexFile, indexSequence)
}
