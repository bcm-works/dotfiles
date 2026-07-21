# Media organisation helper
#
# ----
#
# Originally forked from https://gist.github.com/cliss/6854904
#
# Organises all media files (defined by "mediaFileExtensions") in a source directory in to a subdirectory of the destination directory named like:
#   2020\01 Jan\
#
# Assumes that the source directory doesn't have any sub-directories.
#
# The source and destination directories are defined in "photos.env".
#
# Setup:
#   1. Configure your photo directories:
#       cp --update=none .media-organise.sample.env .media-organise.env
#       vim .media-organise.env
#   2. Run the script:
#       photomgmt
#   3. Optional - Configure an alias command:
#       echo "alias photomgmt='python /path/to/this-file.py'" >> ~/.bash_aliases
#       source ~/.bash_aliases
#
# Requirements:
#  - For Windows 11
#   - Python 3: https://www.python.org/downloads/
#   - ExifRead: https://pypi.org/project/ExifRead/
#   - Python-dotenv: https://pypi.org/project/python-dotenv/
#  - For Ubuntu
#   - sudo apt install -y python-is-python3 python3-exifread python3-dotenv pipx
# 	- pipx ensurepath
#
import os
import os.path
import shutil
import sys
from datetime import datetime

import exifread
from dotenv import dotenv_values

### Functions


def photoDate(f):
    "Return the date/time on which the given photo was taken."

    try:
        img = open(f, "rb")
        imgTags = exifread.process_file(img)
        return datetime.strptime(
            str(imgTags["EXIF DateTimeOriginal"]), "%Y:%m:%d %H:%M:%S"
        )
    except:
        # Default to using today's date if the required image properties can't be found
        return datetime.now()


### Main program

# Get the date details
now = datetime.now()
yearNow = now.year

# Load the configuration values from the ENV file
script_file_path = os.path.dirname(__file__)
config = dotenv_values("%s/.organise-photos.env" % script_file_path)

# Where the media files are and where they're going
sourceDir = "%s" % (config["PHOTOMGMT_SOURCE_DIR"])
destDir = "%s" % (config["PHOTOMGMT_DEST_DIR"])
errorDir = "%s" % (config["PHOTOMGMT_ERROR_DIR"])

# Create the required directories
if not os.path.exists(destDir):
    os.makedirs(destDir)
if not os.path.exists(errorDir):
    os.makedirs(errorDir)

# Set the filename format for the moved files
fmt = "%Y-%m-%d %H-%M-%S"

# Will store details of any problem files
problems = []

# Get all the media files in the source folder
mediaFileExtensions = [
    ".bmp",
    ".BMP",
    ".DNG",
    ".dng",
    ".gif",
    ".GIF",
    ".jpg",
    ".JPG",
    "jpeg",
    "JPEG",
    ".mov",
    ".MOV",
    ".mp4",
    ".MP4",
    ".png",
    ".PNG",
    "heic",
    "HEIC",
    "hevc",
    "HEVC",
]
photos = os.listdir(sourceDir)
photos = [x for x in photos if x[-4:] in mediaFileExtensions]

# Prepare to output as processing occurs
lastMonth = 0
lastYear = 0

# Copy photos into year and month subfolders
#  - Name the copies according to their timestamps, defaulting to today's date
#  - If more than one photo has the same timestamp, add suffixes ('a', 'b', etc) to the file names
for photo in photos:
    original = "%s/%s" % (sourceDir, photo)
    fileExtension = os.path.splitext(original)[1]
    suffix = "a"

    try:
        pDate = photoDate(original)
        yr = pDate.year
        mo = pDate.month

        # Generate the name of the sub-directory, in the style of "01 Jan" based on the photo's modified date
        moDirectory = "%s" % datetime.strftime(pDate, "%m %b")

        # Generate the new filename for the file
        newname = pDate.strftime(fmt)

        # Ensure the destination directory is created, in the style of "2020" > "01 Jan"
        thisDestDir = destDir + "/%04d/%s" % (yr, moDirectory)
        if not os.path.exists(thisDestDir):
            os.makedirs(thisDestDir)

        # Manage naming of files if many exists with the same creation date
        duplicate = thisDestDir + "/%s%s" % (newname, fileExtension)
        while os.path.exists(duplicate):
            newname = pDate.strftime(fmt) + suffix
            duplicate = destDir + "/%04d/%s/%s%s" % (
                yr,
                moDirectory,
                newname,
                fileExtension,
            )
            suffix = chr(ord(suffix) + 1)

        # Move the file to the destination directory
        shutil.move(original, duplicate)
    except Exception:
        # Something went wrong, move the file to the error directory
        shutil.move(original, "%s/%s" % (errorDir, photo))
        problems.append(photo)
    except:
        sys.exit("Cancelled")

# Output a report of any problem files
if len(problems) > 0:
    print("Problem files:")
    print("%s" % problems)
    print("These can be found in: %s" % errorDir)
