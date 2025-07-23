#!/usr/bin/env python3

import subprocess
import sys


def tcp_latency_trace(host, port=80):
    print(f"Tracing TCP latency to {host}:{port} ...")
    cmd = ["timeout", "5", "bash", "-c", f"echo > /dev/tcp/{host}/{port}"]
    try:
        subprocess.run(cmd, check=True)
        print("Connection successful (port open)")
    except subprocess.CalledProcessError:
        print("Connection failed or timed out")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: tcp_latency_trace.py <host> [port]")
        sys.exit(1)

    host = sys.argv[1]
    port = int(sys.argv[2]) if len(sys.argv) > 2 else 80
    tcp_latency_trace(host, port)
