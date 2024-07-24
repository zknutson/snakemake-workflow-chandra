import sys
from pathlib import Path

from astropy.table import Table

if __name__ == "__main__":
    filename = Path(str(snakemake.input.filename_spectrum))
    table = Table.read(
        filename,
        format="ascii.commented_header",
        delimiter=" ",
        guess=False,
        header_start=1,
    )

    table["spectrum"] = table["spectrum"] / table["spectrum"].sum()

    filename = filename.parent / filename.name.replace("chart.dat", "weights.csv")
    table.write(filename, format="ascii.no_header")
