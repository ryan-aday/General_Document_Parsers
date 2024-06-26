clear all; clc;
warning('off');

fprintf("Ryan Aday\nSorensen Dice File Comparer\n");
fprintf("Version 1.0");
fprintf("Compares a main .txt file with content and indices with a .csv " + ...
		"\nfile with content and indices to find the best match from the " + ...
		".csv file using the Sorensen-Dice algorithm.\n");
fprintf("NOTE: Run this for long strings of text only." + ...
		"\nThis fails to accurately map for smaller string " + ...
		"sizes due to higher significance for matched pairs" + ...
		"relative to overall size.\n");
		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
% Specify the folder containing the .csv files
folderPath = 'your/folder/path/here';

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
fprintf("\nPerforming Sorensen Dice (O(n/prll processes)) time...\n\n");
parfor i = 1:length(main_2)
	% Compare main_2 with all rows of compare1 (from other .csv files)
	% Implement Sorensen-Dice algorithm here (you can use external functions)
	% Find the most similar row in compare1
	
	% Iterate for the absolute minDist between all_compare_1
	main_row = main_2(1);
	if length(char(main_row)) < 5 } | ...
		contains(char(main_row), 'figure', 'IgnoreCase', true)
	else
		max_corr = -Inf;
		max_corr_idx = -1;
		
		for j = 1:length(compare_1)
			corr = sSimilarity(char(main_row), char(compare_1(j)));
			
			if corr > max_corr
				max_corr = corr;
				max_corr_idx = j;
			end
		end
		
		similarRows{i} = char(compare_1(max_corr_idx));
		similarRowsIdx{i} = char(compare_1_idx(max_corr_idx));
		distance{i} = max_corr;
		
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
%% Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sorensen-Dice algorithm
function similarity = sSimilarity(sa1, sa2)
	% Compare two strings to see how similar they are.
	% Answer is returned as a value of 0 to 1.
	% 1 indicates a perfect similarity (100%) while 0 indicates no similarity (0%).
	% Algorithm source site:
	% www.catalysoft.com/articles/StrikeAMatch.html
	
	% Convert input strings to lowercase and remove whitespace (unused in this instance)
	%s1 = regexprep(sa1, '\s', '');
	%s2 = regexprep(sa2, '\s', '');
	
	% Get pairs of adjacent letters in each string
	pairs_s1 = sa1(1:end-1) + sa1(2:end);
	pairs_s2 = sa2(1:end-1) + sa2(2:end);
	
	% Calculate intersection of pairs
	common_pairs = intersect(pairs_s1, pairs_s2);
	
	% Calculate similarity
	similarity_num = 2 * numel(common_pairs);
	similarity_den = numel(pairs_s1) + numel(pairs_s2);
	similarity = similarity_num / similarity_den;
	
end