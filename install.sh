#!/bin/bash

if [ -z $PYLOT_HOME ] ; then
    PYLOT_HOME=$(pwd)
    echo "WARNING: \$PYLOT_HOME is not set; Setting it to ${PYLOT_HOME}"
else
    echo "INFO: \$PYLOT_HOME is set to ${PYLOT_HOME}"
fi

sudo apt-get -y update
sudo apt-get install -y git wget cmake python3-pip unzip clang libpng-dev libgeos-dev
# Install opencv separately because pip3 install doesn't install all libraries
# opencv requires.
sudo apt-get install -y python3-opencv
python3 -m pip install --user gdown

###############################################################################
# Get models & code bases we depend on
###############################################################################
cd $PYLOT_HOME/dependencies/
mkdir -p dependencies/models

###### Download CARLA-trained object detection models ######
echo "[x] Downloading the obstacle detection models..."
cd $PYLOT_HOME/dependencies/models
~/.local/bin/gdown https://drive.google.com/uc?id=1aT0q-HCz3KutvNGcc0Tleh88nK05unSe
unzip obstacle_detection.zip ; rm obstacle_detection.zip

###### Download the traffic light model ######
echo "[x] Downloading the traffic light detection models..."
cd $PYLOT_HOME/dependencies/models
mkdir -p traffic_light_detection/faster-rcnn ; cd traffic_light_detection/faster-rcnn
~/.local/bin/gdown https://drive.google.com/uc?id=1MbTIkh4KJubJN66-SurH1x725D9S-w50

###### Download the Lanenet lane detection model ######
echo "[x] Downloading the lane detection models..."
cd $PYLOT_HOME/dependencies/models
mkdir -p lane_detection ; cd lane_detection/
~/.local/bin/gdown https://drive.google.com/uc?id=1yILceTgUr1MTZ7Q2wanvQ0r8RbBf5ILD
unzip lanenet.zip ; rm lanenet.zip

###### Download the DRN segmentation cityscapes models ######
echo "[x] Downloading the segmentation models..."
cd $PYLOT_HOME/dependencies/models
mkdir -p segmentation/drn ; cd segmentation/drn
~/.local/bin/gdown https://drive.google.com/uc?id=1ST0WYo-uDS91jKDTaK21RvShWpayiyXN

###### Download the DASiamRPN object tracker models ######
echo "[x] Downloading the object tracking models..."
cd $PYLOT_HOME/dependencies/models
mkdir -p tracking/DASiamRPN ; cd tracking/DASiamRPN
# SiamRPNVOT.model
~/.local/bin/gdown https://drive.google.com/uc?id=1G9GtKpF36-AwjyRXVLH_gHvrfVSCZMa7
# SiamRPNBIG.model
~/.local/bin/gdown https://drive.google.com/uc?id=1_bIGtHYdAoTMS-hqOPE1j3KU-ON15cVV
# SiamRPNOTB.model
~/.local/bin/gdown https://drive.google.com/uc?id=18-LyMHVLhcx6qBWpUJEcPFoay1tSqURI

###### Download DeepSort models ######
# Download the real-world model.
cd $PYLOT_HOME/dependencies/models
mkdir -p tracking/deep-sort ; cd tracking/deep-sort
~/.local/bin/gdown https://drive.google.com/uc?id=1bB66hP9voDXuoBoaCcKYY7a8IYzMMs4P
cd ../
# Download the CARLA model.
mkdir deep-sort-carla ; cd deep-sort-carla
~/.local/bin/gdown https://drive.google.com/uc?id=14JLC_eo_Xpf2KbWffC96qtSAl2sXLyIl

###### Download CenterTrack models ######
cd $PYLOT_HOME/dependencies/models
mkdir -p tracking/center_track ; cd tracking/center_track
# MOT model
~/.local/bin/gdown https://drive.google.com/uc?id=1h_8Ts11rf0GQ4_n6FgmCeBuFcWrRjJfa
# KITTI model
~/.local/bin/gdown https://drive.google.com/uc?id=1kBX4AgQj7R7HvgMdbgBcwvIac-IFp95h
# nuScenes
~/.local/bin/gdown https://drive.google.com/uc?id=1e8zR1m1QMJne-Tjp-2iY_o81hn2CiQRt
# COCO model
~/.local/bin/gdown https://drive.google.com/uc?id=1tJCEJmdtYIh8VuN8CClGNws3YO7QGd40

###### Download QDTrack models ######
cd $PYLOT_HOME/dependencies/models
mkdir -p tracking/qd_track ; cd tracking/qd_track
~/.local/bin/gdown https://drive.google.com/uc?id=1YNAQgd8rMqqEG-fRj3VWlO4G5kdwJbxz

