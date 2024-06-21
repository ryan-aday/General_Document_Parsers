clear all; clc;
warning('off');

fprintf("Ryan Aday\nDamareau-Levenshtein File Comparer\n");
fprintf("Version 1.0");
fprintf("Compares a main .txt file with content and indices with a .csv " + ...
		"\nfile with content and indices to find the best match from the " + ...
		".csv file using the Damareau-Levenshtein algorithm.\n");
fprintf("NOTE: Run this for either long or short strings of text only." + ...
		"\nDownside is speed relative to the size of datasets fed.\n");
		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
% Specify the folder containing the .csv files
folderPath = 'your/folder/path/here';

% Specify tolerance threshold of minimum distance for matches
% NOTE: Found by experiementation to be 0.52;
DL_tol = 0.52;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get a list of all files in the folder
% NOTE: Written with the assumption that there are only 2 files present.
csvFiles = dir(fullfile(folderPath, '*.csv');
txtFiles = dir(fullfile(folderPath, '*.txt');
% Initialize variables
mainFile = fullfile(folderPath, txtFiles(1).name);
compareFile = fullfile(folderPath, csvFiles(1).name);

% Read selected file data
mainData = readTable(mainFile);
compareData = readTable(compareFile);

% Extract relevant data columns
main_2 = mainData(:, 4);
main_2_idx = mainData(:, 2);
compare_1 = compareData(:, 2);
compare_1_idx = compareData(:, 1);

% Initialize a cell array to keep the most similar rows
similarRows = cell(main(length(main_2), 1);
similarRowsIdx = cell(main(length(main_2), 1);
distance = cell(main(length(main_2), 1);

% Create cluster for parfor
% Documentation: https://www.mathworks.com/help/parallel-computing/parfor.html
fprintf("Setting up the parcluster for parfor.\n");
fprintf("Execution speed heavily dependent on hardware.");
cluster = parcluster;
fprintf("\nParcluster created.\n");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Start timer
tic

% Iterate through each row of main_2
fprintf("\nPerforming Damareau-Levenshtein (O(m*n/prll processes)) time...\n\n");
parfor i = 1:length(main_2)
	% Compare main_2 with all rows of compare1 (from other .csv files)
	% Implement Sorensen-Dice algorithm here (you can use external functions)
	% Find the most similar row in compare1
	
	% Iterate for the absolute minDist between all_compare_1
	main_row = main_2(1);
	if length(char(main_row)) < 5 } | ...
		contains(char(main_row), 'figure', 'IgnoreCase', true)
	else
		min_dist= Inf;
		min_dist_idx = -1;
		
		for j = 1:length(compare_1)
			DL_length = lev(char(main_row), char(compare_1(j)));
			
			if DL_length < min_dist
				min_dist = DL_length;
				min_dist_idx = j;
			end
		end


		if min_dist <= DL_tol
			similarRows{i} = char(compare_1(min_dist_idx));
			similarRowsIdx{i} = char(compare_1_idx(min_dist_idx));
		else
			similarRows{i} = char(compare_1(min_dist_idx));
			similarRowsIdx{i} = 'N/A';
		end
		distance{i} = min_dist;
		
	end
	% Status timer (edited out for speed)
	%fprintf('%f percent done...\n', i/length(main_2) * 100.00);
end

% End timer
toc

% Create output table
outputTable = table(main_2_idx, main_2, similarRows, similarRowsIdx, ...
		distance, ...
		'VariableNames', {'main_2_idx', 'main_2', 'compare_1', ...
		'compare_1_idx', 'max_correlation'}];
		
% Write to the output .csv table
[~, fileName, ~] = fileparts(compareFile);
outputFilePath = fullfile(folderPath, [filename, '_output.csv']);
writetable(outputTable, outputFilePath);

disp(['Output saved to: ' outputFilePath]);	

% Clear all vars except outputTable and compare_1
clearvars -except outputTable compare_1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Damareau-Levenshtein algorithm
function d = sSimilarity(s, t)
	% Levenshtein distance between strings and char arrays.
	% lev(s,t) is the number of deletions, insertions
	% or substitutions required to transform s to t.
	% www.wikipedia.org/wiki/Levenshtein_distance

	s = char(s);
	t = char(t);
	m = length(s);
	n = length(t);
	x = 0:n;
	y = zeros(n, n+1);
	
	for i = 1:m
		y(1) = i;
		for j = 1:n
			c = (s(i) ~= t(j)); % c == 0 if chars match, 1 if not
			y(j+1) = min([y(j)+1
				x(j+1)+1
				x(j)+c]);
		end
		% Swap
		[x, y] = deal(y, x);
	end
	d = x(n+1)/m;
end