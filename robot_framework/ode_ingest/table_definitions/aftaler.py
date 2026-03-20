from sqlalchemy import String, Date, Numeric, Integer
from .common import TableDefinition

aftaleindhold = TableDefinition(
    name="Aftaleindhold",
    keys=["Aftaleindhold"],
    data_types={
        'Aftaleindhold': String(255), 'Oprettet_af': String(255), 'Oprettet_den': Date, 'Ændret_af': String(255),
        'Ændret_den': Date, 'Indholdsart': String(255), 'Bet_aftaleindhold': String(255),
        'Nummer_i_basissystem': String(255), 'Kommune_kode': String(255)
    }
)

bo_aftale = TableDefinition(
    name="BO-aftale",
    keys=["Aftalenummer", "Bilagsnummer", "Position"],
    data_types={
        'Aftalestatus': String(255), 'Aftaletype': String(255), 'Aftalenummer': String(255),
        'Bilagsnummer': String(255), 'Position': Integer, 'Oprettet_beløb': Numeric(precision=15, scale=2),
        'Valuta': String(255), 'Første_anmeldelse': Numeric(precision=15, scale=2),
        'Indbetalt_af_bobestyrer': Numeric(precision=15, scale=2), 'Fjernet': String(255),
        'Bobehandling': String(255), 'Indholdsart': String(255), 'Deltransaktion': String(255),
        'Hovedtransaktion': String(255), 'Aftalekonto': String(255), 'Aftale': String(255),
        'Kommune_kode': String(255), 'Restbeløb': Numeric(precision=15, scale=2),
        'Afskrevet': Numeric(precision=15, scale=2),
        'Ændringer_efter_første_anmeld': Numeric(precision=15, scale=2)
    }
)

bo_aftale_haendelse = TableDefinition(
    name="BO-aftale-haendelse",
    keys=["Ekstern_reference_nøgle"],
    date_columns=["Afskrivnings_dato", "Betalingsdato"],
    data_types={
        'Klient': String(255), 'Aftalenummer': String(255), 'Bobehandling': String(255),
        'Ekstern_reference_nøgle': String(255), 'Udtrækstype': String(255), 'Korrespondanceart': String(255),
        'Printdato': Date, 'Afskrevet': Numeric(precision=15, scale=2), 'Afskrivnings_dato': Date,
        'Betalingsdato': Date, 'Valuta': String(255), 'Kommune_kode': String(255),
        'Beløb': Numeric(precision=15, scale=2), 'Indbetalt_af_bobestyrer': String(255),
    }
)

fp_aftale = TableDefinition(
    name="FP-aftale",
    keys=None,
    date_columns="Oprettet_den",
    data_types={
        'AA_type': String(255), 'Ændret_den': Date, 'Aftale': String(255), 'Aftalekonto': String(255),
        'Aftalenummer': String(255), 'Aftaleposition': Integer, 'Aftalestatus': String(255),
        'Aftaletype': String(255), 'Årsag_til_luk_aftale': String(255), 'Besvaret': Date,
        'Bilagsnummer': String(255), 'Forretningspartner': String(255), 'Kommune_kode': String(255),
        'Konvertering': String(255), 'Lukket_den': Date, 'Niveau_Aftale_Position': String(255),
        'Oprettet_den': Date, 'Position': Integer, 'System_dato': Date, 'Tilføjelsesdato': Date,
        'UdlBeløb_int_valuta': Numeric(precision=15, scale=2), 'Valuta': String(255),
    }
)

uu_aftale = TableDefinition(
    name="UU-aftale",
    keys=None,
    data_types={
        'Aftalestatus': String(255), 'Aftaletype': String(255), 'Aftalenummer': String(255),
        'Indholdsart': String(255), 'Aftale': String(255), 'Aftalekonto': String(255), 'Deltransaktion': String(255),
        'Bilagsnummer': String(255), 'Position': Integer, 'Hovedtransaktion': String(255),
        'Udligningsstatus': String(255), 'Beløb': Numeric(precision=15, scale=2), 'Valuta': String(255),
        'Kommune_kode': String(255)
    }
)

uu_aftale_haefter = TableDefinition(
    name="UU-aftale-haefter",
    keys=["Klient", "Aftalenummer", "Forretningspartner"],
    data_types={
        'Klient': String(255), 'Aftale': String(255), 'Aftalekonto': String(255), 'Aftalenummer': String(255),
        'BetFormReference': String(255), 'Forretningspartner': String(255), 'Hovedhæfter': String(255),
        'Hæfter_fjernet': Date, 'Hæfter_tilføjet': Date, 'Kommune_kode': String(255)
    }
)

definitions = [aftaleindhold, bo_aftale, bo_aftale_haendelse, fp_aftale, uu_aftale, uu_aftale_haefter]
