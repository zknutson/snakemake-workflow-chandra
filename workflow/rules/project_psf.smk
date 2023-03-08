def get_simulate_psf_args(wildcards):
    config_psf = config_obj.irfs[wildcards.irf_label].psf
    config_psf.simulator = "file"
    args = config_psf.to_cmd_args()
    print(args)
    return args

def get_psf_path(wildcards):
    path = f"results/{wildcards.config_name}/{wildcards.obs_id}/psf/{wildcards.irf_label}/{wildcards.psf_simulator}/{wildcards.psf_simulator}"    
    return path

def get_rayfile(wildcards):
    config_psf = config_obj.irfs[wildcards.irf_label].psf
    files = []
    
    for idx in range(config_psf.niter): 
        rayfile = f"results/{wildcards.config_name}/{wildcards.obs_id}/psf/{wildcards.irf_label}/{wildcards.psf_simulator}/{wildcards.psf_simulator}"
    
    return ",".join(files)

rule project_psf:
    input:
        infile="results/{config_name}/{obs_id}/events/{config_name}-{obs_id}-events.fits",
        rayfile=get_rayfile
    output:
        "results/{config_name}/{obs_id}/maps/{config_name}-{obs_id}-{irf_label}-{psf_simulator}-psf.fits"
    log: 
        "logs/{config_name}/{obs_id}/{config_name}-{obs_id}-{irf_label}-{psf_simulator}-psf.log"
    conda:
        "../envs/ciao-4.15.yaml"
    params:
        args = get_simulate_psf_args,
        psf_path = get_psf_path,
    shell:
        "export MARX_ROOT=$CONDA_PREFIX;"
        "simulate_psf infile={input.infile} outroot={params.psf_path} rayfile={input.rayfile} spectrum=none {params.args};"
        "mv {params.psf_path}/*.psf {output}"