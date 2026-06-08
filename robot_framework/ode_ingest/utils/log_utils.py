"""Logging helper bridging stdout and OpenOrchestrator's central log."""


def emit(log_method, message: str) -> None:
    """Print to stdout and forward the same message to the given OO log method.

    Pass ``orchestrator_connection.log_info``, ``log_trace`` or ``log_error``
    as ``log_method`` so the level stays named explicitly at the call site.

    Args:
        log_method: A bound method on OrchestratorConnection (e.g. log_info).
        message: Message to send to both stdout and OO.
    """
    print(message)
    log_method(message)
