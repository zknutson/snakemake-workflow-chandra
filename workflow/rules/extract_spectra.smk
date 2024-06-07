from astropy.io import fits
import os 

def spec_extract_selection_str(wildcards, input):
    header = fits.getheader(input[0], "EVENTS")
    wcs = wcs_from_header_chandra(header)
    config_spec = config_obj.irfs[wildcards.irf_label].spectrum
    return config_spec.to_region_str(wcs=wcs)

def spec_extract_bkg_selection_str(wildcards, input):
    config_spec = config_obj.irfs[wildcards.irf_label].spectrum
    return config_spec.to_background_str()

def spec_extract_selection_energy_str(wildcards, input):
    config_spec = config_obj.irfs[wildcards.irf_label].spectrum
    return config_spec.to_energy_str()

def get_outroot(wildcards, output):
    path = f"results/{wildcards.config_name}/{wildcards.obs_id}/spectra/{wildcards.irf_label}"
    filename_stem =  f"{wildcards.config_name}-{wildcards.obs_id}-{wildcards.irf_label}"
    return os.path.join(path, filename_stem)


rule extract_spectra:
    input:
        "results/{config_name}/{obs_id}/events/{config_name}-{obs_id}-events.fits"
    output:
        "results/{config_name}/{obs_id}/spectra/{irf_label}/{config_name}-{obs_id}-{irf_label}.pi",
        "results/{config_name}/{obs_id}/spectra/{irf_label}/{config_name}-{obs_id}-{irf_label}.arf",
        "results/{config_name}/{obs_id}/spectra/{irf_label}/{config_name}-{obs_id}-{irf_label}.rmf",
        "results/{config_name}/{obs_id}/spectra/{irf_label}/{config_name}-{obs_id}-{irf_label}_grp.pi",
    log: 
        "logs/{config_name}/{obs_id}/spectra/{irf_label}/extract-spectra.log"
    conda:
        "../envs/ciao-4.16.yaml"
    params:
        selection = spec_extract_selection_str,
        selection_energy = spec_extract_selection_energy_str,
        outroot = get_outroot,
        parfolder = "logs/{config_name}/{obs_id}/spectra/{irf_label}/params",
        bkg_selection = spec_extract_bkg_selection_str,
    shell:
        'mkdir -p {params.parfolder};'
        'PFILES="{params.parfolder};$CONDA_PREFIX/contrib/param:$CONDA_PREFIX/param";'
        'specextract infile="{input}{params.selection}" outroot={params.outroot} energy={params.selection_energy} bkgresp=yes bkgfile="{input}{params.bkg_selection}"'