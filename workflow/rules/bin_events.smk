from astropy.io import fits

def dmcopy_selection_str(wildcards, input):
    header = fits.getheader(input[0], "EVENTS")
    wcs = wcs_from_header_chandra(header)

    include_energy = "ACIS" in header["INSTRUME"]
    is_using_samp = "HRC" in header["INSTRUME"]
    return config_obj.roi.to_dm_copy_str(wcs=wcs, include_energy=include_energy, is_using_samp=is_using_samp)


rule bin_events:
    input:
        "results/{config_name}/{obs_id}/events/{config_name}-{obs_id}-events.fits"
    output:
        "results/{config_name}/{obs_id}/maps/{config_name}-{obs_id}-counts.fits",
    log: 
        "logs/{config_name}/{obs_id}/bin-events.log"
    conda:
        "../envs/ciao-4.17.yaml"
    params:
        selection = dmcopy_selection_str,
        parfolder = "logs/{config_name}/{obs_id}/params",
    shell:
        'mkdir -p {params.parfolder};'
        'PFILES="{params.parfolder};$CONDA_PREFIX/contrib/param:$CONDA_PREFIX/param";'
        'dmcopy "{input}{params.selection}" {output}'


