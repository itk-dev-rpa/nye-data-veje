"""Table definitions for invoice/document tables (bilag).

This module defines schema for invoice-related tables:
- Bilag-master: Master invoice records
- Bilag-aaben: Open invoices
- Bilag-lukket: Closed invoices
"""
from sqlalchemy import String, Date, Numeric, Integer
from .common import TableDefinition

bilag_master = TableDefinition(
    name="Bilag-master",
    keys=["Bilagsnummer", "Gentagelsesposition", "Position", "Delposition"],
    date_columns="Registreringsdato",
    column_aliases={
        'Bilagstype': 'Bilagsart',
        'Udligngningstype': 'Udligningstype'
    },
    data_types={
        "Gentagelsesposition": Integer, 'AfregnPeriode_fra': Date, 'AfregnPeriode_til': Date,
        'Afskrivningsårsag': String(255), 'Aftale': String(255), 'Aftalekonto': String(255),
        'Aftalekontotype': String(255), 'Aftalenummer': String(255), 'Aftalestatus': String(255),
        'Aftaletype': String(255), 'Applikationsområde': String(255), 'Artskonto': String(255),
        'Beløb_intern_valuta': Numeric(precision=15, scale=2), 'Beløb': Numeric(precision=15, scale=2),
        'Betalingsordre': String(255), 'Bilagsart': String(255), 'Bilagsdato': Date, 'Bilagsnummer': String(255),
        'Bilagstype_markering': String(255), 'BogfDato_udligning': Date, 'Bogføringsdato': Date,
        'Bortposteringsårsag': String(255), 'Delposition': Integer, 'Deltransaktion': String(255),
        'Firmakode': String(255), 'Forretningspartner': String(255), 'Henstand_til': Date,
        'Hovedtransaktion': String(255), 'Indholdsart': String(255), 'Kommune_kode': String(255),
        'KontofastsætKendet': String(255), 'Momsindikator': String(255), 'Nettoforfald': Date,
        'Oprindelse': String(255), 'Position': Integer, 'Referencebilagsnr': String(255),
        'Referencenøgle': String(255), 'Referenceoperation': String(255), 'Registreringsdato': Date,
        'Rentenøgle': String(255), 'Rykkeprocedure': String(255), 'SBS_dokumentnummer': String(255),
        'Skæringsdato': Date, 'Statistiknøgle': String(255), 'Tilbageført_via': String(255),
        'Udligningsårsag': String(255), 'Udligningsbeløb': Numeric(precision=15, scale=2),
        'Udligningstype': String(255), 'Udligningsbilag': String(255), 'Udligningsdato': Date,
        'Udligningsstatus': String(255), 'Udligningsvaluta': String(255), 'Valørdato_udligning': Date,
        'Valuta': String(255),
    }
)

bilag_aaben = TableDefinition(
    name="Bilag-aaben",
    keys=None,
    date_columns="Bogføringsdato",
    data_types={
        'Aftaleindhold': String(255), 'Aftalekonto': String(255), 'Aftalekontotype': String(255),
        'Aftalenummer': String(255), 'Aftalestatus': String(255), 'Aftaletype': String(255),
        'Antal_poster': Integer, 'Beløb_intern_valuta': Numeric(precision=15, scale=2),
        'Beløb': Numeric(precision=15, scale=2), 'BevillAnsvarssted': String(255), 'Bevillingsposition': String(255),
        'Bevillingsprogram': String(255), 'Bilagsdato': Date, 'Bilagsnummer': String(255), 'Bogføringsdato': Date,
        'Dato-ID': Date, 'Deltransaktion': String(255), 'Firmakode': String(255), 'Forretningspartner': String(255),
        'Funktionsområde': String(255), 'Henstand_til': Date, 'Hovedtransaktion': String(255),
        'Identifikation': String(255), 'Indholdsart': String(255), 'Kapitalmidler': String(255),
        'Klient': String(255), 'Kommune_kode': String(255), 'Kredit_oprindelses_dato': Date, 'Landenøgle': String(255),
        'Nettoforfald': Date, 'Original-FI-område': String(255), 'Periodenøgle': String(255), 'Position': Integer,
        'Positionstekst': String(255), 'Postnummer': String(255), 'Referencebilagsnr': String(255),
        'Registreringsdato': Date, 'Rykkeniveau': Integer, 'Rykkeniveautype': String(255),
        'Rykkeprocedure': String(255), 'Rykkeproceduretype': String(255), 'SBS_dokumentnummer': String(255),
        'Skæringsdato': Date, 'Sorteringsbetegnelse': String(255), 'Statistiknøgle': String(255),
        'Udligning_kredit_oprindelse': String(255), 'Udligningsstatus': String(255), 'Valuta': String(255),
    }
)

bilag_lukket = TableDefinition(
    name="Bilag-lukket",
    keys=["Dato-ID", "Identifikation", "Intervalnummer", "Recordnummer"],
    date_columns="Bogføringsdato",
    data_types={
        "Intervalnummer": Integer, "Recordnummer": Integer, 'Afskrivningsårsag': String(255),
        'Afskrivningsdato': Date, 'Aftaleindhold': String(255), 'Aftalekonto': String(255),
        'Aftalekontotype': String(255), 'Aftalenummer': String(255), 'Aftalestatus': String(255),
        'Aftaletype': String(255), 'Antal_poster': Integer, 'Bankafregningskonto': String(255),
        'Beløb_intern_valuta': Numeric(precision=15, scale=2), 'Beløb': Numeric(precision=15, scale=2),
        'BevillAnsvarssted': String(255), 'Bevillingsposition': String(255), 'Bevillingsprogram': String(255),
        'Bilagsdato': Date, 'Bilagsnummer': String(255), 'Bilagstype_markering': String(255),
        'BogfDato_udligning': Date, 'Bogføringsdato': Date, 'Bortposteringsårsag': String(255), 'Dato-ID': Date,
        'Deltransaktion': String(255), 'Firmakode': String(255), 'Forretningspartner': String(255), 'Fra': Date,
        'Funktionsområde': String(255), 'Henstand_til': Date, 'Hovedtransaktion': String(255),
        'Identifikation': String(255), 'Indbetalingstype': String(255), 'Indholdsart': String(255),
        'Kapitalmidler': String(255), 'Klient': String(255), 'Kommune_kode': String(255),
        'Kredit_oprindelses_dato': Date, 'Landenøgle': String(255), 'Nettoforfald': Date,
        'Original-FI-område': String(255), 'Position': Integer, 'Postnummer': String(255),
        'Referencebilagsnr': String(255), 'Registreringsdato': Date, 'Rykkeniveau': Integer,
        'Rykkeprocedure': String(255), 'SBS_dokumentnummer': String(255), 'Sorteringsbetegnelse': String(255),
        'Statistiknøgle': String(255), 'Til': Date, 'Tilbageført_via': String(255),
        'Udligning_kredit_oprindelse': String(255), 'Udligning': Date, 'Udligningsårsag': String(255),
        'Udligningsbeløb': Numeric(precision=15, scale=2), 'Udligningsbilag': String(255), 'Udligningsdato': Date,
        'Udligningsstatus': String(255), 'Udligningsvaluta': String(255), 'Underapplikation': String(255),
        'Valørdato_udligning': Date, 'Valuta': String(255),
    }
)

definitions = [bilag_master, bilag_aaben, bilag_lukket]
