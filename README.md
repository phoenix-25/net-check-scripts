# net-check-scripts

A collection of standalone scripts to detect and analyze network bottlenecks and perform common network diagnostics.

---

## Overview

This project provides a set of lightweight Bash and Python scripts to help system administrators and DevOps engineers quickly diagnose network issues such as latency, packet loss, service availability, HTTP response, DNS problems, and port accessibility.

The scripts are designed to be simple, modular, and easy to run independently or as part of an automated workflow.

---

## Features

- Ping latency and jitter measurement  
- HTTP status and header inspection  
- TCP latency tracing  
- DNS troubleshooting  
- Port scanning (basic)  
- Simple bottleneck detection and reporting  

---

## Installation

No installation required. Just clone this repository:

```bash
git clone https://github.com/your-username/net-check-scripts.git
cd net-check-scripts/scripts
````

Make sure the scripts are executable:

```bash
chmod +x *.sh
chmod +x *.py
```

---

## Usage

Each script can be run standalone. Examples:

```bash
./ping_test.sh 8.8.8.8 20
./http_inspect.sh https://example.com
python3 tcp_latency_trace.py example.com 443
```

You can also run all checks and generate summary reports with:

```bash
./run_all_checks.sh
```

For detailed usage and options, see the `docs/usage.md` file.

---

## Logs and Reports

The `logs/` and `reports/` directories are created automatically at runtime to store diagnostic output and summary files.

These folders contain:

* Raw logs from each check run (inside `logs/`)
* Summary reports in `.txt` and `.csv` format (inside `reports/`)

To ensure these folders are tracked in Git but remain empty in the repository, we use `.gitkeep` placeholder files.

**Note:** Actual `.log`, `.txt`, and `.csv` files are excluded from Git via `.gitignore`.

---

## Contributing

Contributions are welcome! Please see `CONTRIBUTING.md` for guidelines.

---

## License

This project is licensed under the MIT License — see the `LICENSE` file for details.

```
