def get_outdir(wildcards, output):
    """Get the output directory from the output file name."""
    return str(Path(output[0]).parent)

rule chandra_repro:
    input:
        "data/{obs_id}/download.done",
    output:
        touch("results/{config_name}/{obs_id}/repro/repro.done")
    log: 
        "logs/{config_name}/chandra-repro-{obs_id}.log"
    conda:
        "../envs/ciao-4.16.yaml"
    params:
        outdir = get_outdir
    shell:
        "chandra_repro indir=data/{wildcards.obs_id} outdir={params.outdir}"
