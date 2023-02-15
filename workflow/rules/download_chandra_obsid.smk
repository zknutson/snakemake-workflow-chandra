rule download_chandra_obsid:
    output:
        "data/{obs_id}/oif.fits"
    log: 
        "logs/download-chandra-obsid-{obs_id}.log"
    conda:
        "../envs/ciao-4.15.yaml"
    shell:
        "cd data; "
        "download_chandra_obsid {wildcards.obs_id} --exclude vvref"