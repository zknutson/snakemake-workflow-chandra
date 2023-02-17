rule simulate_psf:
    input:
        "results/{config_name}/{obs_id}/events/acisf{obs_id}_repro_evt2_reprojected.fits"
    output:
        directory("results/{config_name}/{obs_id}/psf/{irf_label}/{config[psf_simulator]}")
    log: 
        "logs/{config_name}/{obs_id}/{config_name}-{obs_id}-{irf_label}-simulate-psf.log"
    conda:
        "../envs/ciao-4.15.yaml"
    shell:
        "simulate_psf infile='{input}{params.selection}' outroot={params.outroot} energy={params.selection_energy}"