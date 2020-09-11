#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.outdir = "pipeline_results"
params.verbose = false

// params.reads     -> a base name to the read files  
// params.index     -> a base name to the LAST index
// params.dust      -> a FASTA file with primer sequences
// params.rRNA      -> a FASTA file with rRNA sequences
// params.multiplex -> the "multiplex" file

include { TagDust2_multiplex2arch
        ; TagDust2_demultiplex
        ; TagDust2_filter_ref as TagDust2_dust
        ; TagDust2_filter_ref as TagDust2_rRNA
        ; TagDust2_associateWithSampleName      } from  './tools/TagDust2/main.nf'
include { bbmap_clumpify  }                from  './tools/BBMap/main.nf'
include { main_nf as CAGEscan_pipeline }   from  './tools/CAGEscan-pipeline/workflow.nf'

log.info ("Starting the CAGEscan pipeline...")

channel
  .fromFilePairs("${params.reads}{1,2}*.fastq.gz")
  .map { row -> [ row[0], row[1][0], row[1][1] ] }
  .set { ch_fastqPairs }

channel
  .value(file(params.rRNA, checkIfExists: true))
  .set { ch_rRNA_fasta }

channel
  .value(file(params.dust, checkIfExists: true))
  .set { ch_dust_fasta }

channel
  .value(file(params.multiplex, checkIfExists: true))
  .set { ch_multiplexfile }

channel
  .value(params.index)
  .set {ch_index}


workflow {
    TagDust2_multiplex2arch( ch_fastqPairs
                           , ch_multiplexfile)
    TagDust2_demultiplex( TagDust2_multiplex2arch.out.fastqPairs
                        , TagDust2_multiplex2arch.out.arch)
    TagDust2_associateWithSampleName( TagDust2_demultiplex.out.fastqR1.flatten()
                                    , TagDust2_demultiplex.out.fastqR2.flatten()
                                    , ch_multiplexfile)
    TagDust2_associateWithSampleName.out.view()
//  TagDust2_dust(TagDust2_demultiplex.out.fastqPairs, ch_dust_fasta)
//  TagDust2_rRNA(TagDust2_dust.out.fastqPairs, ch_rRNA_fasta)
//  CAGEscan_pipeline(TagDust2_rRNA.out.fastqPairs, ch_index)
//  view(CAGEscan_pipeline.out)
}
