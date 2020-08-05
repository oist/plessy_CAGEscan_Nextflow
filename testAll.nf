#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir = "test_results"

include { TagDust2 }                  from  './tools/TagDust2/main.nf'
include { bbmap_clumpify
        ; bbmap_minlen    }           from  './tools/BBMap/main.nf'
include { CAGEscanFindMolecules
        ; CAGEscanAssemble
        ; CAGEscanMap
        ; CAGEscanCountHits
        ; CAGEscanBuildTranscripts
        ; CAGEscanConvertToBED12   }  from  './tools/CAGEscan-pipeline/main.nf'

log.info ("Starting tests of whole CAGEscan pipeline...")

testData = [ [ 'Sample1'
             , "./tools/test/test_R1.fastq.gz"
             , "./tools/test/test_R2.fastq.gz"
             ]
           , [ 'Sample2'
             , "./tools/test/Embryo_S2_L001_R1_001.fastq.gz"
             , "./tools/test/Embryo_S2_L001_R2_001.fastq.gz"
             ]
           ]

params.verbose = true

channel
  .from(testData)
  .map { row -> [ row[0], file(row[1], checkIfExists: true), file(row[2], checkIfExists: true) ] }
  .set {ch_fastq}

channel
  .value(file("./tools/test/tagdust.arch"))
  .set {ch_arch}

channel
  .value(file("./tools/test/tagdust.fa"))
  .set {ch_ref}

channel
  .value(file("../test/last"))
  .set {ch_index}

workflow {
  bbmap_clumpify(ch_fastq) |
  bbmap_minlen
  TagDust2(bbmap_minlen.out, ch_arch, ch_ref)
  CAGEscanFindMolecules(TagDust2.out.demultiplexedFastqFiles) |
  CAGEscanAssemble
  CAGEscanMap(CAGEscanAssemble.out, ch_index)
  CAGEscanCountHits(CAGEscanMap.out)
  CAGEscanBuildTranscripts(CAGEscanMap.out)
  CAGEscanConvertToBED12(CAGEscanBuildTranscripts.out)
}

