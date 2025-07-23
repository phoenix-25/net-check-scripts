## 2. docs/usage.md

Questo file descrive nello specifico come utilizzare ciascuno script.

```markdown
# Usage Guide for net-check-scripts

This document describes the usage of each script included in the `net-check-scripts` project.

---

## ping_test.sh

**Description:** Measures ping latency and jitter to a specified host.

**Usage:**

```bash
bash ping_test.sh <target_ip_or_hostname> [count]

    <target_ip_or_hostname>: The target host to ping (default: 8.8.8.8).

    [count]: Number of ping packets to send (default: 10).

Example:

bash ping_test.sh 1.1.1.1 15

http_inspect.sh

Description: Fetches and displays HTTP headers and status code for a URL.

Usage:

bash http_inspect.sh <url>

    <url>: The URL to inspect (default: https://www.google.com).

Example:

bash http_inspect.sh https://example.com

tcp_latency_trace.py

Description: Checks TCP connectivity and latency to a specified host and port.

Usage:

python3 tcp_latency_trace.py <host> [port]

    <host>: Hostname or IP address to check.

    [port]: TCP port (default: 80).

Example:

python3 tcp_latency_trace.py example.com 443

Additional notes

    Make sure your system has necessary tools installed (ping, curl, python3, etc.)

    Scripts should be run with proper permissions.

Feel free to open issues or pull requests for any suggestions or improvements!
