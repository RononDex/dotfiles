#!/usr/bin/env python3
"""
Load https://github.com/sepluginloader/PluginLoader on Linux after Space Engineers 1.202 (Automatons update)
1. Download this file (`SpaceEngineersLauncher.py`) into the `Bin64` folder of the game
2. Give it execute permissions (`chmod a+x SpaceEngineersLoader.py`)
3. Set the steam launch options for Space Engineers to `./SpaceEngineersLauncher.py %command%`
https://gist.github.com/opekope2/e02db7e526dadff0813a6ea2aebf820b
"""
import sys
import subprocess

def replace_with_launcher(arg):
    if arg.endswith('SpaceEngineers.exe'):
        arg = arg[:-len('SpaceEngineers.exe')]
        return arg + 'SpaceEngineersLauncher.exe'
    return arg

se_launcher_args = [replace_with_launcher(arg) for arg in sys.argv[1::]]

sys.exit(subprocess.call(se_launcher_args))
