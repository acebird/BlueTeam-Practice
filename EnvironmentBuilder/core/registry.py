import json
from pathlib import Path

class VulnRegistry:
    def __init__(self, vulns_dir="vulns"):
        self.vulns_dir = Path(vulns_dir)
        self.vulns = {}

    def load(self):
        for vuln_dir in self.vulns_dir.iterdir():
            meta_file = vuln_dir / "meta.json"
            if meta_file.exists():
                with open(meta_file) as f:
                    meta = json.load(f)
                self.vulns[meta["id"]] = {
                    "meta": meta,
                    "path": vuln_dir
                }

    def get(self, vuln_id):
        return self.vulns[vuln_id]
