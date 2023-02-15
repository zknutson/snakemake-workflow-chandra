rule chandra_repro:
    input:
        "data/{obs_id}/oif.fits"
    output:
        directory("data/{obs_id}/repro")
    log: 
        "logs/chandra-repro-{obs_id}.log"
    conda:
        "../envs/ciao-4.15.yaml"
    shell:
        "chandra_repro indir=data/{wildcards.obs_id} outdir={output}"
