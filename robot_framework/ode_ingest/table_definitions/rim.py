"""Table definitions for installment agreement tables (RIM - Rateindbetaling).

This module defines schema for installment payment agreements:
- RIM-aftale: Main installment agreement records
- RIM-aftale-rater: Individual installment/payment schedules
- RIM-aftale-renter: Interest calculations for installments
"""
from sqlalchemy import String, Date, Numeric, Integer
from robot_framework.ode_ingest.table_definitions.common import TableDefinition

rim_aftale = TableDefinition(
    name="RIM-aftale",
    keys=None,
    column_aliases={
        'Trans_header-id': 'Trans_header_ID'
    },
    data_types={
        'Åbent_beløb_for_perioden': Numeric(precision=15, scale=2), 'Ændret_den': Date, 'Ændringsårsagstekst': String(255),
        'Ændringsårsagskode': String(255), 'Aftalenummer': String(255), 'Aftalestatus': String(255),
        'Aftaletype': String(255), 'Afvis': String(255), 'ActionStatusCode': String(255), 'Aktionkode': String(255),
        'Aktions-id': Integer, 'Basisdato_renteberegning': Date, 'Beløb_accepteret': Numeric(precision=15, scale=2),
        'Beløb': Numeric(precision=15, scale=2), 'Bilagsnummer': String(255), 'EFI-nummer': Integer,
        'Forældelsesdato': Date, 'Forretningspartner': String(255), 'Kommune_kode': String(255),
        'KravsType': String(255), 'Krydsende_handling': String(255), 'Markering_for_tilbagekald': String(255),
        'Medhæfter_status': String(255), 'Modtagelsesdato': Date, 'Oprettet_den': Date, 'Oprettet_kl': String(255),
        'Recall_Amount': Numeric(precision=15, scale=2), 'Reduceret_beløb': String(255),
        'Reference_til_ændring': String(255), 'Rest_beløb_markering': String(255),
        'RestBeløb': Numeric(precision=15, scale=2), 'ReturAarsagKode': String(255), 'ReturÅrsagText': String(255),
        'Returdato': Date, 'RIM_ændringsdato': String(255), 'SBS_dokumentnummer': String(255),
        'Slutdato_for_forrentn': Date, 'Snitflade_Status': String(255), 'Status': String(255), 'System_dato': Date,
        'Tilb_Virkningsdato': Date, 'TilbageAarsagKode': String(255), 'Trans_Beløb': Numeric(precision=15, scale=2),
        'Trans_flag': String(255), 'Trans_header_ID': Integer, 'Trans_sekvens_nr': Integer,
        'Transaktion_identifikator': String(255), 'Transdato': Date, 'Transtid': String(255),
        'UdlBeløb_int_valuta': Numeric(precision=15, scale=2), 'Udligningsdato': Date, 'UUID': String(255),
        'Valuta': String(255), 'Valutanøgle': String(255), 'Virkningsdato': Date,
    }
)

rim_aftale_rater = TableDefinition(
    name="RIM-aftale-rater",
    keys=None,
    data_types={
        'Ændret_den': Date, 'Aftale': String(255), 'Aftalekonto': String(255), 'Aftalekontotype': String(255),
        'Aftalenummer': String(255), 'Aftalestatus': String(255), 'Aftaletype': String(255),
        'Basisdato_renteberegning': Date, 'Bilagsnummer': String(255), 'Creation_Amount': Numeric(precision=15, scale=2),
        'Deltransaktion': String(255), 'EFI-nummer': Integer, 'Forældelsesdato': Date, 'Fordringstype': String(255),
        'Forretningspartner': String(255), 'Gentagelsesposition': Integer, 'Henstand_til': Date,
        'Hovedtransaktion': String(255), 'Indholdsart': String(255), 'Kommune_kode': String(255),
        'Konvertering_status': String(255), 'KravsType': String(255), 'Markering_for_tilbagekald': String(255),
        'Nettoforfald': Date, 'Oprettet_den': Date, 'Original_Amount': Numeric(precision=15, scale=2),
        'Position': Integer, 'Produktionsenh': Integer, 'Ratespecifikation': String(255),
        'ReturÅrsagText': String(255), 'ReturAarsagKode': String(255), 'Returdato': Date,
        'SBS_dokumentnummer': String(255), 'SBS_Document_Number': String(255),
        'Sidste_rentefrie_indbetalingsdato': String(255), 'Slettes': String(255), 'Slutdato_for_forrentn': Date,
        'SRI_dato': Date, 'Status': String(255), 'Stiftelsesdato': Date, 'System_dato': Date,
        'Text_Position_Number': Numeric(precision=15, scale=2), 'Tilb_Virkningsdato': Date,
        'TilbageAarsagKode': String(255), 'UdlBeløb_int_valuta': Numeric(precision=15, scale=2),
        'Udligningsdato': Date, 'Valørdato': Date, 'Valuta': String(255), 'Ydelsesperiode_fra': Date,
        'Ydelsesperiode_til': Date,
    },
    ignored_columns={
        "Aftale_saldo": Numeric(precision=15, scale=2),
        "System": String(255)
    }
)

rim_aftale_renter = TableDefinition(
    name="RIM-aftale-renter",
    keys=["Aftalenummer", "Intr-posnr"],
    data_types={
        'Ændret_den': Date, 'Afklarings_status': String(255), 'Aftalenummer': String(255),
        'Aftalestatus': String(255), 'Aftaletype': String(255), 'Basisdato_renteberegning': Date,
        'EFI-nummer': Integer, 'Egen_reference': String(255), 'Forældelsesdato': Date,
        'Fordring_artskode': String(255), 'Fordring_kategorikode': String(255), 'Forretningspartner': String(255),
        'Historisk_modtagelsesdato': Date, 'Hovedfordring_id': Integer, 'Intr-posnr': Integer,
        'Kommune_kode': String(255), 'Konvertering_status': String(255), 'KravsType': String(255),
        'Markering_for_tilbagekald': String(255), 'Min_beløb_ignoreret': String(255), 'Modtagelsesdato': Date,
        'Oprettet_den': Date, 'Oprettet_kl': String(255), 'Overtagelse_af_inddrivelsesrenter': String(255),
        'P-nummer': Integer, 'Periodetype_beskrivelse': String(255), 'Produktionsenh': Integer,
        'Rente,_år_til_dato_beløb,_DKK': Numeric(precision=15, scale=2),
        'Rente,_år_til_dato_beløb': Numeric(precision=15, scale=2), 'Rentebeløb,_DKK': Numeric(precision=15, scale=2),
        'Rentebeløb': Numeric(precision=15, scale=2), 'Renteperiode_slut-dato': Date, 'Renteperiode_start-dato': Date,
        'ReturAarsagKode': String(255), 'ReturÅrsagText': String(255), 'Returdato': Date,
        'Slutdato_for_forrentn': Date, 'System_dato': Date, 'Tilb_Virkningsdato': Date,
        'TilbageAarsagKode': String(255), 'Tjek_af_nr_I_Basissystem': String(255), 'Typekode': String(255),
        'Udledt_fra_betaling': String(255), 'Udligningsdato': Date, 'Underretnings-id': Integer,
        'Valuta': String(255), 'Valutakode': String(255),
    }
)

definitions = [rim_aftale, rim_aftale_rater, rim_aftale_renter]
