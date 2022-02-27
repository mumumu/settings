#!/usr/bin/env python3

import configparser
import os
import re
import sys

OKULAR_CONFIG_FILE = '$HOME/.config/okularrc'
config_filepath = os.path.expandvars(OKULAR_CONFIG_FILE)

if not os.path.exists(config_filepath):
    sys.exit(0)

config_string = ''
with open(config_filepath, 'r') as f:
    config_string = os.path.expandvars('[dummy_section]\n' + f.read())

config = configparser.ConfigParser()
config.read_string(config_string)

if config.has_section('Recent Files'):
    file_items = []
    for item in config.items('Recent Files'):
        if re.match('file', item[0]):
            file_items.append(item[1])
    if len(file_items) > 0:
        print(file_items[-1])
