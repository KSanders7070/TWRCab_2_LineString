import json
import os
import sys
from shapely.geometry import shape, mapping, Polygon, LineString, MultiLineString
from shapely.ops import unary_union

def process_geojson(input_geojson):
    features = []
    
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

def main(input_file, output_file):
    # Load the GeoJSON file
    with open(input_file, 'r') as f:
        geojson_data = json.load(f)
    
    # Process the GeoJSON to convert POLYGONs to LINESTRINGs
    processed_geojson = process_geojson(geojson_data)
    
    # Add "_converted" to the output file name before the extension
    base_name, ext = os.path.splitext(output_file)
    output_file = f"{base_name}_converted{ext}"
    
    # Save the modified GeoJSON to a new file without pretty-print (single line)
    with open(output_file, 'w') as f:
        json.dump(processed_geojson, f, separators=(',', ':'))

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python TWRCab_2_LineString.py <input_file_path> <output_file_path>")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    
    main(input_file, output_file)
