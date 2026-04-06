T3rn0xSk0ll

T3rn0xSk0ll is a modular cybersecurity toolkit designed for educational purposes and authorized security testing.

This framework provides an interactive environment for performing network analysis, reconnaissance, cryptographic operations, and HTML vulnerability scanning.

---

Overview

T3rn0xSk0ll is built as a modular system where each component works independently but integrates into a unified interface.

The goal is to simulate a real-world cybersecurity toolkit with a clean structure and practical functionality.

---

Features

- Interactive terminal interface
- Modular system architecture
- Network analysis tools
- Reconnaissance utilities
- Cryptography tools
- HTML vulnerability scanner (HTMLMonster)
- Automatic permission handling
- Lightweight and optimized for Termux

---

Project Structure

T3rn0xSk0ll/
│
├── t3rn0xsk0ll.sh
├── modules/
│   ├── network.sh
│   ├── recon.sh
│   └── crypto.sh
│
├── tools/
│   ├── NetGhost/
│   ├── airskull/
│   ├── SpiderRecon/
│   ├── CrackForge/
│   └── HTMLMonster/
│
└── README.md

---

Modules

Network Module

Provides network scanning and analysis tools.

Includes:

- Nmap scanner (quick, full, custom ports)
- IP tools (lookup, resolve, public IP)
- NetGhost integration
- AirSkull wireless toolkit

---

Recon Module

Focused on gathering information about targets.

Includes:

- SpiderRecon
- CrackForge
- Whois lookup
- DNS lookup
- HTTP headers analysis
- Subdomain discovery
- Web analyzer

---

Crypto Module

Provides tools related to encryption and password security.

Includes:

- Password generator
- Password analyzer
- File encryption (AES-256)
- File decryption
- Hash generator (MD5, SHA1, SHA256)
- Random key generator

---

HTMLMonster

HTMLMonster is a custom tool that scans HTML files to detect potential vulnerabilities.

It detects:

- XSS (Cross-Site Scripting)
- Sensitive data exposure
- Unsafe JavaScript usage
- Weak forms (GET method)
- External scripts without validation
- Clickjacking risks
- Open redirects

---

Installation

Termux

pkg update && pkg upgrade
pkg install git
git clone https://github.com/rkzdevv/T3rn0xSk0ll.git
cd T3rn0xSk0ll
chmod -R 755 .
./t3rn0xsk0ll.sh

---

Dependencies

The system uses:

- nmap
- curl
- whois
- openssl-tool
- net-tools

Install manually if needed:

pkg install nmap curl whois openssl-tool net-tools

---

Usage

Start the framework:

./t3rn0xsk0ll.sh

Available commands:

network
recon
crypto
htmlmonster
help
clear
exit

---

Example Workflow

1. Open recon module
2. Collect target information
3. Use network module for scanning
4. Analyze security with crypto tools
5. Scan HTML using HTMLMonster

---

Security Notice

This tool is intended for:

- Learning cybersecurity
- Practicing ethical hacking
- Authorized penetration testing

Do NOT use against systems without permission.

---

Stability

Includes:

- Safe execution handling
- Automatic permission fixes
- Error prevention system

---

Future Improvements

- Plugin system
- Advanced reporting
- Auto dependency installer
- More scanning tools
- Improved UI

---

Contributing

You can contribute by:

- Reporting bugs
- Suggesting features
- Improving modules
- Expanding tools

---

Author

rkzdevv

---

Disclaimer

This project is for educational purposes only.

The author is not responsible for misuse or illegal activities.

---

Final Notes

T3rn0xSk0ll is designed to evolve.

Use it to learn, experiment, and improve your cybersecurity skills.

---

Respect the System

Think before executing.
Use responsibly.
Stay ethical.

---
