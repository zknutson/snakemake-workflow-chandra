def get_outdir(wildcards, output):
    """Get the output directory from the output file name."""
    return str(Path(output.filename_done).parent)


rule compute_exposure_flux:
    input:
        filename_events="results/{config_name}/{obs_id}/events/{config_name}-{obs_id}-events.fits",
        filename_spectrum=expand("results/{{config_name}}/spectral-fit/{irf_label_ref}/{{config_name}}-{irf_label_ref}-source-flux-weights.csv", irf_label_ref=list(config_obj.irfs)[0]),
        filename_counts="results/{config_name}/{obs_id}/maps/{config_name}-{obs_id}-counts.fits",
    output:
        filename_done=touch("results/{config_name}/{obs_id}/flux/flux.done"),
        filename_exposure="results/{config_name}/{obs_id}/maps/{config_name}-{obs_id}-exposure.fits",
    log: 
        "logs/{config_name}/{obs_id}/compute-exposure-flux.log"
    conda:
        "../envs/ciao-4.17.yaml"
    params:
        outdir = get_outdir,
        parfolder = "logs/{config_name}/{obs_id}/params",
    shell:
        'mkdir -p {params.parfolder};'
        'PFILES="{params.parfolder};$CONDA_PREFIX/contrib/param:$CONDA_PREFIX/param";'
        "fluximage {input.filename_events} {params.outdir}/flux xygrid={input.filename_counts} bands={input.filename_spectrum} clobber=yes mode=h;"
        "cp {params.outdir}/flux_band1_thresh.expmap {output.filename_exposure};"