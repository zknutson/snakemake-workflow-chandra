rule chandra_repro:
    input:
        "data/{obs_id}"
    output:
        directory("results/{config_name}/{obs_id}/repro/")
    log: 
        "logs/{config_name}/chandra-repro-{obs_id}.log"
    conda:
        "../envs/ciao-4.15.yaml"
    shell:
        "chandra_repro indir=data/{wildcards.obs_id} outdir={output}"
