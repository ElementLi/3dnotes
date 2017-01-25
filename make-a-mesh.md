### add camera to OpenMVG DB
`openMVG_main_ParseDatabase -i /usr/local/bin/cameraGenerated.txt -m "Canon EOS 600D[NUL][NUL][NUL][NUL][NUL][NUL][NUL][NUL][NUL]" -b Canon`
^ didn't work, added `Canon EOS Rebel T3i;22.3` to `sensor_width_camera_database.txt` instead

### use openMVG to get the .json camera setting file
`openMVG_main_SfMInit_ImageListing -i images/ -d /opt/openMVG/src/openMVG/exif/sensor_width_database/sensor_width_camera_database.txt -o ./matches`

### use openMVG to extract features
`openMVG_main_ComputeFeatures -i ./matches/sfm_data.json -o ./matches`

### use openMVG to get camera position matches
`openMVG_main_ComputeMatches -i ./matches/sfm_data.json -o ./matches`

### get Structure from Motion
`openMVG_main_IncrementalSfM -i ./matches/sfm_data.json -o ./sfm -m ./matches`

### Convert SfM to openMVS format
`mkdir mvs && openMVG_main_openMVG2openMVS -i sfm/sfm_data.bin -d mvs/images -o mvs/scene.mvs`




### Dense Point-Cloud Reconstruction
`DensifyPointCloud ./mvs/scene.mvs`

	if got `killed` it bacause run out of memory
	set --resolution-level to 3 will lower the computation
	`DensifyPointCloud ./mvs/scene.mvs --resolution-level 3`

### Rough Mesh Reconstruction
`ReconstructMesh ./mvs/scene_dense.mvs`

### Mesh Refinement
`RefineMesh ./mvs/scene_dense_mesh.mvs`

### Mesh Texturing
`TextureMesh ./mvs/scene_dense_mesh_refine.mvs`
