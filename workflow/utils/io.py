import logging
from pathlib import Path

import numpy as np
import yaml
from astropy import units as u
from astropy.io import fits
from astropy.table import Table
from astropy.wcs import WCS
from gammapy.data import EventList
from gammapy.maps import MapAxis, RegionGeom, RegionNDMap
from gammapy.maps.utils import edges_from_lo_hi

log = logging.getLogger(__name__)

__all__ = [
    "read_spectrum_chart",
    "read_event_list_chandra",
    "ChandraFileIndex",
]

YAML_DUMP_KWARGS = {
    "sort_keys": False,
    "indent": 4,
    "width": 80,
    "default_flow_style": False,
}


def wcs_from_header_chandra(header, x_col=11):
    """Create WCS from event file header

    Parameters
    ----------
    header : `~astropy.io.fits.Header`
        FITS header

    Returns
    -------
    wcs : `~astropy.wcs.WCS`
        WCS object
    """
    y_col = x_col + 1
    wcs = WCS(naxis=2)
    wcs.wcs.crpix = [header[f"TCRPX{x_col}"], header[f"TCRPX{y_col}"]]
    wcs.wcs.cdelt = [header[f"TCDLT{x_col}"], header[f"TCDLT{y_col}"]]
    wcs.wcs.crval = [header[f"TCRVL{x_col}"], header[f"TCRVL{y_col}"]]
    wcs.wcs.ctype = [header[f"TCTYP{x_col}"], header[f"TCTYP{y_col}"]]
    return wcs


def read_spectrum_chart(filename):
    """Read CHART spectrum"""
    data = Table.read(filename, format="ascii")

    edges = edges_from_lo_hi(data["col1"], data["col2"])
    axis = MapAxis.from_edges(edges=edges, name="energy", unit="keV", interp="log")

    geom = RegionGeom.create(region=None, axes=[axis])
    spectrum = RegionNDMap.from_geom(geom=geom)
    spectrum.data = data["col3"]
    return spectrum


def convert_spectrum_chart_to_rdb(filename, overwrite=False):
    """Convert chart spectrum to rdb format"""
    data = Table.read(filename, format="ascii")
    data.rename_column("col1", "emin")
    data.rename_column("col2", "emax")
    data.rename_column("col3", "flux")

    filename_rdb = Path(filename).with_suffix(".rdb")

    log.info(f"Writing {filename_rdb}")
    data.write(filename_rdb, format="ascii.rdb", overwrite=overwrite)


def read_event_list_chandra(filename, hdu="EVENTS"):
    """Read event list"""
    hdu = fits.open(filename)[hdu]
    table = Table.read(hdu)

    wcs = wcs_from_header_chandra(header=hdu.header)

    for colname in table.colnames:
        table.rename_column(colname, colname.upper())

    ra, dec = wcs.wcs_pix2world(table["X"], table["Y"], 1)
    table["RA"] = ra * u.deg
    table["DEC"] = dec * u.deg

    mjd = table.meta["MJDREF"]
    mjd_int = np.floor(mjd).astype(np.int64)
    table.meta["MJDREFI"] = mjd_int
    table.meta["MJDREFF"] = mjd - mjd_int
    table.meta["TIMESYS"] = "tt"  # TODO: not sure tt is correct here...
    return EventList(table=table)


def sherpa_parameter_to_dict(par):
    """Sherpa parameter to dict"""
    data = {}
    data["name"] = str(par.name)
    data["value"] = float(par.val)
    data["min"] = float(par.min)
    data["max"] = float(par.max)
    data["frozen"] = bool(par.frozen)
    data["unit"] = str(par.units)
    return data


def sherpa_model_to_dict(model):
    """Convert Sherpa model to dict"""
    data = {
        "name": model.name,
        "type": model.type,
    }

    if model.type == "binaryopmodel":
        data["operator"] = str(model.opstr)
        data["lhs"] = sherpa_model_to_dict(model.lhs)
        data["rhs"] = sherpa_model_to_dict(model.rhs)
        return data

    parameters = []

    for par in model.pars:
        data_par = sherpa_parameter_to_dict(par)
        parameters.append(data_par)

    data["parameters"] = parameters
    return data


def write_sherpa_model_to_yaml(model, filename, overwrite=False):
    """Write Sherpa model to YAML file"""
    data = sherpa_model_to_dict(model)

    if Path(filename).exists() and not overwrite:
        raise IOError(f"File exists: {filename}")

    with open(filename, "w") as fh:
        yaml.dump(data, fh, **YAML_DUMP_KWARGS)

    log.info(f"Writing {filename}")
