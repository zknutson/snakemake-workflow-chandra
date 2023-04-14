# TODO: project the PSF from saotrace
rule project_psf:
    input:
        "results/{config_name}/{obs_id}/psf/{irf_label}/{psf_simulator}/{psf_simulator}.psf"
    output:
        "results/{config_name}/{obs_id}/maps/{config_name}-{obs_id}-{irf_label}-{psf_simulator}-psf.fits"
    log: 
        "logs/{config_name}/{obs_id}/{config_name}-{obs_id}-{irf_label}-{psf_simulator}-psf.log"
    conda:
        "../envs/ciao-4.15.yaml"
    shell:
        "cp {input} {output}"
