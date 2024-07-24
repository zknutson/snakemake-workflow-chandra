rule compute_spectral_weights:
    input:
        filename_spectrum=expand("results/{{config_name}}/spectral-fit/{irf_label_ref}/{{config_name}}-{irf_label_ref}-source-flux-chart.dat", irf_label_ref=list(config_obj.irfs)[0]),
    output:
        filename_spectrum_weights=expand("results/{{config_name}}/spectral-fit/{irf_label_ref}/{{config_name}}-{irf_label_ref}-source-flux-weights.csv", irf_label_ref=list(config_obj.irfs)[0]),
    conda:
        "../envs/ciao-4.16.yaml"
    script:
        "../scripts/spectrum-weights.py"