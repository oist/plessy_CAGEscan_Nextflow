#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { testHello2 } from './workflows.nf'

params.outdir = "results"

channel
  .from ([["Bonjour", "./m.ain.nf"]])
  .map { r -> [ r[0], file(r[1]) ] }
  .set { myPair }

workflow {
  testHello2(myPair)
}

