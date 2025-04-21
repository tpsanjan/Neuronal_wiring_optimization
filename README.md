# Neuronal_wiring_optimization
Theoretical project to decipher design principles of cognitive networks in _C. elegans_ done as part of graduate level course (BT 54xx: Computational Neuroscience) project during undergrduates studies at IIT-Madras in collaboartion with Shantanu Gupta. You may find our report thought provoking. Please feel free to reach out to explore the topic further!

====	
NEURONAL WIRING OPTIMISATION	
====

src folder contains code.
to run the program, MATLAB is required. The program expects the current
directory to be src. It may fail if it is run from another location.

	cd src
	matlab ./optimise_celeg_spatial_dist.m (the GUI equivalent)

In MATLAB, run the script ./src/optimise_celeg_spatial_dist.m.
It will output a spatial distribution in the form of a 2x20 histogram.
This will be done in 2 stages, as detailed in the report. Therefore, 2
histograms are expected as output from the script.

In case one wishes to run the code with the original constraint, which is
that each grid cell is forced to have at least 1 neuron, they can do that by
setting the "is_min_count_constraint_on" variable to 1 in the
./src/optimise_celeg_spatial_dist.m script. In this case, there will be only
one histogram as output.
