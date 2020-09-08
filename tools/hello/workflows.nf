#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { hello1
        ; hello2
        ; hello3
        ; listOfFiles } from './processes.nf'

workflow testHello2 {
  take: aPairOfFiles
  main:
    hello2(aPairOfFiles)
}

worflow testListOfFiles {
  take: aListOfFiles
  main:
    listOfFiles(aListOfFiles)
}
