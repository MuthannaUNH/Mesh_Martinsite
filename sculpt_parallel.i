$ Input file created: Wed Jul 10 15:01:55 2024


BEGIN SCULPT
  diatom_file = sculpt_parallel.diatom

  xmin = -0.7215
  ymin = -0.7215
  zmin = 0

  xmax = 0.7215
  ymax = 0.7215
  zmax = 0.416
  
  nelx = 128
  nely = 128
  nelz = 37
  
  $ if you use cell_size, may not respect xmin xmax etc.

  $ adapt setings
  adapt_type = material
  adapt_material = 10000 2 0.0001 0     0 $ crack
  adapt_material = 20000 3 0.0001 0.008 0 $ crack tip
  
  smooth = no_surface_projections $ same as fixed_bbox, but more internal smoothing.
  csmooth = neighbor_surface_normal
  
  $ coloring optimization. mesh improvement
  max_pcol_iters = 100
  pcol_threshold = 0.25
  
  $ scaled jacobian optimization. mesh improvement
  max_opt_iters = 10
  opt_threshold = 0.6    $ smooth cells with jacobian less than this
  curve_opt_thresh = 0.6 $ min metric at which curves will not be honored
  
  $ laplacian optimization. mesh improvement. too much may cause problems
  laplacian_iters = 3
  
  $ pillowing. did not help, mesh is to complex?
  $pillow_surfaces = true 
  $pillow_curves = true
  $pillow_curve_thresh = 0.3
  $pillow_curve_layers = 3
  
  $ defeature setings, try to remove sharp corners and non manifold conditions
  defeature = 1
  defeature_iters = 20 $ recommend more than 10, will stop early if complete
  min_vol_cells = 4
  $defeature_bbox = true
  defeature_bbox = false

  $ degenerate settings. collapse edges on bad elements, does not seem to recognize deg_threshold
  $deg_threshold = 0.1
  $max_deg_iters = 5
  
$  $ garunteed quality improvement. apparently more effective with jacobi laplace and coloring turned off. did not help either way.
$  max_gq_iters = 100
$  gq_threshold = 0.25
$  $ turn off jacobi,laplace,coloring
$  max_opt_iters = 0
$  laplacian_iters = 0
$  max_pcol_iters = 0
  
  exodus_file = sculpt_parallel.diatom_result

END SCULPT
