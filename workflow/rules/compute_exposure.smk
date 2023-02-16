rule compute_exposure:
    input:
        "results/{config_name}/{obs_id}/maps/{config_name}-{obs_id}-counts.fits"
    output:
        "results/{config_name}/{obs_id}/maps/{config_name}-{obs_id}-exposure.fits"
    log: 
        "logs/{config_name}/compute-exposure-{obs_id}.log"
    conda:
        "../envs/default.yaml"
    script:
        "../scripts/compute-exposure.py"