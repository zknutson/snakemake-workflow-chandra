rule fit_spectra:
    output:
        "test.txt"
    log:
        notebook="results/notebooks/fit-spectra.ipynb"
    notebook:
        "../notebooks/fit-spectra.ipynb"