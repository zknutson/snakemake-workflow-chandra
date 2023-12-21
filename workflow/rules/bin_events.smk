from astropy.io import fits

def dmcopy_selection_str(wildcards, input):
    header = fits.getheader(input[0], "EVENTS")
    wcs = wcs_from_header_chandra(header)
    return config_obj.roi.to_dm_copy_str(wcs=wcs)


rule bin_events:
    input:
        "results/{config_name}/{obs_id}/events/{config_name}-{obs_id}-events.fits"
    output:
        "results/{config_name}/{obs_id}/maps/{config_name}-{obs_id}-counts.fits"
    log: 
        "logs/{config_name}/bin-events-{obs_id}.log"
    conda:
        "../envs/ciao-4.16.yaml"
    params:
        selection = dmcopy_selection_str
    shell:
        "dmcopy '{input}{params.selection}' {output}"