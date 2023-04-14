from pathlib import Path

import numpy as np
from astropy.io import fits
from astropy.table import Table
from astropy.wcs import WCS


def compute_exposure_simple(
    filename_counts, filename_exposure, filename_oif, filename_oif_ref
):
    """Compute exposure simple"""
    exposure_ref = Table.read(filename_oif_ref).meta["EXPOSURE"]
    value = Table.read(filename_oif).meta["EXPOSURE"]

    header = fits.getheader(filename_counts)

    shape = header["NAXIS2"], header["NAXIS1"]
    data = value * np.ones(shape) / exposure_ref
    hdu = fits.PrimaryHDU(data=data, header=WCS(header).to_header())

    hdulist = fits.HDUList([hdu])

    hdulist.writeto(filename_exposure)


compute_exposure_simple(
    filename_counts=snakemake.input.filename_counts,
    filename_exposure=snakemake.output.filename_exposure,
    filename_oif=snakemake.input.filename_oif,
    filename_oif_ref=snakemake.input.filename_oif_ref,
)
