def get_repro_event_file_match(wildcards):
    """Get the event file to match to"""
    path = Path(f"results/{wildcards.config_name}/{config_obj.obs_id_ref}/repro/")

    instrument = config_obj.obs_info_table.loc[wildcards.obs_id]["INSTR"]

    if "ACIS" in instrument:
        filename =  f"acisf{config_obj.obs_id_ref:05d}_repro_evt2.fits"
    else:
        filename = f"hrcf{config_obj.obs_id_ref:05d}_repro_evt2.fits"

    return str(path / filename)


def get_repro_match_done(wildcards):
    """Get the event file to match to"""
    return f"results/{wildcards.config_name}/{config_obj.obs_id_ref}/repro/repro.done"


def get_repro_event_file(wildcards):
    """Get the event file"""
    obs_id = int(wildcards.obs_id)
    path = Path(f"results/{wildcards.config_name}/{obs_id}/repro/")

    instrument = config_obj.obs_info_table.loc[wildcards.obs_id]["INSTR"]

    if "ACIS" in instrument:
        filename =  f"acisf{obs_id:05d}_repro_evt2.fits"
    else:
        filename = f"hrcf{obs_id:05d}_repro_evt2.fits"
    
    return str(path / filename)


def get_repro_done(wildcards):
    """Get the event file"""
    return  f"results/{wildcards.config_name}/{wildcards.obs_id}/repro/repro.done"



rule reproject_events:
    input:
        get_repro_done,
        get_repro_match_done,
    output:
        "results/{config_name}/{obs_id}/events/{config_name}-{obs_id}-events.fits"
    log: 
        "logs/{config_name}/{obs_id}/reproject-events.log"
    conda:
        "../envs/ciao-4.17.yaml"
    params:
        match = get_repro_event_file_match,
        infile = get_repro_event_file,
        parfolder = "logs/{config_name}/{obs_id}/params",
        args = config_obj.ciao.reproject_events.to_cmd_args(),
    shell:
        'mkdir -p {params.parfolder};'
        'PFILES="{params.parfolder};$CONDA_PREFIX/contrib/param:$CONDA_PREFIX/param";'
        'reproject_events infile={params.infile} outfile={output} match={params.match} {params.args}'