import json
import os
import sys
from shapely.geometry import shape, mapping, Polygon, LineString, MultiLineString
from shapely.ops import unary_union

def process_geojson(input_geojson, bcg=None, filters=None, style=None, thickness=None):
    features = []

    # If all optional arguments are provided, add the custom feature first
    if bcg is not None and filters is not None and style is not None and thickness is not None:
        custom_feature = {
            "type": "Feature",
            "geometry": {"type": "Point", "coordinates": [90.0, 180.0]},
            "properties": {
                "isLineDefaults": True,
                "bcg": bcg,
                "filters": filters,  # filters is already a list
                "style": style,
                "thickness": thickness
            }
        }
        features.append(custom_feature)
    
    for feature in input_geojson['features']:
        geom = feature['geometry']
        
        # Check if the geometry is None and skip if so
        if geom is None:
            print(f"Warning: Skipping feature with None geometry: {feature}")
            continue
        
        geom = shape(geom)
        
        if geom.geom_type == 'Polygon':
            # Convert Polygon to LineString including the exterior and interiors
            exterior = LineString(geom.exterior.coords)
            interiors = [LineString(interior.coords) for interior in geom.interiors]
            new_geom = MultiLineString([exterior] + interiors) if interiors else exterior
            feature['geometry'] = mapping(new_geom)
        
        elif geom.geom_type == 'MultiPolygon':
            # Convert MultiPolygon to MultiLineString
            lines = []
            for polygon in geom.geoms:
                exterior = LineString(polygon.exterior.coords)
                interiors = [LineString(interior.coords) for interior in polygon.interiors]
                lines.append(exterior)
                lines.extend(interiors)
            feature['geometry'] = mapping(MultiLineString(lines))
        
        # Clear properties
        feature['properties'] = {}
        features.append(feature)
    
    return {
        "type": "FeatureCollection",
        "features": features
    }

def main(input_file, output_file, *args):
    # Check if additional arguments are provided
    if len(args) not in [0, 4]:
        print("Error: You must provide either no additional arguments or exactly 4 additional arguments.")
        sys.exit(1)
    
    bcg = filters = style = thickness = None
    
    if len(args) == 4:
        # Validate bcg
        try:
            bcg = int(args[0])
            if not (1 <= bcg <= 40):
                raise ValueError
        except ValueError:
            print("Error: 'bcg' must be an integer between 1 and 40.")
            sys.exit(1)
        
        # Validate filters (expecting a comma-separated string like "1,8,10,32")
        try:
            filters = [int(f) for f in args[1].split(',')]
            if not all(1 <= f <= 40 for f in filters):
                raise ValueError
        except ValueError:
            print("Error: 'filters' must be a comma-separated list of integers between 1 and 40.")
            sys.exit(1)
        
        # Validate style
        style = args[2]
        if style not in ["solid", "shortDashed", "longDashed", "longDashShortDash"]:
            print("Error: 'style' must be one of 'solid', 'shortDashed', 'longDashed', 'longDashShortDash'.")
            sys.exit(1)
        
        # Validate thickness
        try:
            thickness = int(args[3])
            if not (1 <= thickness <= 3):
                raise ValueError
        except ValueError:
            print("Error: 'thickness' must be an integer between 1 and 3.")
            sys.exit(1)

    # Load the GeoJSON file
    with open(input_file, 'r') as f:
        geojson_data = json.load(f)
    
    # Process the GeoJSON to convert POLYGONs to LINESTRINGs and add the custom feature if necessary
    processed_geojson = process_geojson(geojson_data, bcg, filters, style, thickness)
    
    # Add "_converted" to the output file name before the extension
    base_name, ext = os.path.splitext(output_file)
    output_file = f"{base_name}_converted{ext}"
    
    # Save the modified GeoJSON to a new file without pretty-print (single line)
    with open(output_file, 'w') as f:
        json.dump(processed_geojson, f, separators=(',', ':'))

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python TWRCab_2_LineString.py <input_file_path> <output_file_path> [bcg] [filters] [style] [thickness]")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    
    main(input_file, output_file, *sys.argv[3:])
