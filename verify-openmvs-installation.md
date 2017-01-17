### mount the sample data folder to openmvs container
`docker run -it -v /home/docker/osx/somefolder:/opt/somefolder openmvs:image bash`

### use openMVG to get the .json camera setting file
`openMVG_main_SfMInit_ImageListing -i images/ -d /opt/openMVG/src/openMVG/exif/sensor_width_database/sensor_width_camera_database.txt -o ./matches`

### use openMVG to extract features
`openMVG_main_ComputeFeatures -i ./matches/sfm_data.json -o ./matches`

### use openMVG to get camera position matches
`openMVG_main_ComputeMatches -i ./matches/sfm_data.json -o ./matches -g e`

### get Structure from Motion
`openMVG_main_IncrementalSfM -i ./matches/sfm_data.json -o ./sfm -m ./matches`
or
`openMVG_main_GlobalSfM -i ./matches/sfm_data.json -o ./sfm -m ./matches`

### Convert SfM to openMVS format
`openMVG_main_openMVG2openMVS -i sfm/sfm_data.bin -d mvs/images -o mvs/scene.mvs`

### Dense Point-Cloud Reconstruction
`DensifyPointCloud ./mvs/scene.mvs`

### Rough Mesh Reconstruction
`ReconstructMesh ./mvs/scene_dense.mvs`

### Mesh Refinement
`RefineMesh ./mvs/scene_dense_mesh.mvs`

### Mesh Texturing
`TextureMesh ./mvs/scene_dense_mesh_refine.mvs`