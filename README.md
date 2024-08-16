# TWRCab_2_LineString

This repository contains scripts designed to convert `Polygon` and `MultiPolygon` geometries in CRC Tower-CAB GeoJSON files into `LineString` and `MultiLineString` geometries to be used in STARS and ERAM windows. The conversion process ensures that all polygons are accurately represented as lines, including handling any interior boundaries (holes) as part of the line features.

## Files in the Repository

- **`TWRCab_2_LineString.py`**:
  - A Python script that processes a GeoJSON file by converting `Polygon` and `MultiPolygon` geometries into `LineString` and `MultiLineString` geometries. The script also clears all feature properties during the conversion process to ensure the output is clean.

- **`Run_TWRCab_2_LineString.bat`**:
  - A Windows batch script that automates the execution of the Python script.
  - Checks for the required Python environment and dependencies, prompts the user to select input and output directories, and processes all `.geojson` files in the selected input directory.

## Requirements

- **Python**: Ensure Python is installed on your system. Download it from [python.org](https://www.python.org/downloads/).
- **Python Libraries**:
  - `shapely`
  - `json` (included in Python standard library)
  - `geojson`

Install the required Python libraries using pip (the .bat file does this for you):

```bash
python -m pip install shapely geojson
```

## Usage

1. Download all of your CAB geojson files into a single directory
2. Download the Run_TWRCab_2_LineString.bat and TWRCab_2_LineString.py (ensure they are in the same directory as each other)
3. Run the Run_TWRCab_2_LineString.bat file and follow prompts
