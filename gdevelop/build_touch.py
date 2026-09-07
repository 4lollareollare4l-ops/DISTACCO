import json
from pathlib import Path

root = Path(__file__).resolve().parent
base = root / "game-fixed2.json"
controls = root / "touch-controls.js"
out = root / "game-touch.json"

project = json.loads(base.read_text(encoding="utf-8"))
project["properties"]["version"] = "0.1.3"
project["properties"]["description"] = "DISTACCO — prototype 0.1.3 with touch controls."
layout = project["layouts"][0]
layout["title"] = "DISTACCO — Touch Prototype 0.1.3"
layout["events"][0]["inlineCode"] = controls.read_text(encoding="utf-8").splitlines()

out.write_text(json.dumps(project, ensure_ascii=False, separators=(",", ":")), encoding="utf-8")
print(f"wrote {out}")
