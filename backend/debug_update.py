import sys
import os
import uuid
import traceback
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.database import SessionLocal
from app.routers.routers import create_mine, create_inspection, update_inspection
from app.schemas import models as schemas

def debug():
    db = SessionLocal()
    try:
        print("Testing create_mine...")
        mine_local_id = "debug_mine_" + str(uuid.uuid4())[:8]
        mine_in = schemas.MineCreate(
            local_id=mine_local_id,
            name="Debug Mine",
            mine_code="DM_" + str(uuid.uuid4())[:4],
            latitude=0.0,
            longitude=0.0,
            status=schemas.MineStatus.active,
            local_version=1,
            operation_id="op_mine_" + str(uuid.uuid4())[:8]
        )
        mine_obj = create_mine(mine_in, db)

        print("Testing create_inspection...")
        insp_local_id = "debug_insp_" + str(uuid.uuid4())[:8]
        insp_in = schemas.InspectionCreate(
            local_id=insp_local_id,
            mine_id=mine_local_id,
            inspector_id="insp_debug",
            status=schemas.InspectionStatus.draft,
            category="safety",
            local_version=1,
            operation_id="op_insp_" + str(uuid.uuid4())[:8]
        )
        insp_obj = create_inspection(insp_in, db)
        print(f"Inspection created: {insp_obj.id}")

        print("Testing update_inspection...")
        insp_upd = schemas.InspectionCreate(
            local_id=insp_local_id,
            mine_id=mine_local_id,
            inspector_id="insp_debug",
            status=schemas.InspectionStatus.inProgress,
            category="safety",
            local_version=2,
            operation_id="op_insp_upd_" + str(uuid.uuid4())[:8]
        )
        updated_obj = update_inspection(insp_obj.id, insp_upd, db)
        print(f"Inspection updated successfully: {updated_obj.status}")

    except Exception as e:
        print("\n--- ERROR DETECTED ---")
        traceback.print_exc()
    finally:
        db.close()

if __name__ == "__main__":
    debug()
