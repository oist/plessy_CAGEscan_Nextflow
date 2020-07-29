#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir = "test_results"
params.verbose = true

include {CAGEscanFindMolecules    } from './main.nf'
include {CAGEscanAssemble         } from './main.nf'
include {CAGEscanMap              } from './main.nf'
include {CAGEscanCountHits        } from './main.nf'
include {CAGEscanBuildTranscripts } from './main.nf'

log.info ("Starting tests for CAGEscan pipeline...")

testData = [ [ 'Sample1', "../test/Sample1_BC_ACATGA_READ1.fq", "../test/Sample1_BC_ACATGA_READ2.fq" ] ]

channel
  .from(testData)
  .map { row -> [ row[0], file(row[1], checkIfExists: true), file(row[2], checkIfExists: true) ] }
  .set {ch_fastq}

channel
  .value(file("../test/last"))
  .set {ch_index}

workflow {
    CAGEscanFindMolecules(ch_fastq)
    CAGEscanAssemble(CAGEscanFindMolecules.out)
    CAGEscanMap(CAGEscanAssemble.out, ch_index)
    CAGEscanCountHits(CAGEscanMap.out)
    CAGEscanBuildTranscripts(CAGEscanMap.out)
}
