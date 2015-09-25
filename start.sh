#!/bin/bash
pm2 start ecosystem.json5 --name 4G --interpreter iced
pm2 save
