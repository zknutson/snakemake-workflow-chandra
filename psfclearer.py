#want to go through a given observation and clear the PSF files from it.
import os
import sys
import shutil

dir = "results/" + str(sys.argv[1])
if not os.path.exists(dir):
    print("Directory does not exist.")
    sys.exit(1)
os.chdir(dir)

#for all of the directories not named "spectral-fit":
for subdir in os.listdir("."):
    if os.path.isdir(subdir) and subdir != "spectral-fit":
        print("Clearing PSF files in " + subdir)
        #remove the "psf" directory if it exists, and of course all of the files in it
        psf_dir = os.path.join(subdir, "psf")
        if os.path.exists(psf_dir):
            shutil.rmtree(psf_dir)
            print("Removed " + psf_dir)
        maps_dir = os.path.join(subdir, "maps")
        if os.path.exists(maps_dir):
            #now remove any files with the name "psf.fits" in the name
            for file in os.listdir(maps_dir):
                if "psf.fits" in file:
                    file_path = os.path.join(maps_dir, file)
                    os.remove(file_path)
                    print("Removed " + file_path)