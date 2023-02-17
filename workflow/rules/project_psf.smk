rule project_psf:
    input:
        "results/{config_name}/{obs_id}/psf/{irf_label}/{config[psf_simulator]}"
    output:
        "results/{config_name}/maps/{config_name}-{obs_id}-{irf_label}-psf.fits"
    log: 
        "logs/{config_name}/{obs_id}/{config_name}-{obs_id}-{irf_label}-project-psf.log"
    conda:
        "../envs/ciao-4.15.yaml"
    shell:
        "simulate_psf infile='{input}{params.selection}' outroot={params.outroot} energy={params.selection_energy}"