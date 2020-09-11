#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// To Do: a multiplex file validator process.

process TagDust2 {

    container = 'tagdust2:2020071401'

    publishDir "${params.outdir}/tagdust2",
        mode: "copy", overwrite: true

    input:
        tuple val(sampleName), path(reads1), path(reads2)
        path(tagdust_arch)
        path(tagdust_ref)

    output:
//        tuple path("*_BC_*_READ1.fq"), path("*_BC_*_READ2.fq"), emit: demultiplexedFastqFiles
        path "*_BC_*_READ1.fq", emit: demultiplexedFastqFilesR1
        path "*_BC_*_READ2.fq", emit: demultiplexedFastqFilesR2
        path "*_logfile.txt",   emit: TagDust2LogFile

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

process TagDust2_demultiplex {
// Same as TagDust2 but with no --ref
// Because we want to count rRNAs after demultiplexing
    container = 'tagdust2:2020071401'

    publishDir "${params.outdir}/tagdust2",
        mode: "copy", overwrite: true

    input:
        tuple val(sampleName), path(reads1), path(reads2)
        path(tagdust_arch)

    output:
//        tuple path("*_BC_*_READ1.fq"), path("*_BC_*_READ2.fq"), emit: demultiplexedFastqFiles
        path "*_BC_*_READ1.fq", emit: demultiplexedFastqFilesR1
        path "*_BC_*_READ2.fq", emit: demultiplexedFastqFilesR2
        path "*_logfile.txt",   emit: TagDust2LogFile

    script:

    // removed 'shortname' argument as it produces empty file on my system.
    command = """
        tagdust                            \
            -show_finger_seq               \
            -arch $tagdust_arch            \
            -o ${sampleName}               \
            ${reads1}                      \
            ${reads2}                      \
         """

    if (params.verbose){
        println ("[MODULE] TagDust2_demultiplex command: " + command)
    }

    """
    ${command}
    """
}

process TagDust2_filter_ref {
// Same as TagDust2 but with no demultiplexing
// This is to count and remove rRNAs after demultiplexing
    container = 'tagdust2:2020071401'

    publishDir "${params.outdir}/tagdust2",
        mode: "copy", overwrite: true

    input:
        tuple val(sampleName), path(reads1), path(reads2)
        path(tagdust_ref)

    output:
//        tuple path("*_BC_*_READ1.fq"), path("*_BC_*_READ2.fq"), emit: demultiplexedFastqFiles
        path "*_BC_*_READ1.fq", emit: demultiplexedFastqFilesR1
        path "*_BC_*_READ2.fq", emit: demultiplexedFastqFilesR2
        path "*_logfile.txt",   emit: TagDust2LogFile

    script:

    command = """
        tagdust                            \
            -ref $tagdust_ref              \
            -arch trivial.arch             \
            -o ${sampleName}               \
            ${reads1}                      \
            ${reads2}                      \
         """

    if (params.verbose){
        println ("[MODULE] TagDust2_filter_ref command: " + command)
    }

    """
    printf 'tagdust -1 R:N\n' > trivial.arch
    ${command}
    """
}

process TagDust2_filter_ref_SE {
// Same as TagDust2 but with no demultiplexing
// This is to count and remove rRNAs after demultiplexing
    container = 'tagdust2:2020071401'

    publishDir "${params.outdir}/tagdust2",
        mode: "copy", overwrite: true

    input:
        path(reads)
        path(tagdust_ref)

    output:
        path "*.fq", emit: demultiplexedFastqFile
        path "*_logfile.txt",   emit: TagDust2LogFile

    script:

    command = """
        tagdust                            \
            -ref $tagdust_ref              \
            -arch trivial.arch             \
            -o ${reads}                    \
            ${reads}                       \
         """

    if (params.verbose){
        println ("[MODULE] TagDust2_filter_ref_SE command: " + command)
    }

    """
    printf 'tagdust -1 R:N\n' > trivial.arch
    ${command}
    """
}

process TagDust2_getSampleNames {

  input:
    path(R1)
    path(R2)
    val(multiplexFile)

  output:
    tuple path(R1), path(R2)

  script:
  """
  printf "Hello\n"
  """
}

process TagDust2_multiplex2arch {
  publishDir "${params.outdir}/tagdust2",
    mode: "copy", overwrite: true

  input:
    val(multiplexFile)
    val(index)

  output:
    path "tagdust.arch", emit: TagDust2ArchFile

  shell:
  '''
    BARCODES=$(awk -v idx=!{index} '$4 == idx {print $3}' !{multiplexFile})
    BARCODES=$(echo $BARCODES | sed 's/ /,/g') # Bashism ?
    cat > tagdust.arch <<__END__
    tagdust -1 B:$BARCODES -2 F:NNNNNNNN -3 S:TATAGGG -4 R:N
    tagdust -1 R:N
    __END__
  '''
}
