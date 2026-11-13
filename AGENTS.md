# Werken met de Enox-huisstijl

## Uitgangspunt

Lees vóór het maken van een Enox-uiting `output/enox/Enox-huisstijl-v1.0.md`. Dit is het bovenliggende huisstijldocument. De templates zijn de goedgekeurde praktische uitwerking. Behoud de huisstijlgids als zelfstandig document, zonder verwijzingen naar bestanden, externe bronnen, klanten of ontwerphistorie.

## Een document maken

1. Gebruik de opdracht van de gebruiker voor onderwerp, doelgroep, inhoud, omvang en uitvoerformaat. Vraag ontbrekende essentiële informatie; verzin geen feiten of klantgegevens.
2. Kies de bestaande rapporttemplate (`.dotx`), memotemplate (`.dotx`) of presentatietemplate (`.potx`) in `output/enox`. Werk op een kopie. Lever gewone `.docx`- of `.pptx`-documenten op, en PDF indien gevraagd. Alleen de extensie veranderen converteert een template niet: gebruik een geschikte Office-toepassing of pas bij programmatische verwerking ook het OOXML-hoofdcontenttype aan.
3. Gebruik beschikbare document- of presentatievaardigheden en de aanwezige runtime. Behoud stijlen, thema, kop- en voetteksten, logo’s en velden uit de template. Controleer vóór het renderen of Aptos en Aptos Display beschikbaar zijn; volg anders `output/enox/fonts/README.md`. Meld ontbrekende fonts en presenteer een vervangend lettertype niet als definitief huisstijlconform.
4. Kies het TLP-label op basis van een expliciete gebruikerskeuze. Neem een label uit voorbeeldinhoud nooit als standaard over. Ontbreekt het label, vraag het dan en werk ondertussen aan de inhoud. Houd een oningevulde classificatie herkenbaar in een concept; lever dat niet als verspreidingsklaar op.
5. Vul het gedeelde TLP-keuzeveld in rapporten en memo’s eenmaal in. Controleer bij alle formaten precies één label per pagina of slide, ook op covers en bijlagen.
6. Verwijder ongebruikte voorbeeldinhoud en invulaanwijzingen. Voeg alleen betekenisvolle beelden toe. Het schild blijft onderdeel van het logo; in de memo staat het logo volledig op wit en los van de kleine blauwe hoek.
7. Werk inhoudsopgave, paginanummers en overige velden bij. Render de uitvoer en inspecteer iedere pagina of slide op leesbaarheid, afbrekingen, overlap, tabellen, logo’s en TLP. Meld expliciet wanneer visuele controle niet mogelijk is.

## Bestanden en beheer

- Bewaar nieuwe klantdocumenten in de door de gebruiker aangewezen locatie, anders in `generated/`. Gebruik `.work/` voor tijdelijke renders en scripts. Deze mappen worden niet ingecheckt.
- Wijzig de huisstijl of mastertemplates alleen als de opdracht daarover gaat. Een nieuwe klantuiting is geen reden om de masterbestanden te overschrijven.
- Gebruik uitsluitend de aangeleverde logo-assets. Behoud de verhoudingen; gebruik een passende uitsnede van lege randruimte wanneer nodig. `enox-licht.png` heeft een donker vlak: plaats dit niet als een zichtbare rechthoek op een andere ondergrond.
- Publiceer geen fontbestanden, klantinformatie of tijdelijke uitvoer in deze repository. Fonts worden rechtstreeks bij Microsoft verkregen.
- Bij een huisstijlwijziging: houd gids en betrokken templates consistent en controleer de gewijzigde templates visueel. Voeg alleen herbruikbare, noodzakelijke bestanden toe.
