# General_Document_Parsers
MATLAB and Python scripts that can facilitate Word (.docx) and CSV file parsing.
All of these scripts are to be deployed by pasting them in a directory with the desired files.
When calling these files, only the filename/filepath is needed for ease of convenience. These are to be edited in the files themselves.

## MATLAB Scripts
### txt2csv Comparators:
Compares contents between .txt (main) and .csv (comparatator) file formats. Good for efficient non-categorical assignment from one text to the other.
#### Aday_Sorensen_Dice_txt2csv_Comparator.m: 
Uses the Sorensen-Dice algorithm. Ideal for large string comparisons, but not necessarily practical for assigning categories.
#### Aday_Damareau_Levenshtein_txt2csv_Comparator.m: 
Uses the Damareau-Levenshtein algorithm. Ideal for small to large string comparisons, with the downside of being much slower
depending on the size of strings being compared. When used for comparison assignments, string size is a heavy bias and makes it less reliable. I suggest using a CNN.
#### Aday_findNAIndices.m:
Exports a .csv file containing the relevant data from indices that match with N/A data from specified columns.
#### Aday_DOORSDataCombiner.m:
Combines multiple DOORS CSV files together into a master .csv with replaced matched references.

## Python Scripts
### Aday_findNAIndices.py:
Exports a .csv file containing the relevant data from indices that match with N/A data from specified columns.
#### Aday_DOORSDataCombiner.py:
Combines multiple DOORS CSV files together into a master .csv with replaced matched references.
### Aday_doc2csv.py:
Reads all .docx files within the directory where this script is placed, then creates a .csv file with 'Text' and 'Header' columns:
   - Text- All relevant sentences present within document
   - Header- The appropriate assigned header to each sentence
   - .csv file is named "output.csv" present in the same directory as this script
	
Nuances:
   - Deletes all files with "~"
     - These are cached files, and will not be interpreted correctly by python-docx
   - Deletes all sentences that has a header unique to that sentence (classification stratification)
   - Requires the following libraries:
	python-docx (For parsing through .docx documents)
	os (For file name recognition)
	pandas (For dataframe, csv write)
	numpy (For NaN removal)
	concurrent (For multithreading)
	tqdm (For progress bars)
	re (For regex)
