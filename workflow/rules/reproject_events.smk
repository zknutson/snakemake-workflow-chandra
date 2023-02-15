rule reproject_events:
    input:
        infile = "data/{obs_id}/repro/acisf{obs_id:05d}_repro_evt2.fits",
        match = "data/{obs_id}/repro/acisf{config[obs_id_ref]:05d}_repro_evt2.fits"
    output:
        "data/{obs_id}/repro/acisf{obs_id:05d}_repro_evt2_reprojected.fits",
    log: 
        "logs/reproject-events-{obs_id}.log"
    conda:
        "../envs/ciao-4.15.yaml"
    shell:
        "reproject_events infile={input.infile} outfile={output} match={input.match}"