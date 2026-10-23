"""Run the Android integration test and collect original Flutter screenshots.
Requires Python 3, Flutter and a running emulator. No third-party Python packages.
"""
from pathlib import Path
import os
import shutil
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parent.parent
ADB = Path(os.environ['LOCALAPPDATA']) / 'Android/Sdk/platform-tools/adb.exe'
PACKAGE = 'com.comuni.comuni_social'
OUTPUT = ROOT / 'docs/screenshots'
OUTPUT.mkdir(parents=True, exist_ok=True)
FLUTTER = shutil.which('flutter')
collected = set()
with (ROOT / 'docs/integration-test.log').open('w', encoding='utf-8') as log:
    process = subprocess.Popen([FLUTTER, 'test', 'integration_test/app_test.dart',
        '-d', 'emulator-5554', '--reporter', 'expanded'], cwd=ROOT,
        stdout=log, stderr=subprocess.STDOUT)
    while process.poll() is None:
        try:
            base = [str(ADB), 'exec-out', 'run-as', PACKAGE]
            files = subprocess.check_output(base + ['ls', 'app_flutter'],
                stderr=subprocess.DEVNULL, timeout=5).decode().split()
            for name in files:
                if name.endswith('.png') and name not in collected:
                    data = subprocess.check_output(base + ['cat', 'app_flutter/' + name], timeout=10)
                    if data.startswith(b'\x89PNG\r\n\x1a\n'):
                        (OUTPUT / name).write_bytes(data)
                        collected.add(name)
                        print('Captured', name, flush=True)
        except (subprocess.SubprocessError, OSError):
            pass  # The app is briefly unavailable during install/restart.
        time.sleep(1)
print('Captured', len(collected), 'screens. Test exit code:', process.returncode)
sys.exit(process.returncode)
