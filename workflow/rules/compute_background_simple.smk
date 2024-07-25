rule compute_background_simple:
    input:
        filename_events="results/{config_name}/{obs_id}/events/{config_name}-{obs_id}-events.fits",
        filename_counts="results/{config_name}/{obs_id}/maps/{config_name}-{obs_id}-counts.fits",
    output:
        filename_background="results/{config_name}/{obs_id}/maps/{config_name}-{obs_id}-background.fits",
    log: 
        "logs/{config_name}/{obs_id}/compute-background-simple.log"
    run:
        
        from astropy.io import fits
        from regions import Regions
        from pathlib import Path
        from astropy.table import Table

        counts = fits.getdata(input.filename_counts)
        header_counts = fits.getheader(input.filename_counts)
        events = Table.read(input.filename_events, hdu="EVENTS")

        with Path(config_obj.background_region_file).open("r") as fh:
            region_str = fh.read()
            regions_pix = Regions.parse(f"image;{region_str}", format="ds9")

        coords = PixCoord(x=events["x"], y=events["y"])

        region_union = regions_pix[0]
        for region in regions_pix[1:]:
            region_union = region_union.union(region)

        inside = region_union.contains(coords)

        bkg_level = np.ones(counts.shape) * inside.sum() / region_union.area * config["roi"]["bin_size"] ** 2

        background_hdu = fits.PrimaryHDU(data=bkg_level, header=header_counts)

        background_hdu.writeto(output.filename_background, overwrite=True)