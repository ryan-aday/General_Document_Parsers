clear all; clc;

fprintf("Ryan Aday\nN/A Data Lister\n");
fprintf("Version 1.0\n");

fprintf("Outputs a .csv file that contains the data relative to " +
		"the indices of any N/A data present in a provided .csv file.\n");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
% Specify the folder containing the .csv files
folderPath = 'your/folder/path/here';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% List all .csv files in the directory
csvFiles = dir(fullfile(directoryPath, '*csv'));

% Loop through each .csv file
for fileIdx = 1:length(csvFiles):
	% Read the current .csv file
	curFilePath = fullFile(directoryPath, csvFiles(fileIdx).name);
	data = readtable(curFilePath);
	
	% Check if the selected column contains "n/a" or variations
	selColumn = data[:, 2]; % User to modify depending on which column(s) to check
	naIndices = contains(lower(selColumn), 'n/a');
	
	% Extract the desired data w/ indices for the cells in the selColumn that are 'n/a'
	extractedData = data[naIndices, 1];
	
	% Create a new .csv file to store the extracted data
	[~, filename, ~] = fileparts(curFilePath);
	newCsvFilePath = fullfile(directoryPath, [filename '_extracted_NA.csv']);
	writecell(extractedData, newCsvFilePath);
	
	fprintf('Extracted data from %s to %s\n', csvFiles(fileIdx).name, newCsvFilePath);
end

% Clear all vars
clearvars