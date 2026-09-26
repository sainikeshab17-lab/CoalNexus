import os
from sqlalchemy import create_engine, text
from dotenv import load_dotenv

load_dotenv()
db_url = os.getenv("DATABASE_URL")
engine = create_engine(db_url)

with engine.connect() as conn:
    print("PostGIS Version:", conn.execute(text("SELECT PostGIS_Version()")).scalar())
    
    print("\nMine Records:")
    results = conn.execute(text("SELECT mine_code, name, latitude, longitude, ST_AsText(location), ST_SRID(location) FROM mines")).fetchall()
    for r in results:
        print(f"Code: {r[0]}, Name: {r[1]}, Lat: {r[2]}, Lon: {r[3]}, Text: {r[4]}, SRID: {r[5]}")
        
    print("\nSpatial Index Check:")
    index_results = conn.execute(text("SELECT indexname, indexdef FROM pg_indexes WHERE tablename = 'mines'")).fetchall()
    for i in index_results:
        print(f"Index Name: {i[0]}, Definition: {i[1]}")
        
    print("\nDistance Query from WCL_UMRER:")
    # First get UMRER location text
    umrer = conn.execute(text("SELECT ST_AsText(location) FROM mines WHERE mine_code = 'WCL_UMRER'")).scalar()
    print("UMRER Location:", umrer)
    
    if umrer:
        dist_query = text("""
            SELECT mine_code, name, 
                   ST_Distance(location, (SELECT location FROM mines WHERE mine_code = 'WCL_UMRER')) AS distance_degrees,
                   ST_Distance(location::geography, (SELECT location::geography FROM mines WHERE mine_code = 'WCL_UMRER')) AS distance_meters
            FROM mines
            ORDER BY distance_meters;
        """)
        dist_results = conn.execute(dist_query).fetchall()
        for d in dist_results:
            print(f"Code: {d[0]}, Name: {d[1]}, Degrees: {d[2]}, Meters: {d[3]}")
            
        print("\nRadius Query within 100km (100000m) of WCL_UMRER:")
        radius_query = text("""
            SELECT mine_code, name,
                   ST_Distance(location::geography, (SELECT location::geography FROM mines WHERE mine_code = 'WCL_UMRER')) AS distance_meters
            FROM mines
            WHERE ST_DWithin(location::geography, (SELECT location::geography FROM mines WHERE mine_code = 'WCL_UMRER'), 100000)
            ORDER BY distance_meters;
        """)
        radius_results = conn.execute(radius_query).fetchall()
        for r in radius_results:
            print(f"Code: {r[0]}, Name: {r[1]}, Distance: {r[2]} meters")
