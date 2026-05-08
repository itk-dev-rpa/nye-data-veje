"""Table definitions for payment tables (betalinger).

This module defines schema for payment-related tables:
- Indbetalinger: Incoming payments
- Rykker: Payment reminders/dunning notices
"""
from sqlalchemy import String, Date, Numeric, Integer
from robot_framework.ode_ingest.table_definitions.common import TableDefinition

indbetalinger = TableDefinition(
    name="Indbetalinger",
    keys=["Art_kilde", "Betalingsidentifikator", "Løbenummer"],
    column_aliases={
        'Bilagstype': 'Bilagsart'
    },
    data_types={
        'Afdeling': String(255), 'Afklaringsstatus': String(255), 'Aftale': String(255), 'Aftalekonto': String(255),
        'Annuller_status': String(255), 'Anvendelsestekst': String(255), 'Art_kilde': String(255), 'Bankafregningskonto': String(255),
        'Bankforbindelse': String(255), 'Beløb': Numeric(precision=15, scale=2), 'Betalings_art': String(255),
        'Betalingsidentifikator': String(255), 'Betalingsmåde': String(255), 'Betalingsretning': String(255),
        'Bilagsart': String(255), 'Bilagsnummer': String(255), 'Firmakode': String(255), 'Forretningsområde': String(255),
        'Forretningspartner': String(255), 'Kasse': String(255), 'Kommune_kode': String(255),
        'Konto-ID': String(255), 'Langtekst': String(255), 'Løbenummer': Integer, 'Oprettet_den': Date,
        'Skæringsdato': Date, 'Stak': String(255), 'Tidsstempel_for_deltaekstrakt': Date, 'Underapplikation': String(255),
        'Valørdato': Date, 'Valuta': String(255), 'Varighed_af_afklaring': Integer,
    }
)

rykker = TableDefinition(
    name="Rykker",
    keys=["Dato-ID", "Identifikation", "Forretningspartner", "Aftalekonto", "Rykkertæller", "Bilagsnummer", "Gentagelsesposition", "Position", "Delposition"],
    data_types={
        'Aftale': String(255), 'Aftalekonto_ikke_entydig': String(255), 'Aftalekonto': String(255),
        'Bilagsnummer': String(255), 'Dato-ID': Date, 'Delposition': Integer, 'Firmakode': String(255),
        'Forretningspartner': String(255), 'Gentagelsesposition': Integer, 'Identifikation': String(255),
        'Kommune_kode': String(255), 'Nettoforfald': Date, 'Nyt_rykkeniveau': Integer, 'Position': Integer,
        'Printdato': Date, 'Rentebilag': String(255), 'Rykkebeløb': Numeric(precision=15, scale=2),
        'Rykkeniveau': Numeric(precision=15, scale=2), 'Rykkeniveautype': String(255), 'Rykkeprocedure': String(255),
        'Rykker_annulleret': String(255), 'Rykkerenter': Numeric(precision=15, scale=2), 'Rykkertæller': Integer,
        'Rykkespærreårsag': String(255), 'Segment': String(255), 'Skæringsdato': Date, 'Statistiknøgle': String(255),
        'Suspenderings-rykkeniv': String(255), 'Udskrevet': String(255), 'Udstedelsesdato': Date,
        'Valuta': String(255),
    }
)

definitions = [indbetalinger, rykker]
