"""File system utilities for ODE data ingestion.

Provides functions for:
- Finding files matching partial names
- Extracting date stamps and sequence numbers from filenames
- Sorting files chronologically
- Moving processed files to archive
- Reading project version from pyproject.toml
"""
import re
import tomllib
from pathlib import Path
from os import path
import shutil
from typing import List, Tuple, Optional
from datetime import datetime


def find_files(directory: str, partial_name: str) -> List[Path]:
    """
    Return files from a directory whose names contain a given partial string.

    Args:
        directory: Directory of files to look for.
        partial_name: Partial filename, e.g., "BO-aaben", "Bilag-master_Total".

    Returns:
        List of file paths from the directory matching the partial name.
    """
    files = []
    for filename in Path(directory).iterdir():
        if partial_name in filename.name:
            files.append(filename)
    return files


def _extract_date_from_filename(filename: str) -> Optional[datetime]:
    """
    Extract date stamps from filename in format: YYYY-MM-DD

    Args:
        filename: Filename, eg. '0751_ODE_2025-06-17_002_01-Bilag-master_Delta_001af2.csv'

    Returns:
        datetime object or None
    """
    date_pattern = r'(\d{4}-\d{2}-\d{2})'
    match = re.search(date_pattern, filename)

    if match:
        date_str = match.group(1)
        try:
            return datetime.strptime(date_str, '%Y-%m-%d')
        except ValueError as e:
            raise ValueError(f"Date '{date_str}' did not convert to pattern '%Y-%m-%d'") from e
    return None


def _extract_sequence_number(filename: str) -> int:
    """
    Extract sequence number from filename.

    Args:
        filename: Filename eg. '0751_ODE_2025-06-17_002_01-Bilag-master_Delta_001af2.csv'

    Returns:
        Sequence number (002 in example) or 0 if not found
    """
    split_pattern = r'_(\d+)af\d+'
    match_split = re.search(split_pattern, filename)
    if match_split:
        return int(match_split.group(1))
    seq_pattern = r'_(\d{3})_'
    match = re.search(seq_pattern, filename)

    if match:
        return int(match.group(1))
    return 0


def get_file_sort_key(filepath: Path) -> Tuple[datetime, int, str]:
    """
    Create a sort-key for a filename based on:
    1. Date stamp (oldest first).
    2. Sequence number (lowest first).
    3. Filename (alphabetical tiebreaker).

    Args:
        filepath: Full path to file.

    Returns:
        Tuple useable for sorting.
    """
    filename = filepath.name

    file_date = _extract_date_from_filename(filename)
    seq_number = _extract_sequence_number(filename)

    if file_date is None:
        file_date = datetime(1900, 1, 1)

    return file_date, seq_number, filename


def sort_files(file_paths: List[Path]) -> List[Path]:
    """
    Sort list of files based on date stamp and sequence number.

    Args:
        file_paths: List of file paths.

    Returns:
        Sorted list, with oldest files first.
    """
    return sorted(file_paths, key=get_file_sort_key)


def move_processed_files(filepath: Path, processed_path: str = "processed_files"):
    """Move processed file to archive subdirectory.

    Args:
        filepath: Path to the file to move
        processed_path: Subdirectory name for processed files (default: "processed_files")
    """
    directory, filename = path.split(filepath)
    shutil.move(filepath, path.join(directory, processed_path, filename))


def get_project_version() -> str:
    """Extract project version from pyproject.toml, used for logging.

    Searches upward from current file location to find pyproject.toml
    and extracts the version number.

    Returns:
        Version string from pyproject.toml

    Raises:
        FileNotFoundError: If pyproject.toml cannot be found in parent directories
    """
    current_path = Path(__file__).resolve()

    # Tjek nuværende mappe og alle forældremapper
    for p in [current_path] + list(current_path.parents):
        if (p / "pyproject.toml").exists():
            with open(p / "pyproject.toml", "rb") as f:
                toml_data = tomllib.load(f)
                return toml_data.get("project", {}).get("version", "N/A")

    raise FileNotFoundError("Kunne ikke finde pyproject.toml i nogen forældremapper.")
