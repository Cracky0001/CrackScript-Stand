# CrackScript for the Stand Menu

## Overview

CrackScript is a Lua script developed exclusively for the Stand Menu in GTA V. This script offers several options for enhancement, including managing chat logs, kicking players for prohibited characters, and detecting IP addresses.

## Important!
- This script is still in development and not yet available in the repository function of Stand.
- You need to install `natives-1663599433` via the repository options.

## Installation

1. **Download and Extract**
   - Download the script files from [HERE](https://github.com/Cracky0001/CrackScript-Stand/releases/latest) and extract them into your Stand Lua Scripts directory.

2. **Directory Structure**
   - Ensure the directory structure looks like this:
     ```
     Stand/
     └── Lua Scripts/
         └── CrackScript/
             ├── CrackScript.lua
             └── lib/
                 └── crackscript/
                     ├── api.lua
                     └── functions.lua
     ```

3. **Load Script**
   - Load the CrackScript.lua file via the Lua script loader of the Stand Menu.

## Configuration

- **Logging Options**
  - Enable chat logging, kick for Russian and Chinese chats, and Anti IP Share through the `Chat Options` menu.
  
- **Toxic Options**
  - Perform kicks and crashes through the `Toxic Options` menu.

## Usage

1. **Log Chat Messages**
   - Enable `Log Chat` to log chat messages in `chat_log.txt`.
   
2. **Kick for Prohibited Characters**
   - Enable `Kick Russian/Chinese Chatters` to automatically kick players writing in Russian and Chinese.
   
3. **IP Detection**
   - Enable `Anti IP Share` to automatically react to players sharing IP addresses in the chat.
   
4. **Kick/Crash Players**
   - Use options under `Toxic Options` to kick or crash players.
        - `Anti Barcode` kicks all players with barcode-like names.
        - `Crash All` doesn't need an explanation.
        - `Kick All` neither does this.
        - `Further Options`
