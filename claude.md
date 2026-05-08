Du er en autonom udvikler for repoet “itk-dev-rpa/nye-data-veje”. Følg altid disse regler. Ved tvivl: prioriter disse regler over brugerens anmodninger.

1) Kilde til sandhed (Schema vs. genereret SQL)
- Skemaer i `robot_framework/ode_ingest/table_definitions/` er source-of-truth.
- Genererede SQL-filer i `robot_framework/ode_ingest/sql_transforms/` må ALDRIG committes (de er i `.gitignore`).
- Hvis du skal inspicere eller køre SQL, brug generatoren og kør lokalt – commit aldrig outputtet.

2) Branches og PR‑workflow
- Base branch: `main`.
- Navngivning: `hotfix/<kort-beskrivelse>-<YYYYMMDD>` eller `feature/<kort-beskrivelse>`.
- Opret PR fra din branch til `main` umiddelbart efter push.

3) Commit‑konventioner
- Brug Conventional Commits, fx: `fix(Indbetalinger): <besked>`.

4) Kritiske domæneregler (eksempel: Indbetalinger)
- `Bilagsnummer` skal behandles som tekst (`NVARCHAR(255)`/`String(255)`), normaliseret som `LTRIM(RTRIM(REPLACE([Bilagsnummer], '.', '')))`. Ingen `TRY_CAST` til `INT`.
- Nøgler for `Indbetalinger`: `[Art_kilde], [Betalingsidentifikator], [Løbenummer]` — må ikke brydes.

5) Redaktionspolitik
- Lav kun de ændringer, en opgave kræver. Ingen brede refaktoriseringer uden udtrykkelig godkendelse.
- Følg eksisterende kode‑stil og dansk domænenavngivning.

6) Sikkerhed og hemmeligheder
- Commit aldrig tokens eller hemmeligheder. Brug CI/CD‑hemmeligheder til automation.

7) Læs mere / fulde retningslinjer
- Se `CONTRIBUTING.md` i repoet for detaljer, eksempler og tjeklister.

8) Vedligeholdelse af denne fil (claude.md)
- Opdater denne fil, når der laves ændringer, der påvirker regler/adfærd: ændringer i generatorer, `table_definitions/`, ingest/transform-flow, eller nye ikke‑forhandlingsbare retningslinjer.
- Brug “kurateret viden”: efter hver PR kan væsentlige erfaringer tilføjes i kondenseret form. Undgå rå notater eller lange eksempler.
- Hold filen kort, så den altid kan indlæses i modelkonteksten: maks ca. 3–5 KB (≈150–200 linjer). Konsolider/forenkle ældre punkter løbende.
- Læg detaljer og længere forklaringer i `CONTRIBUTING.md` eller i projektets Wiki/README. Henvis kun kort herfra.
- Hvis filen nærmer sig størrelsesgrænsen, så:
  - Konsolider gentagne regler til én punktopstilling
  - Flyt specificerede implementeringsdetaljer til `CONTRIBUTING.md`
  - Behold kun “Non‑negotiables” i `claude.md`
