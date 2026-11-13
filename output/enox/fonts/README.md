# Enox lettertypen

De Enox-huisstijl gebruikt de volgende lettertypen. De fontbestanden worden niet via deze repository verspreid:

- Aptos normaal, vet, cursief en vet cursief voor tekst.
- Aptos Display vet voor grote titels.

## Installeren op Windows

Voer vanuit de hoofdmap van de repository uit in PowerShell (Windows 10/11, PowerShell 5.1 of hoger):

```powershell
.\scripts\Install-EnoxFonts.ps1
```

Het script downloadt het originele Microsoft-pakket 4.40, controleert SHA-256 en installeert alleen de vijf benodigde fonts voor de huidige gebruiker. Administratorrechten zijn niet nodig. De fonts komen in `%LOCALAPPDATA%\Microsoft\Windows\Fonts`; de licentie wordt bewaard in `%LOCALAPPDATA%\Enox\Licenses`. Herstart daarna de Office-toepassingen. Als Windows de uitvoering van scripts blokkeert, volg dan het scriptbeleid van je organisatie.

Voor een controle zonder installatie (het pakket wordt wel gedownload):

```powershell
.\scripts\Install-EnoxFonts.ps1 -WhatIf
```

Voor offline installatie met het ongewijzigde Microsoft ZIP-bestand:

```powershell
.\scripts\Install-EnoxFonts.ps1 -PackagePath 'C:\Downloads\Microsoft Aptos Fonts.zip'
```

Opnieuw uitvoeren is mogelijk: identieke bestanden worden hergebruikt. Een afwijkend pakket of een andere bestaande fontversie wordt niet stilzwijgend geaccepteerd of overschreven. Bij een fout kan een deel van de fonts al geinstalleerd zijn; herstel de gemelde oorzaak en voer het script opnieuw uit.

## Installeren op Ubuntu

Voer als normale gebruiker uit vanuit de hoofdmap van de repository:

```bash
bash scripts/install-enox-fonts.sh
```

Het script vereist Python 3, fontconfig en CA-certificaten. Installeer ontbrekende afhankelijkheden zo nodig met `sudo apt install python3 fontconfig ca-certificates`. Voer het fontscript zelf **zonder sudo** uit.

De vijf fonts worden na SHA-256-controle geplaatst in `~/.local/share/fonts/enox`. De Microsoft-licentie wordt opgeslagen in `~/.local/share/enox/licenses`. Als `XDG_DATA_HOME` is ingesteld, wordt die map gebruikt in plaats van `~/.local/share`. Het script werkt de fontcache bij met `fc-cache`. Herstart daarna LibreOffice en andere documenttoepassingen.

Controle zonder installatie (downloadt wel het pakket):

```bash
bash scripts/install-enox-fonts.sh --dry-run
```

Offline installatie:

```bash
bash scripts/install-enox-fonts.sh --package "$HOME/Downloads/Microsoft Aptos Fonts.zip"
```

Beide opties kunnen worden gecombineerd. Identieke fonts worden hergebruikt; afwijkende versies in de doelmap worden niet overschreven. Fonts die elders zijn geinstalleerd blijven staan. Als een toepassing een andere versie kiest, controleer dan met `fc-match Aptos` welke versie wordt gebruikt. Bij een fout tijdens schrijven of het bijwerken van de cache kunnen al fonts geplaatst zijn; herstel de oorzaak en voer het script opnieuw uit.

## Handmatig installeren

Download het officiële Microsoft-pakket via onderstaande link en pak het lokaal uit. Gebruik `Aptos.ttf`, `Aptos-Bold.ttf`, `Aptos-Italic.ttf`, `Aptos-Bold-Italic.ttf` en `Aptos-Display-Bold.ttf`. Selecteer deze bestanden in Windows, klik met de rechtermuisknop en kies **Installeren**. Sluit Word, PowerPoint of LibreOffice daarna af en open de toepassing opnieuw. Op andere systemen moeten dezelfde fonts beschikbaar zijn voor de gebruikte documentrenderer.

Download: [officieel Microsoft Aptos-pakket](https://www.microsoft.com/en-us/download/details.aspx?id=106087). De templates zijn gecontroleerd met versie 4.40 op 13 november 2026.

De voorwaarden staan in `Microsoft Aptos Fonts EULA.rtf` in het Microsoft-pakket. Deze staan installatie en gebruik op eigen apparaten toe, maar verlenen geen recht om de fonts aan derden te distribueren. Lokaal aanwezige fontbestanden en de uitgepakte licentie zijn daarom uitgesloten van Git. Iedere gebruiker verkrijgt de fonts rechtstreeks bij Microsoft.
