#!/bin/bash
nvidia-docker stop pylot37-jw
nvidia-docker rm pylot37-jw
nvidia-docker image rm erdosproject/pylot37
