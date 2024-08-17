# TWRCab_2_LineString

This repository contains scripts designed to convert `Polygon` and `MultiPolygon` geometries in CRC Tower-CAB GeoJSON files into `LineString` and `MultiLineString` geometries to be used in STARS and ERAM windows. The conversion process ensures that all polygons are accurately represented as lines, including handling any interior boundaries (holes) as part of the line features.

I have no plans to create a converter for ASDEX geojsons.

## Files in the Repository

- **`TWRCab_2_LineString.py`**:
  - A Python script that processes a GeoJSON file by converting `Polygon` and `MultiPolygon` geometries into `LineString` and `MultiLineString` geometries. The script also clears all feature properties during the conversion process to ensure the output is clean.
  - The script now also supports optional additional arguments for customizing the output:
    - `bcg`: Brightness Control Group (integer between 1 and 40).
    - `filters`: Comma-separated list of integers (e.g., `1,8,10,32`), with each integer between 1 and 40.
    - `style`: Line style, one of `solid`, `shortDashed`, `longDashed`, `longDashShortDash`.
    - `thickness`: Line thickness (integer between 1 and 3).
  - If these optional arguments are provided, a custom feature is added to the beginning of the feature collection in the output GeoJSON file.

- **`Run_TWRCab_2_LineString.bat`**:
  - A Windows batch script that automates the execution of the Python script.
  - Checks for the required Python environment and dependencies, prompts the user to select input and output directories, and processes all `.geojson` files in the selected input directory.
  - Now supports passing additional optional arguments to the Python script, ensuring no spaces or special characters are required for the `filters` argument.

## Requirements

- **Python**: Ensure Python is installed on your system. Download it from [python.org](https://www.python.org/downloads/).
- **Python Libraries**:
  - `shapely`
  - `json` (included in Python standard library)
  - `geojson` (optional, but included in the batch script for future use)

Install the required Python libraries using pip (the .bat file does this for you):

```bash
python -m pip install shapely geojson
```

## Usage

1. Download all of your CAB geojson files into a single directory.
2. Download the Run_TWRCab_2_LineString.bat and TWRCab_2_LineString.py (ensure they are in the same directory as each other).
3. Run the Run_TWRCab_2_LineString.bat file and follow prompts.

## Optional Arguments

When running the Python script directly, you can pass the following optional arguments after the input and output file paths:

```bash
python TWRCab_2_LineString.py input.geojson output.geojson 20 1,8,10,32 solid 2
```

- **BCG:** An integer between 1 and 40.
- **Filters:** A comma-separated list of integers between 1 and 40 (e.g., 1,8,10,32).
- **Style:** `solid`, `shortDashed`, `longDashed`, `longDashShortDash`.
- **Thickness:** An integer between 1 and 3.

## Notes

- Although this script will convert the runway centerlines and other like-markings, it doesn't display very well on the ERAM window. It is suggested to import the converted file into a tool like QGIS and remove excessive lines.
- Support for this script will be very limited, so make a backup of your current airport diagram (non-CAB) files and test these converted files prior to replacing them.
  - If past experience serves as any kind of indicator for what is to come, some of you have some very strange CAB files with weird configurations that seem to just work enough to get by, but my script may not handle your custom type:MyLineString-I_Like_Pancakes configurations.
