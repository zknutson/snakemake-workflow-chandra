# TODO: project the PSF from saotrace
def dmcopy_selection_str_psf(wildcards, input):
    irf_label = wildcards.irf_label
    header = fits.getheader(input[0], "EVENTS")
    wcs = wcs_from_header_chandra(header, x_col=9)
    return config_obj.irfs[irf_label].psf.to_dm_copy_str(wcs=wcs)

rule project_psf:
    input:
        "results/{config_name}/{obs_id}/psf/{irf_label}/{psf_simulator}/{psf_simulator}_projrays.fits"
    output:
        "results/{config_name}/{obs_id}/psf/{irf_label}/{psf_simulator}/{psf_simulator}_psf_image.fits"
    log: 
        "logs/{config_name}/{obs_id}/psf/{irf_label}/{psf_simulator}/project-psf.log"
    conda:
        "../envs/ciao-4.17.yaml"
    params:
        selection = dmcopy_selection_str_psf,
        parfolder = "logs/{config_name}/{obs_id}/psf/{irf_label}/{psf_simulator}/params",
    shell:
        'mkdir -p {params.parfolder};'
        'PFILES="{params.parfolder};$CONDA_PREFIX/contrib/param:$CONDA_PREFIX/param";'
        'dmcopy "{input}{params.selection}" {output}'
