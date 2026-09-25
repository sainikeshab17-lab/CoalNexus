# CoalNexus

AI-powered smart governance and compliance monitoring for coal mines.

## Milestone 7: Synchronization and Offline-First Architecture

CoalNexus implements a robust offline-first architecture ensuring seamless operation in remote mine sites with intermittent connectivity.

### Core Architecture

- **Local-First**: All data is primarily stored in a local Drift (SQLite) database.
- **Outbox Pattern**: Mutations (CREATE, UPDATE) are enqueued in a `SyncQueue` and processed when the device is online.
- **Idempotency**: Every sync operation includes a unique `operation_id` (`op_${localId}_${localVersion}`) allowing safe retries without duplication.
- **Conflict Resolution**: Deterministic conflict resolution using `local_version`. The backend rejects stale updates with a `409 Conflict` response.

### Sync Workflow

1.  **Local Operation**: User performs an action (e.g., creates an inspection).
2.  **Persistence**: Data is saved to the local database immediately.
3.  **Queueing**: A sync task is added to the `SyncQueue`.
4.  **Processing**: `SyncProcessor` detects connectivity and attempts to push pending items to the FastAPI backend.
5.  **Reconciliation**: Upon successful creation, the backend provides a `serverId`. The mobile app reconciles this by updating the local record and all related local references (e.g., Findings linked to an Inspection).
6.  **Conflict Handling**: If the server has a newer version of the record, it returns `409 Conflict`. The app preserves the local state and marks the queue item for manual or automatic resolution (currently marked as `SyncStatus.conflict`).

### Backend Integration

The backend is built with FastAPI and SQLAlchemy, providing:
- Structured `409 Conflict` responses with `current_server_obj`.
- Idempotent processing of operations.
- Relationship mapping between local and server IDs.

### Development & Testing

#### Mobile (Flutter)
- **Analyze**: `flutter analyze`
- **Test**: `flutter test`
- **Build**: `flutter build apk --release`

#### Backend (Python)
- **Setup**: `pip install -r requirements.txt`
- **Run**: `uvicorn app.main:app --reload`
- **Test**: `python -m pytest`

### Demonstration Steps (Offline -> Online)

1.  Enable Airplane Mode or disconnect from the internet.
2.  Perform an inspection or report a violation in the app.
3.  Observe the "PENDING SYNC" status in the status overlay.
4.  Reconnect to the internet.
5.  The app automatically starts syncing (status changes to "SYNCING...").
6.  Status changes to "ONLINE" once all items are processed.
7.  Verify data availability on the backend dashboard.
