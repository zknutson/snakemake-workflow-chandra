
def get_filename_oif_ref(wildcards):
    """Get the event file to match to"""
    return f"data/{config_obj.obs_id_ref}/oif.fits"


rule compute_exposure:
    input:
        filename_counts="results/{config_name}/{obs_id}/maps/{config_name}-{obs_id}-counts.fits",
        filename_oif="data/{obs_id}/oif.fits",
        filename_oif_ref=get_filename_oif_ref,
    output:
        filename_exposure="results/{config_name}/{obs_id}/maps/{config_name}-{obs_id}-exposure.fits"
    log: 
        "logs/{config_name}/compute-exposure-{obs_id}.log"
    conda:
        "../envs/default.yaml"
    script:
        "../scripts/compute-exposure.py"