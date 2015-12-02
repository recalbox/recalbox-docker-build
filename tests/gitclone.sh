#!/bin/bash
docker run mikaxii/docker-buildroot clone-v3.2.sh
docker run mikaxii/docker-buildroot ls $REPO
