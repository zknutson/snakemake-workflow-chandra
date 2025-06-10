rule find_and_copy_asolfile:
    input:
        repro_done="results/{config_name}/{obs_id}/repro/repro.done",
    output:
        filename_asol="results/{config_name}/{obs_id}/repro/simulate-psf-asol-{obs_id}.fits"
    run:
        from pathlib import Path
        import shutil

        path =  Path(f"results/{wildcards.config_name}/{wildcards.obs_id}/repro/")

        instrument = config_obj.obs_info_table.loc[wildcards.obs_id]["INSTR"]

        if "ACIS" in instrument:
            filename = f"acisf{int(wildcards.obs_id):05d}_asol1.lis"
        else:
            filename =  f"hrcf{int(wildcards.obs_id):05d}_asol1.lis"

        with (path / filename).open("r") as f:
            asolfile = f.readline().strip()

        shutil.copy(asolfile, output.filename_asol)




        
       