from pathlib import Path

def get_simulate_psf_args(wildcards):
    config_psf = config_obj.irfs[wildcards.irf_label].psf
    args = config_psf.to_cmd_args()
    return args

def get_asolfile(wildcards):
    filename = f"results/{wildcards.config_name}/{wildcards.obs_id}/repro/pcadf{int(wildcards.obs_id):05d}_000N001_asol1.fits"

    if not Path(filename).exists():
        filename = f"results/{wildcards.config_name}/{wildcards.obs_id}/repro/pcadf{int(wildcards.obs_id):05d}_repro_asol1.fits"
        
    return filename

rule simulate_psf:
    input:
        infile="results/{config_name}/{obs_id}/events/{config_name}-{obs_id}-events.fits",
        spectrum="results/{config_name}/spectral-fit/{irf_label}/{config_name}-{irf_label}-source-flux-chart.dat",
    output:
        filename_psf="results/{config_name}/{obs_id}/psf/{irf_label}/{psf_simulator}/{psf_simulator}.psf",
        filename_rays="results/{config_name}/{obs_id}/psf/{irf_label}/{psf_simulator}/{psf_simulator}_projrays.fits",
    log: 
        "logs/{config_name}/{obs_id}/psf/{irf_label}/{psf_simulator}/simulate-psf.log"
    conda:
        "../envs/ciao-4.16.yaml"
    params:
        args = lambda wildcards: get_simulate_psf_args(wildcards),
        parfolder = "logs/{config_name}/{obs_id}/psf/{irf_label}/{psf_simulator}/params",
        outroot = lambda wildcards, output: output.filename_psf.replace(".psf", ""),
        asolfile = get_asolfile,
    shell:
        'mkdir -p {params.parfolder};'
        'PFILES="{params.parfolder};$CONDA_PREFIX/contrib/param:$CONDA_PREFIX/param";'
        'export MARX_ROOT=$CONDA_PREFIX;'
        'simulate_psf infile={input.infile} outroot={params.outroot} spectrum={input.spectrum} asolfile={params.asolfile} {params.args}'
