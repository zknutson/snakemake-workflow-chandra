
# def get_repro_event_file(wildcards):
#     """Get the event file"""
#     obs_id = int(wildcards.obs_id)
#     return  f"results/{wildcards.config_name}/{obs_id}/repro/acisf{obs_id:05d}_repro_evt2.fits"


rule compute_exposure_flux:
    input:
        filename_events="results/{config_name}/{obs_id}/events/{config_name}-{obs_id}-events.fits",
        filename_spectrum=expand("results/{{config_name}}/spectral-fit/{irf_label_ref}/{{config_name}}-{irf_label_ref}-source-flux-chart.dat", irf_label_ref=list(config_obj.irfs)[0]),
        filename_counts="results/{config_name}/{obs_id}/maps/{config_name}-{obs_id}-counts.fits",
    output:
        path="results/{config_name}/{obs_id}/maps/flux",
        filename_exposure="results/{config_name}/{obs_id}/maps/{config_name}-{obs_id}-exposure.fits",
    log: 
        "logs/{config_name}/{obs_id}/compute-exposure-flux.log"
    conda:
        "../envs/ciao-4.16.yaml"
    params:
        parfolder = "logs/{config_name}/{obs_id}/params",
    shell:
        'mkdir -p {params.parfolder};'
        'PFILES="{params.parfolder};$CONDA_PREFIX/contrib/param:$CONDA_PREFIX/param";'
        "fluximage {input.filename_events} {output.path} xygrid={input.filename_counts} bands={input.filename_spectrum} clobber=yes mode=h;"
        "cp {output.path}/flux_.expmap {output.filename_exposure};"