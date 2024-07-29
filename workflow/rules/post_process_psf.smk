rule post_process_psf:
    input:
       "results/{config_name}/{obs_id}/psf/{irf_label}/{psf_simulator}/{psf_simulator}_psf_image.fits"
    output:
        "results/{config_name}/{obs_id}/maps/{config_name}-{obs_id}-{irf_label}-{psf_simulator}-psf.fits"
    log: 
        "logs/{config_name}/{obs_id}/psf/{irf_label}/{psf_simulator}/post-process-psf.log"
    conda:
        "../envs/ciao-4.16.yaml"
    script:
        "../scripts/post-process-psf.py"