rule fit_spectra:
    input:
        expand("results/{{config_name}}/{obs_id}/spectra/{{irf_label}}/{{config_name}}-{obs_id}-{{irf_label}}.pi", obs_id=config["obs_ids"])
    output:
        "results/{config_name}/spectral-fit/{irf_label}/{config_name}-{irf_label}-source-flux-chart.dat",
        "results/{config_name}/spectral-fit/{irf_label}/{config_name}-{irf_label}-spectral-model.yaml",
    log:
        notebook="results/{config_name}/notebooks/{config_name}-{irf_label}-fit-spectra.ipynb"
    conda:
        "../envs/ciao-4.15.yaml"
    notebook:
        "../notebooks/fit-spectra.ipynb"