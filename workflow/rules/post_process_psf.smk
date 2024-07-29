rule post_process_psf:
    input:
       filename="results/{config_name}/{obs_id}/psf/{irf_label}/{psf_simulator}/{psf_simulator}_psf_image.fits"
    output:
        filename="results/{config_name}/{obs_id}/maps/{config_name}-{obs_id}-{irf_label}-{psf_simulator}-psf.fits"
    log: 
        "logs/{config_name}/{obs_id}/psf/{irf_label}/{psf_simulator}/post-process-psf.log"
    conda:
        "../envs/default.yaml"
    script:
        "../scripts/post-process-psf.py"