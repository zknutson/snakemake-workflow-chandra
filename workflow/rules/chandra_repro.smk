def get_outdir(wildcards, output):
    """Get the output directory from the output file name."""
    return str(Path(output[0]).parent)

rule chandra_repro:
    input:
        "data/{obs_id}"
    output:
        "results/{config_name}/{obs_id}/repro/acisf{obs_id}_repro_evt2.fits"
    log: 
        "logs/{config_name}/chandra-repro-{obs_id}.log"
    conda:
        "../envs/ciao-4.15.yaml"
    params:
        outdir = get_outdir
    shell:
        "chandra_repro indir=data/{wildcards.obs_id} outdir={params.outdir}"
