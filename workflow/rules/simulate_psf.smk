def get_simulate_psf_args(wildcards):
    config_psf = config_obj.irfs[wildcards.irf_label].psf
    args = config_psf.to_cmd_args()
    print(args)
    return args

rule simulate_psf:
    input:
        infile="results/{config_name}/{obs_id}/events/{config_name}-{obs_id}-events.fits",
        spectrum="results/{config_name}/spectral-fit/{irf_label}/{config_name}-{irf_label}-source-flux-chart.dat",
    output:
        directory("results/{config_name}/{obs_id}/psf/{irf_label}/{config[psf_simulator]}")
    log: 
        "logs/{config_name}/{obs_id}/{config_name}-{obs_id}-{irf_label}-simulate-psf.log"
    conda:
        "../envs/ciao-4.15.yaml"
    params:
        args = get_simulate_psf_args
    shell:
        "simulate_psf infile={input.infile} outroot={output} spectrum={input.spectrum} {params.args}"