# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.2.0] - 04-06-2026

- Added pytest-based unit test suite covering SQL transformation generator and ingest utility functions (data cleaning, number conversion, date conversion). No production code behavior changed.

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