##### Download AnyNet depth estimation models #####
echo "[x] Downloading the depth estimation models..."
cd $PYLOT_HOME/dependencies/models
mkdir -p depth_estimation/AnyNet ; cd depth_estimation/AnyNet
~/.local/bin/gdown https://drive.google.com/uc?id=18Vi68rQO-vcBn3882vkumIWtGggZQDoU
unzip checkpoint.zip ; rm checkpoint.zip

###### Download the R2P2 prediction model ######
echo "[x] Downloading the prediction models..."
cd $PYLOT_HOME/dependencies/models
mkdir -p prediction/r2p2 ; cd prediction/r2p2
~/.local/bin/gdown https://drive.google.com/uc?id=1Ky_6daMnovoYxlQ8iTTGwJj_4bKd8EKn

#################### Download the code bases ####################
echo "[x] Compiling the planners..."
###### Build the FrenetOptimalTrajectory Planner ######
echo "[x] Compiling the Frenet Optimal Trajectory planner..."
cd $PYLOT_HOME/dependencies/
git clone https://github.com/erdos-project/frenet_optimal_trajectory_planner.git
cd frenet_optimal_trajectory_planner/
bash build.sh

###### Build the RRT* Planner ######
echo "[x] Compiling the RRT* planner..."
cd $PYLOT_HOME/dependencies/
git clone https://github.com/erdos-project/rrt_star_planner.git
cd rrt_star_planner/
bash build.sh

###### Build the Hybrid A* Planner ######
echo "[x] Compiling the Hybrid A* planner..."
cd $PYLOT_HOME/dependencies/
git clone https://github.com/erdos-project/hybrid_astar_planner.git
cd hybrid_astar_planner/
bash build.sh

###### Clone the Prediction Repository #####
echo "[x] Cloning the prediction code..."
cd $PYLOT_HOME/pylot/prediction/
git clone https://github.com/erdos-project/prediction.git

###### Get DeepSORT and SORT tracker code bases ######
echo "[x] Cloning the object tracking code..."
cd $PYLOT_HOME/dependencies/
git clone https://github.com/ICGog/nanonets_object_tracking.git
sudo apt-get install python3-tk
git clone https://github.com/ICGog/sort.git

###### Download the DaSiamRPN code ######
cd $PYLOT_HOME/dependencies/
git clone https://github.com/ICGog/DaSiamRPN.git

###### Install CenterTrack ######
cd $PYLOT_HOME/dependencies/
git clone https://github.com/ICGog/CenterTrack
cd CenterTrack/src/lib/model/networks/
git clone https://github.com/CharlesShang/DCNv2/
cd DCNv2
sudo apt-get install llvm-9
export LLVM_CONFIG=/usr/bin/llvm-config-9
python3 setup.py build develop --user

###### Install QDTrack ######
cd $PYLOT_HOME/dependencies/
git clone https://github.com/mageofboy/qdtrack.git
git clone https://github.com/open-mmlab/mmdetection.git
cd mmdetection
python3 setup.py develop #need to add mmcv
cd $PYLOT_HOME/dependencies/qdtrack
python3 setup.py develop

##### Download the Lanenet code #####
echo "[x] Cloning the lanenet lane detection code..."
cd $PYLOT_HOME/dependencies/
git clone https://github.com/ICGog/lanenet-lane-detection.git
mv lanenet-lane-detection lanenet

###### Download the DRN segmentation code ######
echo "[x] Cloning the DRN segmentation code..."
cd $PYLOT_HOME/dependencies/
git clone https://github.com/ICGog/drn.git

###### Download AnyNet depth estimation code #####
echo "[x] Cloning the AnyNet depth estimation code..."
cd $PYLOT_HOME/dependencies/
git clone https://github.com/mileyan/AnyNet.git
cd AnyNet/models/spn_t1/ ; python3 setup.py clean ; python3 setup.py build

###### Download the Carla simulator ######
echo "[x] Downloading the CARLA 0.9.10.1 simulator..."
cd $PYLOT_HOME/dependencies/
if [ "$1" != 'challenge' ] && [ ! -d "CARLA_0.9.10.1" ]; then
    mkdir CARLA_0.9.10.1
    cd CARLA_0.9.10.1
    wget https://carla-releases.s3.eu-west-3.amazonaws.com/Linux/CARLA_0.9.10.1.tar.gz
    tar -xvf CARLA_0.9.10.1.tar.gz
    rm CARLA_0.9.10.1.tar.gz
fi
