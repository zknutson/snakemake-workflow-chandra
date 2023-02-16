from pathlib import Path

import numpy as np
from astropy.io import fits
from astropy.table import Table
from astropy.wcs import WCS

PATH = Path(__file__).parent.parent.parent / "data"


def compute_exposure_simple(filename_counts, filename_exposure, obs_id, obs_id_ref):
    """Compute exposure simple"""
    exposure_ref = Table.read(PATH / f"{obs_id_ref}" / "oif.fits").meta["EXPOSURE"]
    value = Table.read(PATH / f"{obs_id}" / "oif.fits").meta["EXPOSURE"]

    header = fits.getheader(filename_counts)

    shape = header["NAXIS2"], header["NAXIS1"]
    data = value * np.ones(shape) / exposure_ref
    hdu = fits.PrimaryHDU(data=data, header=WCS(header).to_header())

    hdulist = fits.HDUList([hdu])

    hdulist.writeto(filename_exposure)


compute_exposure_simple(
    filename_counts=snakemake.input[0],
    filename_exposure=snakemake.output[0],
    obs_id=snakemake.wildcards.obs_id,
    obs_id_ref=snakemake.config["obs_id_ref"],
)
