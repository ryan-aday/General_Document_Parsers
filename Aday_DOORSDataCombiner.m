clear all; clc;

fprintf("Ryan Aday\nDOORS Data Combiner\n");
fprintf("Version 1.0\n");

fprintf("Combines multiple DOORS CSV files together into a master .csv with replaced matched references.\n");


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
% Specify the folder containing the .csv files
mainFolderPath = 'your/folder/path/here';
DOORSReferencesFolderPath = 'your/references/folder/path/here';
outputFilePath = 'your/output/folder/here/with/.csv';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get a list of all .CSV files in the reference directory
csvFiles = dir(fullfile(DOORSReferencesFolderPath,'*.csv'));

% Initialize an empty cell array to store the data
combinedData = cell(0,0);

% Read each CSV file and concatenate its data
for i = 1:length(csvFiles)
	filePath = fullfile(DOORSReferencesFolderPath, csvFiles(i).name);
	data = readtable(filePath); % Read the CSV file
	data.Properties.VariableNames[2] = 'SecondColumn'; % Renamed to properly append tables
	combinedData = [combinedData; data];
end
	
combinedData_idx = combinedData{:, 1};


mainData = readtable(mainFolderPath); % Get a list of all .CSV files in the directory

% Looking for indices through hyphens, assuming the first 
% column of combinedData corresponds to the first column of the main data
for i = 1:size(mainData)
	mainDataArray = textscan(string(mainData(i, 2)), '%s', 'Delimiter', '{' ', '.'});
	
	
	mainDataVector = cellstr(char(mainDataArray{:}));
	logicalArray = contains(mainDataVector, '-');
	match_hyphen = mainDataVector(logicalArray);
	
	% Uses last char in char array for strfind comparison. If no hyphen
	% present in array, strfind skips to next line.
	
	match = mainDataArray{1}{end};
	
	for j = 1:length(match_hyphen)
		% Check to see if the character string w/ the hyphen has format
		% 'ABC-123'
		if isletter(extractBefore(match_hyphen{j}, '-')) & ...
		all(ismember(extractAfter(match_hyphen{1}, '-'), '1234567890'))
			match = match_hyphen{j};
		end
	end
	
	pos = strfind(combinedData_idx, match);
	matchingRowIndex = find(~cellfun(@isempty, pos));
	if height(unique(combinedData(matchingRowIndex, 1))) > 1
		matchingRowIndex = matchingRowIndex(1)
	end
	
	if ~isempty(matchingRowIndex)
		mainData(i, 2) combinedData(matchingRowIndex, 2);
	end
end

% Write the combined data to a new CSV file
writetable(mainData, outputFilePath);
disp(['Output CSV file saved at: ' outputFilePath]);

% Clear all vars
clearvars

