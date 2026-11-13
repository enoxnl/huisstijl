#!/usr/bin/env bash
# Ubuntu: install for the current user, without sudo.
set -euo pipefail
if ! command -v python3 >/dev/null 2>&1; then
    echo 'Python 3 ontbreekt. Installeer eerst: sudo apt install python3 fontconfig ca-certificates' >&2
    exit 1
fi
python3 - "$@" <<'PYTHON'
import argparse
import hashlib
import io
import os
from pathlib import Path
import shutil
import subprocess
import sys
import urllib.request
import zipfile

URL = 'https://download.microsoft.com/download/8/6/0/860a94fa-7feb-44ef-ac79-c072d9113d69/Microsoft%20Aptos%20Fonts.zip'
SHA256 = '6528fd120e719a9f985e94214eca6887d1653b88456916a792a630b02e95b025'
FONTS = ['Aptos.ttf', 'Aptos-Bold.ttf', 'Aptos-Italic.ttf',
         'Aptos-Bold-Italic.ttf', 'Aptos-Display-Bold.ttf']
LICENSE = 'Microsoft Aptos Fonts EULA.rtf'

def main():
    parser = argparse.ArgumentParser(description='Installeer de vijf Enox-fonts voor de huidige Ubuntu-gebruiker.')
    parser.add_argument('--dry-run', action='store_true', help='Controleer pakket en doelbestanden zonder installatie.')
    parser.add_argument('--package', type=Path, help='Gebruik het originele Microsoft ZIP-bestand voor offline installatie.')
    args = parser.parse_args()
    if sys.platform != 'linux':
        raise RuntimeError('Dit script is bedoeld voor Linux (Ubuntu).')
    if os.geteuid() == 0:
        raise RuntimeError('Voer dit script als normale gebruiker uit, zonder sudo.')
    if not args.dry_run and not shutil.which('fc-cache'):
        raise RuntimeError('fontconfig ontbreekt. Installeer eerst: sudo apt install fontconfig')
    data_home = Path(os.environ.get('XDG_DATA_HOME') or (Path.home() / '.local/share'))
    if not data_home.is_absolute():
        raise RuntimeError('XDG_DATA_HOME moet een absoluut pad zijn.')
    font_dir = data_home / 'fonts' / 'enox'
    license_dir = data_home / 'enox' / 'licenses'
    if args.package:
        package = args.package.read_bytes()
    else:
        print('Downloaden van Microsoft Aptos 4.40...')
        with urllib.request.urlopen(URL, timeout=60) as response:
            package = response.read()
    if hashlib.sha256(package).hexdigest() != SHA256:
        raise RuntimeError('SHA-256 wijkt af. Er is niets geinstalleerd. Controleer het Microsoft-pakket; omzeil de controle niet.')
    contents = {}
    with zipfile.ZipFile(io.BytesIO(package)) as archive:
        for name in FONTS + [LICENSE]:
            matches = [entry for entry in archive.infolist() if entry.filename.rsplit('/', 1)[-1] == name]
            if len(matches) != 1:
                raise RuntimeError('Geen uniek bestand in pakket: ' + name)
            contents[name] = archive.read(matches[0])
    # Validate every destination before writing; never replace a different font version.
    for name in FONTS:
        target = font_dir / name
        if target.is_symlink():
            raise RuntimeError('Doelbestand is een symbolische link: ' + str(target))
        if target.exists() and target.read_bytes() != contents[name]:
            raise RuntimeError('Andere fontversie aanwezig, niet overschreven: ' + str(target))
    print('Microsoft-pakket gecontroleerd. De meegeleverde Microsoft-licentie is van toepassing.')
    if args.dry_run:
        print('Proefcontrole geslaagd; geen bestanden of fontcache gewijzigd. Doel: ' + str(font_dir))
        return
    font_dir.mkdir(parents=True, exist_ok=True)
    for name in FONTS:
        target = font_dir / name
        if not target.exists():
            with target.open('xb') as stream:
                stream.write(contents[name])
            target.chmod(0o644)
        print('Beschikbaar: ' + name)
    license_dir.mkdir(parents=True, exist_ok=True)
    license_target = license_dir / LICENSE
    if license_target.is_symlink():
        raise RuntimeError('Licentiebestand is een symbolische link: ' + str(license_target))
    license_target.write_bytes(contents[LICENSE])
    subprocess.run(['fc-cache', '-f', str(font_dir)], check=True)
    print('Installatie gereed. Licentie: ' + str(license_target))
    print('Sluit LibreOffice en andere documenttoepassingen en open ze opnieuw.')

try:
    main()
except (OSError, RuntimeError, ValueError, zipfile.BadZipFile, subprocess.CalledProcessError) as error:
    print('Fout: ' + str(error), file=sys.stderr)
    sys.exit(1)
PYTHON
