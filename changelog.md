# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.5] - 08-06-2026

- Fixed `normalize_forretningspartner_value` to treat float NaN as a missing value (returns `None`) before stringification, instead of raising on the literal string `'nan'`. Missing Forretningspartner values no longer fail ingestion on tables where it is not part of the primary key.
- On per-table failure, the remaining subsets (e.g. `Delta` after a `Total` failure) are now skipped to avoid applying delta-loads on top of an incomplete total. Other tables continue processing as before.
- Extracted the recurring `print` + `orchestrator_connection.log_*` pattern into a small `emit` helper in `ode_ingest/utils/log_utils.py`. Pure refactor — no behavior change.

## [1.1.4] - 08-06-2026

- Fixed silent failure: per-file processing errors are now logged to OpenOrchestrator via `log_error` (not just stdout) and the whole run is marked as failed by raising `RuntimeError` after the loop when any file failed.
- Threaded `orchestrator_connection` through `execute_sql_string_with_validation`, `execute_sql_file_with_validation`, and `_process_validation_results` so SQL execution progress and validation metrics also surface in the OO log via `log_info` and `log_trace`.

## [1.1.3] - 04-06-2026

- Fixed missing error-email value in config

## [1.1.2] - 20-04-2026

- Fixed formatting og Indbetalinger > Bilagsnummer to avoid dropping ints that are too big.
- Normalization of Forretningspartner ID to always be 8 digits.

## [1.1.1] - 10-04-2026

- Fixed bad references

## [1.1.0] - 20-03-2026

- Refactored and reworked ingest flow
- Removed saving SQL as files as default

## [1.0.0] - 12-08-2025

- Initial upload, not deployed
