#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { TagDust2_demultiplex
        ; TagDust2_getSampleNames
        ; TagDust2_multiplex2arch
        ; TagDust2_filter_ref_SE
        ; TagDust2_filter_ref  } from './main.nf'

workflow main_wf {
  take: ch_fastq
  take: ch_arch
  main:
    TagDust2_demultiplex( ch_fastq
                        , ch_arch  )
    //TagDust2_getSampleNames( TagDust2.out.demultiplexedFastqFilesR1
    //                       , TagDust2.out.demultiplexedFastqFilesR2) | view
}

workflow multiplex2arch {
  take: multiplexFile
  take: indexSequence
  main: TagDust2_multiplex2arch(multiplexFile, indexSequence)
}
workflow removeRiboRNA {
  take: pairedFASTQfiles
  take: referenceRRNAfile
  main: TagDust2_filter_ref(pairedFASTQfiles, referenceRRNAfile)
}
workflow removeRiboRNA_SE {
  take: FASTQfiles
  take: referenceRRNAfile
  main: TagDust2_filter_ref_SE(FASTQfiles, referenceRRNAfile)
}
