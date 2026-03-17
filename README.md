# Offline-DataSet split upload

This repository stores split dataset parts.

Each original .npz file is split into 95 MiB chunks to satisfy GitHub's normal file-size limit.

Reconstruction:
1. Download one folder completely.
2. Run merge_parts.ps1 -PartDir <folder-path>.
3. Verify checksum against that folder's manifest.json.

Directory layout:
- data/<dataset-name>/
  - *.part0000, *.part0001, ...
  - manifest.json
