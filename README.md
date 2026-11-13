# Enox huisstijl

Deze repository bevat de Enox-huisstijl, goedgekeurde templates en logo’s. Zij vormt de basis voor nieuwe rapporten, memo’s en presentaties, ook wanneer een nieuwe Codex-sessie geen eerdere gesprekshistorie heeft.

## Inhoud

| Bestand | Doel |
|---|---|
| [Huisstijlgids](output/enox/Enox-huisstijl-v1.0.md) | Bovenliggende regels voor identiteit, taal, logo, kleur, typografie en opmaak |
| [Rapporttemplate](output/enox/Enox-rapporttemplate-v1.0.dotx) | Rapport met cover, samenvatting, inhoudsopgave en inhoudspagina’s |
| [Memotemplate](output/enox/Enox-memotemplate-v1.0.dotx) | Compacte memo met optionele vervolgpagina |
| [Presentatietemplate](output/enox/Enox-presentatiesjabloon-v1.0.potx) | Herbruikbare slide-indelingen |
| [Logo’s](output/enox/assets/) | Volledig en compact logo met schild |
| [Lettertypen](output/enox/fonts/README.md) | Download- en installatie-instructies voor Aptos |
| [Codex-instructies](AGENTS.md) | Werkwijze, templatekeuze en kwaliteitscontrole |

## Gebruik in Codex

Clone de repository en open de uitgecheckte map als werkmap in Codex:

```sh
git clone git@github.com:enoxnl/huisstijl.git
cd huisstijl
```

De instructies in `AGENTS.md` zijn bedoeld voor taken in deze werkmap. Als je de repository tijdens een bestaande sessie of als submap van een ander project uitcheckt, vraag Codex dan expliciet om dat bestand te lezen. Dit bestandstype wordt ondersteund als repository-instructie; zie de [officiële documentatie](https://learn.chatgpt.com/docs/agent-configuration/agents-md).

Voorbeeldopdracht:

> Lees AGENTS.md en maak met de Enox-memotemplate een memo voor [doelgroep] over [onderwerp]. Gebruik de bijgevoegde inhoud. De kernboodschap is [boodschap]. Gebruik TLP:GREEN. Lever een bewerkbare DOCX op in generated/ en controleer alle pagina’s visueel.

Vermeld voor een rapport of presentatie daarnaast de gewenste omvang en, indien van toepassing, het gewenste PDF-bestand. Kies voor iedere opdracht bewust een TLP-label. Er is geen standaardclassificatie.

De repository bevat de merkbasis; voor het maken en controleren van Office-bestanden zijn daarnaast geschikte documenttools en een renderer nodig. Codex gebruikt daarvoor de mogelijkheden van de betreffende omgeving. Templates zijn bewerkbaar en worden niet door een automatische generator opnieuw opgebouwd.

## Lettertypen en uitvoer

Installeer de benodigde Aptos-varianten vóór gebruik. Fontbestanden worden wegens de Microsoft-licentie niet via Git verspreid. De instructies staan in de fontmap.

Op Windows kan dit vanuit de repository met `.\scripts\Install-EnoxFonts.ps1` (zonder administratorrechten). Gebruik `-WhatIf` om het pakket te controleren zonder fonts te installeren. Het script haalt de fonts rechtstreeks bij Microsoft op.

`generated/` is bestemd voor nieuwe documenten en `.work/` voor tijdelijke bestanden. Beide zijn uitgesloten van Git. Bewaar uitsluitend herbruikbare huisstijlbestanden in deze repository; voeg klantdocumenten niet toe.
