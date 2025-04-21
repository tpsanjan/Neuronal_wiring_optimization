""" Read in the neuron dataset and associate numbers to neuron labels. """

from pprint import pprint as pp
import csv

name_to_index = {}
name_to_pos = {} # 2-dimensional position

def name_to_vpos(name):
		vpos = 5.0
		if name[-1] == 'R':
				vpos = 0.0
		elif name[-1] == 'L':
				vpos = 10.0
		
		return vpos

# Read in positions and names.
with open('./NeuronType.csv') as n_file:
	first_line = n_file.readline()
	elements = map(lambda line : line.strip().split(','),
				   n_file.readlines())
	names_positions = map(lambda l : (l[0], l[1]), elements)
	
	for i in range(len(names_positions)):
		name = names_positions[i][0]
		name_to_index[name] = i

		# neuron is left or right or none going along A-P axis.
		# A-P axis assumed L-to-R.
		# left = 1.0; right = -1.0; none = 0.0
		vpos = name_to_vpos(name)        
		name_to_pos[name] = (1000.0 * float(names_positions[i][1]), vpos)

N = len(name_to_index.keys())
adj_mat = [[0 for i in range(N)] for j in range(N)]

# find the fixed sensors, muscles etc.
import re
fps = []
d_name_to_index = {}
with open('./NeuronFixedPoints_copy.csv') as n_file:
	first_line = n_file.readline()
	
	# find dynamic dataset indices
	with open('./dynamic_idx.txt') as f:
		lines = f.readlines()
		
		i = 1
		for line in lines:
			d_name_to_index[line.strip()] = i
			i = i + 1
			
	conns = [line.split(',') for line in n_file]
	for conn in conns:
		name = conn[0]
		hpos = float(conn[2]) * 1000.0
		ctype = re.findall("[a-zA-Z]+", conn[1])[0] # has to match!
		vpos = name_to_vpos(name)
				
		try:
			fps.append([d_name_to_index[name], hpos, vpos])
		except KeyError:
			pass # for now.

# form adjacency matrix
fp_adj_mat = [[0 for i in range(N)] for j in range(N)]
with open('./NeuronConnect.csv') as n_file:
	first_line = n_file.readline()
	edges = [line.split(',') for line in n_file.readlines()]

	errors = 0
	non_empty_neurons = set(map(lambda L : L[0], fps))
	for edge in edges:
		try:
			n1 = name_to_index[edge[0]]
			n2 = name_to_index[edge[1]]				
			adj_mat[n1][n2] = 1
			if n1 in non_empty_neurons and n2 in non_empty_neurons:
				fp_adj_mat[n1][n2] = 1
				
		except KeyError:
			pp(edge)
			errors += 1

# output index map so that others can make sense of this.
with open('celeg_index_map.csv', 'w') as out:
	for name in name_to_index:
		out.write(name + ',' + str(name_to_index[name]) + '\n')

# output the positions as well. Each line is : name,X,Y.
with open('celeg_positions.csv', 'w') as out:
	for name in name_to_index:
		out.write(str(name_to_index[name]) + ',' + str(name_to_pos[name])[1:-1] + '\n')

# output adjacency matrix as csv
with open('celeg_adj_mat.csv', 'w') as out:
	writer = csv.writer(out)
	writer.writerows(adj_mat)

# output fp_adjacency matrix as csv
with open('celeg_fp_adj_mat.csv', 'w') as out:
	writer = csv.writer(out)
	writer.writerows(fp_adj_mat)

# output connections to fixed sensors, muscles, etc. as <index, x, y>
with open('celeg_fixed_pt_conns.csv', 'w') as out:
	writer = csv.writer(out)
	writer.writerows(fps)
