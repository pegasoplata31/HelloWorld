"""Prepare the generated Android platform and decode the bundled source asset."""
import base64
import hashlib
from pathlib import Path
import shutil
import subprocess
import tempfile

root = Path(__file__).resolve().parents[1]
logo = base64.b64decode((root / "assets/logo.png.base64").read_text(), validate=True)
if hashlib.sha256(logo).hexdigest() != "b270737b8331420847564da2351873fc45d25f90bd9404eaa29302fdb8a169ff":
    raise ValueError("El logo no coincide con el original")
(root / "assets/logo.png").write_bytes(logo)

flutter = shutil.which("flutter")
if not flutter:
    raise RuntimeError("Instala Flutter y agrégalo al PATH")
android = root / "android"
if not android.exists():
    with tempfile.TemporaryDirectory(prefix="beyond-words-") as temp:
        generated = Path(temp) / "beyond_words"
        subprocess.run([flutter, "create", "--platforms=android", "--org", "com.beyondword", "--project-name", "beyond_words", str(generated)], check=True)
        shutil.copytree(generated / "android", android)

gradle = android / "app/build.gradle.kts"
content = gradle.read_text()
for key, value in [("compileSdk", 36), ("targetSdk", 34), ("minSdk", 23)]:
    import re
    content, count = re.subn(rf"\b{key}\s*=\s*(?:flutter\.{key}Version|\d+)", f"{key} = {value}", content)
    if count != 1:
        raise RuntimeError(f"No se pudo configurar {key}")
gradle.write_text(content)
shutil.copyfile(root / "tool/AndroidManifest.xml", android / "app/src/main/AndroidManifest.xml")
