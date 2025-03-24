# Terminal Assistant

A lightweight, feature-rich bash script that serves as your personal assistant in the terminal.

## Features

- **System Information**: Quickly check system specs, disk usage, and running processes
- **Network Tools**: View IP addresses, active connections, and internet connectivity
- **File Management**: Search for files and manage archives with simple commands
- **Notes System**: Maintain a simple note-taking system directly from your terminal
- **Weather**: Get current weather conditions without leaving the terminal
- **System Updates**: Update your system packages with a single command
- **User-Friendly Interface**: Color-coded output and intuitive commands

## Installation

1. Clone this repository or download the script:
   ```bash
   git clone https://github.com/Johnbmon/terminal-assistant.git
   ```

2. Make the script executable:
   ```bash
   chmod +x terminal-assistant.sh
   ```

3. Run the assistant:
   ```bash
   ./terminal-assistant.sh
   ```

## Usage

Once running, the terminal assistant provides a simple prompt where you can enter commands:

```
assistant > 
```

Type `help` to see all available commands:

| Command    | Description                        |
|------------|------------------------------------|
| sys        | Show system information            |
| net        | Show network information           |
| disk       | Show disk space usage              |
| proc       | Show top processes by CPU/memory   |
| weather    | Show weather forecast              |
| notes      | Manage quick notes                 |
| search     | Search for files                   |
| compress   | Compress files/directories         |
| extract    | Extract compressed archives        |
| update     | Update system packages             |
| help       | Show help menu                     |
| exit       | Exit the assistant                 |

## Adding to your PATH

For easier access, you can add an alias to your `.bashrc` or `.zshrc` file:

```bash
echo "alias assistant='/path/to/terminal-assistant.sh'" >> ~/.bashrc
source ~/.bashrc
```

## Customization

The script is designed to be easily customizable. Feel free to add your own functions or modify existing ones to better suit your workflow.

## Requirements

- Bash shell
- Standard Unix utilities (most should be pre-installed on Linux/macOS)
- Optional: `curl` for weather functionality

## License

MIT License
