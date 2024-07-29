import numpy as np
from scipy.ndimage import map_coordinates
from astropy.io import fits


def compute_cms_pix(data):
    """Compute the center of mass of an image in pix coordinates"""
    x, y = np.indices(data.shape)
    A = data.sum()
    x_cms = (x * data).sum() / A
    y_cms = (y * data).sum() / A
    return x_cms, y_cms


def shift_image(data, x_ref, y_ref):
    """Shift image such that the CMS ist at (x_ref, y_ref)"""
    x_coord, y_coord = np.indices(data.shape)
    x_cms, y_cms = compute_cms_pix(data)
    dx, dy = x_cms - x_ref, y_cms - y_ref
    return map_coordinates(data, [x_coord + dx, y_coord + dy], order=1, mode="constant", cval=0)


def normalize_image(data):
    """Normalize image"""
    return data / data.sum()


hdu = fits.open(snakemake.input.filename)[0]
data = hdu.data

x_ref = (data.shape[1] - 1) / 2.
y_ref = (data.shape[0] - 1) / 2.

data = shift_image(data, x_ref=x_ref, y_ref=y_ref)
data = normalize_image(data)
hdu.data = data
hdu.writeto(snakemake.output.filename, overwrite=True)