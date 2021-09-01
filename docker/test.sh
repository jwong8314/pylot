#!/bin/bash
# Build the Pylot image
nvidia-docker build -t erdosproject/pylot37 -f Dockerfile37 .
nvidia-docker run -itd --name pylot37-jw erdosproject/pylot37 /bin/bash
nvidia-docker exec -it pylot37-jw /bin/bash
