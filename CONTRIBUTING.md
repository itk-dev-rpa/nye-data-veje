# Contributing guidelines

Tak for at bidrage til projektet “itk-dev-rpa/nye-data-veje”. Dette dokument beskriver, hvordan vi arbejder med branches, PR’er, commits og genererede artefakter.

## 1) Kilde til sandhed
- Skemaer i `robot_framework/ode_ingest/table_definitions/` er source-of-truth.
- SQL-filer i `robot_framework/ode_ingest/sql_transforms/` er genererede til inspektion/debug og er i `.gitignore`. De må ikke committes.
- Brug `robot_framework/ode_ingest/generate_transform_sql.py` til at regenerere SQL lokalt ved behov.

## 2) Branching og PR-workflow
- Base branch: `main`.
- Branch-navne:
  - Hotfix: `hotfix/<kort-beskrivelse>-<YYYYMMDD>`
  - Feature: `feature/<kort-beskrivelse>`
- Start altid fra `main` (opdater med `git pull --ff-only`).
- Opret PR fra din branch til `main` straks efter push.
- Hurtigt PR-link: `https://github.com/itk-dev-rpa/nye-data-veje/compare/main...<din-branch>?expand=1`

## 3) Commit- og PR-konventioner
- Brug Conventional Commits:
  - `fix(Indbetalinger): <besked>` til fejlrettelser i Indbetalinger-domænet
  - `feat(...):`, `chore(...):`, `docs(...):` osv. efter behov
- PR‑titel: Kort og konsekvent, fx “Hotfix: Behandl Bilagsnummer som tekst i Indbetalinger”.
- PR‑beskrivelse bør indeholde:
  1) Rodårsag
  2) Løsning/ændringer
  3) Påvirkning/risici
  4) Evt. kørselstrin (truncate/reload/backfill), hvis relevant

## 4) Generering frem for at committe artefakter
- Kør kun generator-scripts lokalt for inspektion/kørsel.
- Commit aldrig output fra generatoren (SQL-filerne er ignoreret i VCS).

## 5) Kørsel og verificering (letvægts)
- Ved skemaændringer, tjek at typer i `TableDefinition` matcher forventet SQL (fx `NVARCHAR(255)`, `DECIMAL(15,2)`).
- Bekræft at nøgler ikke påvirkes (se `keys` i `TableDefinition`).
- For Indbetalinger:
  - `Bilagsnummer` behandles som tekst og normaliseres som `LTRIM(RTRIM(REPLACE([Bilagsnummer], '.', '')))`. Ingen `TRY_CAST` til `INT`.

## 6) Push uden ekstra værktøjer
- Antag `origin` som remote og `main` som base.
- Typisk flow:
  - Opret branch: `git checkout -b hotfix/<navn>-<dato>`
  - Stage/commit: `git add -A && git commit -m "fix(<område>): <besked>"`
  - Push: `git push -u origin <branch>`
  - Opret PR via browser-link (se ovenfor)

## 7) Versions- og changelog-praksis
- `changelog.md` opdateres ved releases. Hotfix-beskrivelse kan stå i PR-teksten.
- Migrations-DDL committes kun hvis vi versionerer DB-skemaer i repoet (pt. gør vi ikke). DDL til drift beskrives i PR eller i runtime-noter udenfor repo.

## 8) Stil og konsistens
- Følg eksisterende kode-stil og mønstre.
- Match domænenavne på dansk (fx `Bilagsnummer`, `Løbenummer`).
- Brug `EditorConfig` (se evt. `.editorconfig`, hvis tilføjet) til konsistente formatteringsregler på tværs af IDE’er.

## 9) Sikkerhed
- Ingen tokens/hemmeligheder i repo. CI/CD-secrets håndteres i miljøet.

## 10) Tjekliste før PR
- [ ] Kun nødvendige kildefiler er ændret (ingen genererede SQL-artefakter)
- [ ] Branch fra `main`, pushed til `origin`
- [ ] PR‑titel og beskrivelse følger konventionerne
