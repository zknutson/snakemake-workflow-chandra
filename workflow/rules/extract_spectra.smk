from utils.io import wcs_from_header_chandra
from astropy.io import fits
import os 

def spec_extract_selection_str(wildcards, input):
    header = fits.getheader(input[0], "EVENTS")
    wcs = wcs_from_header_chandra(header)
    config_spec = config_obj.irfs[wildcards.irf_label].spectrum
    return config_spec.to_region_str(wcs=wcs)

def spec_extract_selection_energy_str(wildcards, input):
    config_spec = config_obj.irfs[wildcards.irf_label].spectrum
    return config_spec.to_energy_str()

def get_outroot(wildcards, output):
    filename =  f"{wildcards.config_name}-{wildcards.obs_id}-{wildcards.irf_label}"
    return os.path.join(output[0], filename)


rule extract_spectra:
    input:
        "results/{config_name}/{obs_id}/events/acisf{obs_id}_repro_evt2_reprojected.fits"
    output:
        directory("results/{config_name}/{obs_id}/spectra/{irf_label}/")
    log: 
        "logs/{config_name}/extract-spectra-{obs_id}-{irf_label}.log"
    conda:
        "../envs/ciao-4.15.yaml"
    params:
        selection = spec_extract_selection_str,
        selection_energy = spec_extract_selection_energy_str,
        outroot = get_outroot
    shell:
        "specextract infile='{input}{params.selection}' outroot={params.outroot} energy={params.selection_energy}"