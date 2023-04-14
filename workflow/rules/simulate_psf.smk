def get_simulate_psf_args(wildcards):
    config_psf = config_obj.irfs[wildcards.irf_label].psf
    args = config_psf.to_cmd_args()
    return args

rule simulate_psf:
    input:
        infile="results/{config_name}/{obs_id}/events/{config_name}-{obs_id}-events.fits",
        spectrum="results/{config_name}/spectral-fit/{irf_label}/{config_name}-{irf_label}-source-flux-chart.dat",
    output:
        "results/{config_name}/{obs_id}/psf/{irf_label}/{psf_simulator}/{psf_simulator}.psf"
    log: 
        "logs/{config_name}/{obs_id}/{config_name}-{obs_id}-{irf_label}-{psf_simulator}-simulate-psf.log"
    conda:
        "../envs/ciao-4.15.yaml"
    params:
        args = get_simulate_psf_args,
        outroot = lambda wildcards, output: output[0].replace(".psf", "")
    shell:
        "export MARX_ROOT=$CONDA_PREFIX;"
        "simulate_psf infile={input.infile} outroot={params.outroot} spectrum={input.spectrum} keepiter=yes {params.args}"
