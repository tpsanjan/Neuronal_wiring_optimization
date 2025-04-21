%% BASIC SETUP.
% Read in the inter-neuron connectivity dataset.
celeg = load('./data/celegans277.mat');
adj_mat = celeg.celegans277matrix;
N = size(adj_mat,1); % Number of neurons.

all_neurons = 1:N;

% Min_count constraint was kept earlier : when we knew less.
% We know better now. Still, legacy...
% The constraints are now added by the fixed sensory organs, muscle cells,
% etc., which don't move, and act as prior constraints instead of the 
% resrtictions imposed earlier to prevent excessive clumping.
is_min_count_constraint_on = 0;

% Get a container struct that contains a few parameters of the C. elegans
% container we have considered : length, width, etc.
celeg_container = celeg_container_info(is_min_count_constraint_on);

% Get neuromuscular and neurosensory data.
if is_min_count_constraint_on == 0,
    % Read in the neuromuscular and neurosensory information.
    % Format : col 1 - Neuron id; col 2 - x coord; col 3 - y coord
    fixed_pt_conns = csvread('./data/celeg_fixed_pt_conns.csv');

    % A more accessible form of the above information : indexable by neuron
    % index.
    % Format : key - Neuron id; val - (x,y) for each of the connected fixed
    % points
    fixed_pt_sets = cell(N,1);
    for i = 1:N,
        fixed_pt_sets{i} = fixed_pt_conns(fixed_pt_conns(:,1) == i, 2:end);
    end
    
    % An adjacency matrix corresponding to just the neurons that are connected
    % to at least one sensory organ/muscle (i.e. fixed points). Also stores
    % the indices of these neurons for future reference.
    fp_adj_mat = adj_mat;
    fp_neurons = [];
    nofp_neurons = [];
    for i = 1:N,
        % Remove elements which don't have peripheral connections.
        if numel(fixed_pt_sets{i}) == 0,
            fp_adj_mat(i,:) = 0;
            fp_adj_mat(:,i) = 0;
            nofp_neurons = [nofp_neurons; i];
        else
            fp_neurons = [fp_neurons; i];
        end
    end
else
    fixed_pt_sets = cell(N, 1); % all empty
end

% get an Nx2 array of neuron (x,y) coordinates.
% Assumption : neuron dia = 1 micron.
init_box_assgn = initial_neuron_box_assignments(celeg_container, N);
init_positions = initial_positions(init_box_assgn, celeg_container);

% Update box contents info
for neuron = 1:N,
    box = init_box_assgn(neuron,:);
    row = box(1); col = box(2);
    celeg_container.box_contents{row, col} = ...
                            [celeg_container.box_contents{row,col}; neuron];
end

%% OPTIMISATION : SIMULATED ANNEALING
if is_min_count_constraint_on == 1,
    free_neurons = all_neurons;
    [celeg_container, L, positions] = SARearrangement(celeg_container, init_positions, init_box_assgn, free_neurons,...
                                           adj_mat, fixed_pt_sets);
else
    free_neurons = fp_neurons;
    [celeg_container, L, positions] = SARearrangement(celeg_container, init_positions, init_box_assgn, free_neurons,...
                                           fp_adj_mat, fixed_pt_sets);

    cell_pops = get_cell_pops(positions, fp_neurons, celeg_container);
    display(cell_pops);
    sum(sum(cell_pops))
    figure;
    plot(L);

    free_neurons = nofp_neurons;
    [celeg_container, L, positions] = SARearrangement(celeg_container, positions, init_box_assgn, free_neurons,...
                                           adj_mat, fixed_pt_sets);
end


cell_pops = get_cell_pops(positions, all_neurons, celeg_container);
figure;
display(cell_pops);
sum(sum(cell_pops))
plot(L);