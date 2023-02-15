rule reproject_events:
    input:
        "results/{config_name}/{obs_id}/repro/"
    output:
        "results/{config_name}/{obs_id}/events/acisf{obs_id}_repro_evt2_reprojected.fits"
    log: 
        "logs/{config_name}/reproject-events-{obs_id}.log"
    conda:
        "../envs/ciao-4.15.yaml"
    params:
        obs_id_ref = config_obj.obs_id_ref
    shell:
        "reproject_events "
        "infile=results/{wildcards.config_name}/{wildcards.obs_id}/repro/acisf{wildcards.obs_id}_repro_evt2.fits "
        "outfile={output} "
        "match=results/{wildcards.config_name}/{wildcards.obs_id}/repro/acisf{params.obs_id_ref}_repro_evt2.fits"