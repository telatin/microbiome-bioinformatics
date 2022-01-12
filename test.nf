#!/usr/bin/env nextflow
 
/*
 *    Climb Workshop on Metagenomics Profiling, 2021
 * 
 *    USAGE:
 *    nextflow run kraken.nf --reads 'path/to/reads/*_R{1,2}.fq.gz'
 */

/*
 * Defines some parameters in order to specify the refence genomes
 * and read pairs by using the command line options
 */

params.reads = "$baseDir/data/ggal/*_{1,2}.fq"
params.db = "/data/db/kraken2/standard-16gb/"
params.host = "/data/db/kraken2/mouse_GRCm39/"
params.outdir = 'kraken-output'
params.readlen = 150
params.threads = 16
/*
 * Create the `read_pairs_ch` channel that emits tuples containing three elements:
 * the pair ID, the first read-pair file and the second read-pair file
 */
Channel
    .fromFilePairs( params.reads )
    .ifEmpty { error "Cannot find any reads matching: ${params.reads}" }
    .set { read_pairs_ch }
  
   
// Filter with FASTP
process nohost {
    tag "$pair_id"
      
    input:
    tuple val(pair_id), path(reads) from read_pairs_ch
  
    output:
    set pair_id, path("sample_1.fq.gz"), path("sample_2.fq.gz") into nohost_ch
  
    """
    mkdir nohost
    kraken2 --db ${params.host} --confidence 0.5 \
     --unclassified-out nohost/nohost#.fq \
     --paired ${reads[0]} ${reads[1]}

    pigz -p ${params.threads} *.fq
    """
}


// Filter with FASTP
process filter {
    tag "$pair_id"
      
    input:
    tuple val(pair_id), path(reads) from nohost_ch
  
    output:
    set pair_id, "filtered/*" into fastp_ch
  
    """
    mkdir filtered
    fastp -i ${reads[0]} -I ${reads[1]} \
      -o filtered/${reads[0]} -O filtered/${reads[1]}  \
      --detect_adapter_for_pe -w ${params.threads}
    """
}

// Process with Kraken2   
process kraken {
    tag "$pair_id"
    publishDir params.outdir, mode: 'copy' 
        
    input:
    path db from params.db
    tuple val(pair_id), path(reads) from fastp_ch
      
    output:
    tuple val(pair_id), path("kraken.report") into report_ch
    tuple val(pair_id), path("kraken.tsv") into tsv_ch
  
    """
    kraken2 --threads ${params.threads} --db $db --report kraken.report --output kraken.tsv --paired ${reads[0]} ${reads[1]}
    """
}

// Bracken
process bracken {
    tag "$pair_id"
    publishDir params.outdir, mode: 'copy' 
        
    input:
    path db from params.db
    tuple val(pair_id), path("kraken.report") from report_ch
      
    output:
    tuple val(pair_id), path("${pair_id}.report") into breport_ch
    tuple val(pair_id), path("${pair_id}.tsv") into btsv_ch
  
    """
    
    bracken -d $db -i kraken.report -o ${pair_id}.tsv -w ${pair_id}.report -r ${params.readlen} -l S -t 10
    """
}


// Collect all Bracken results and merge!
process combine {
    publishDir params.outdir, mode:'copy'

    input:
    path("*") from breport_ch.collect().ifEmpty([])

    output:
    path("merged_rel_abund.csv")
    path("merged_read_numbers.csv")

    """
    python /data/shared/scripts/merge_profiling_reports.py -i ./ -o merged
    """
}