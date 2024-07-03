import sys
from pathlib import Path

from astropy.table import Table

if __name__ == "__main__":
    filename = Path(sys.argv[1])
    table = Table.read(filename, format="ascii.csv")
    print(table)
    1 / 0

    table["weights"] = table["flux"] / table["flux"].sum()

    filename = filename.with_suffix("-weights.csv")
    table.write(filename, format="ascii.csv")
