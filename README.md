# awk_linux_scripts
## My handy linux scripts
I wrote them to make it easier for me to update my linux (zorin OS) machine from the terminal.

### Scripts:
- **showhardware.sh**: Displays detailed hardware information, including:
  - System information
  - Hardware details (bus info)
  - BIOS and system enclosure information
  - CPU information
  - Memory usage

### Setup:
1) Extract files from the zip file.
2) Open a terminal.
3) Create a directory for the scripts:
   ```bash
   mkdir -p ~/scripts
   ```
4) Move the extracted files into `~/scripts`:
   ```bash
   mv /path/to/extracted/files/* ~/scripts
   ```
5) Make the scripts executable:
   ```bash
   chmod og+x ~/scripts/*.sh
   ```
6) Add the scripts directory to your PATH:
   ```bash
   echo 'export PATH=~/scripts:$PATH' >> ~/.bash_profile
   ```
7) Reload your shell configuration:
   ```bash
   source ~/.bash_profile
   ```
