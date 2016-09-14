Xtreme3D version history
------------------------
v3.1.0 (by Gecko) - ??/??/??

* Improved Freeform API, added an ability to manually construct Freeforms from vertices and triangles. Freeforms now can be saved to file (GLSM, OBJ, STL, or NMF)
* New file formats support: CSM and LMTS (these were absent in 3.0), X, ASE, DXS (experimental, without lightmaps for now)
* Ragdoll support in ODE
* Added Movement object that can be used to define smooth interpolated movement paths for objects
* Improved BumpShader, added shadows and automatic tangent space support
* Improved PhongShader, added diffuse texture support

v3.0.0 (by Gecko, Rutraple aka Hacker, Ghost) - 25/08/2016

The library was reimplemented from scratch because of lacking source code for original Xtreme3D from Xception.

* GLSL shaders support
* Shadow maps
* Antialiasing for Viewer (2x, 4x, NVIDIA Quincunx support)
* MemoryViewer for fast offscreen rendering
* Proxy and MultiProxy objects
* New file formats support: LOD, B3D, MDC, WRL 
* Tag support for MD3 models
* Animation blending for Actors
* Object-to-bone parenting
* Material scripts support
* Improved BumpShader (rewrote shader in GLSL, added specular shading and parallax mapping)
* TexCombineShader
* PhongShader
* Perlin noise procedural textures
* Linear waves for Water object
* New geometric promitives - frustum, dodecahedron, icosahedron, teapot
* Improved mesh explosion effect, added an ability to reset mesh to its normal state
* Grid rendering
* Debug rendering of Dummycubes
* New Camera functions
* An ability to copy object matrices, and also manually set them
* Many improvements in DCE, added terrain support, gravity and impulses for dynamic objects
* Working Freeforms and Terrains in ODE, an ability to set local positions for geometries
* Saving renders to BMP
* Text reading function

v2.0.2.0 (by Xception) - 16/02/2007

* New ODE functions
* New Actor functions
* Dynamic Collision Engine (DCE)
* CLOD terrain

v2.0.0.0 (by Xception) - 11/02/2007

* Model/Scene loaders with lightmaps:
  * Blitz3D scene loader(with hierarchy) and special portal/zone culling functions
  * Cartography Shop CSM loader
  * Pulsar LM Tools LMTS loader
  * DeleD DMF loader partially: no lightmaps, only triangles and quads supported 
* Function to load lightmap coordinates from a second (lightmapped) model
* Function to split a freeform's internal meshes into single freeforms
* ODE Physics engine support 
* Dynamic Quadtree and Octree for visibility culling and collision checking
* Static and dynamic cubemaps
* Render to texture
* Loading resources from compressed PAK archives
* Bump-/Normalmapping Shader
* Celshader
* HiddenlineShader
* Multimaterialshader
* Multitexturing
* Texture format selection
* Texture compression selection
* Texture filtering quality selection
* DDS (DXT1, DXT3, DXT5) texture support
* Actor bone manipulation functions
* Multiple viewers and material libraries useable