from datetime import datetime

def isoformat(dt: datetime):
    """Turn timestamp into an iso8601 string.

    >>> isoformat(datetime(1991, 12, 25, 16, 35))
    '1991-12-25T16:35:00'

    """
    return dt.strftime('%Y-%m-%dT%H:%M:%S')
