rule download_chandra_obsid:
    output:
        "data/{obs_id}/oif.fits",
        touch("data/{obs_id}/download.done"),
    log: 
        "logs/download-chandra-obsid-{obs_id}.log"
    conda:
        "../envs/ciao-4.16.yaml"
    shell:
        "cd data; "
        "download_chandra_obsid {wildcards.obs_id} --exclude vvref"