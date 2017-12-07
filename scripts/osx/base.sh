#!/bin/bash

# Enable verbose boot mode
nvram boot-args="-v"

# Disable Spotlight
mdutil -a -i off
