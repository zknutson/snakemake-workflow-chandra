rule download_chandra_obsid:
    output:
        directory("data/{obs_id}")
    log: 
        "logs/download-chandra-obsid-{obs_id}.log"
    conda:
        "../envs/ciao-4.15.yaml"
    shell:
        "cd data; "
        "download_chandra_obsid {wildcards.obs_id} --exclude vvref"