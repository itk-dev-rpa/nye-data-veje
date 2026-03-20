from sqlalchemy import String, Date, Numeric, Integer
from .common import TableDefinition

forretningspartner = TableDefinition(
    name="Forretningspartner",
    keys=["Klient", "Forretningspartner", "Identifikationsart", "Forretningspartner-GUID"],
    data_types={
        'Klient': String(255), 'Forretningspartner': String(255), 'Identifikationsart': String(255),
        'Gyldig_fra': Date, 'Gyldig_til': Date, 'Datafordeleren_UUID': String(255),
        'Forretningspartner-GUID': String(255), 'BW_Opdateringsmode': String(255), 'Slettet': String(255)
    },
    ignored_columns={
        "Identifikationsnr": String(255)
    }
)

opsaetning_aftalekontotype = TableDefinition(
    name="Opsaetning-Aftalekontotype",
    keys=["Klient", "Sprognøgle", "Aftalekontotype"],
    data_types={
        'Klient': Numeric(precision=15, scale=2), 'Sprognøgle': String(255), 'Aftalekontotype': String(255),
        'Kontotype_tekst': String(255)
    }
)

opsaetning_rykkerniveau = TableDefinition(
    name="Opsaetning-Rykkerniveau",
    keys=["Sprognøgle", "Rykkeprocedure", "Rykkeniveau"],
    data_types={
        'Sprognøgle': String(255), 'Rykkeprocedure': String(255), 'Rykkeniveau': Integer, 'Betegnelse': String(255),
        'Kommune_kode': String(255)
    }
)

definitions = [forretningspartner, opsaetning_aftalekontotype, opsaetning_rykkerniveau]
