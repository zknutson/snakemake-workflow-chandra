rule download_chandra_obsid:
    output:
        directory("data/{obs_id}")
    log: 
        "logs/download-chandra-obsid-{obs_id}.log"
    conda:
        "ciao-4.14"
    shell:
        "cd data; "
        "which python;"
        "download_chandra_obsid {wildcards.obs_id} --exclude vvref"