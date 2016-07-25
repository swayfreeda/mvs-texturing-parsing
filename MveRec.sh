#MveRec.sh
#  copyright 2015 sway

# A script for reconstructing textured model from a set of images

echo "Usage:"
echo "./MveRec.sh  <imageDir> <sceneDir>"
echo "WARNINGS: BASE_PATH must be changed to your own system!"

BASE_PATH="."

#make scene
MAKE_SCENE_PATH=$BASE_PATH/elibs/mve/apps/makescene/makescene

#structure from motion
SFM_RECON_PATH=$BASE_PATH/elibs/mve/apps/sfmrecon/sfmrecon

#depth map reconstruction
DEPTH_MAP_RECON_PATH=$BASE_PATH/elibs/mve/apps/dmrecon/dmrecon

#scene2pset-- create point cloud by fusioning depth maps
SCENE2PSET_PATH=$BASE_PATH/elibs/mve/apps/scene2pset/scene2pset

#float surface reconstruction
FSS_RECON_PATH=$BASE_PATH/elibs/mve/apps/fssrecon/fssrecon

#mesh clean
MESH_CLEAN_PATH=$BASE_PATH/elibs/mve/apps/meshclean/meshclean

#texture reconstruction
TEXTURE_RECON_PATH=$BASE_PATH/build/apps/texrecon/texrecon


#input image dir
if [ $# -eq 1 ]
then
     IMAGE_DIR=$1;
     echo "Using image dir '$1'"
     
     SCENE_DIR=BASE_PATH/scene
     echo "using image dir '$SCENE_DIR'"
     
else 
     echo "Please input image dir"
fi
     
if [ $# -eq 2 ]
then
     IMAGE_DIR=$1;
     echo "Using image dir '$1'"
     
     SCENE_DIR=$2;
     echo "using image dir '$2'"   
else 
     echo "Please input image dir"
fi


echo "********************************Start**********************************"

#output point cloud path
POINTCLOUD_PATH="$SCENE_DIR/pset-L2.ply"

#output surface model
SURFACE_PATH="$SCENE_DIR/surface-L2.ply"

#output clean surface mode
SURFACE_CLEAN_PATH="$SCENE_DIR/surface-clean-L2.ply"

#textured surface mode
TEXTURED_PATH="$SCENE_DIR/textured"

#making scene
$MAKE_SCENE_PATH  -i $IMAGE_DIR $SCENE_DIR

#structure from motion
$SFM_RECON_PATH $SCENE_DIR

#depth map reconstrurction
$DEPTH_MAP_RECON_PATH -s2 $SCENE_DIR

#creating point cloud by fusioning depth maps
echo $POINTCLOUD_PATH
$SCENE2PSET_PATH -F2 $SCENE_DIR $POINTCLOUD_PATH

#surface reconstruction
$FSS_RECON_PATH $POINTCLOUD_PATH $SURFACE_PATH

#clean the surface model
$MESH_CLEAN_PATH -t10 $SURFACE_PATH $SURFACE_CLEAN_PATH

#texture reconstruction
$TEXTURE_RECON_PATH "$SCENE_DIR::undistorted" $SURFACE_CLEAN_PATH $TEXTURED_PATH


