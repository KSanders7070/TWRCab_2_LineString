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

## Usage Options

### Using the Batch Script

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/KSanders7070/TWRCab_2_LineString.git
   cd TWRCab_2_LineString
   ```

2. **Run the Batch Script**:
   - Double-click on the `Run_TWRCab_2_LineString.bat` file or run it from the command line:

     ```bash
     Run_TWRCab_2_LineString.bat
     ```

3. **Select Input and Output Directories**:
   - The script will prompt you to select the input directory containing `.geojson` files and the output directory where the converted files will be saved.

4. **Conversion Process**:
   - The batch script will process all `.geojson` files in the selected input directory, converting all `Polygon` and `MultiPolygon` geometries to `LineString` and `MultiLineString` geometries, respectively.
   - The output files will be saved in the selected output directory with `_converted` appended to the original filenames.

### Directly Using the Python Script

If you prefer to run the Python script directly, you can do so with the following command:

```bash
python TWRCab_2_LineString.py <input_file_path> <output_file_path>
```

- Replace `<input_file_path>` with the path to your GeoJSON file.
- Replace `<output_file_path>` with the desired path for the converted file.
