import os
import pandas as pd

def main():
    print("Ryan Aday\nDOORS Data Combiner")
    print("Version 1.0\n")
    print("Combines multiple DOORS CSV files together into a master .csv with replaced matched references.\n")

	try:
		import os, re;
		import pandas as pd;

	except ImportError:
		sys.exit("""
			You need the os and pandas libraries.
			To install these libraries, please enter:
			pip install os pandas
			""");

    ###############################################################################################################
    # User Inputs
	###############################################################################################################
    main_folder_path = 'your/folder/path/here'
    doors_references_folder_path = 'your/references/folder/path/here'
	output_file_path = 'your/output/folder/here/with/.csv'
	###############################################################################################################
    # Get a list of all .CSV files in the reference directory
    csv_files = [f for f in os.listdir(doors_references_folder_path) if f.endswith('.csv')]
    
    # Initialize an empty list to store the data
    combined_data = pd.DataFrame()

    # Read each CSV file and concatenate its data
    for file_name in csv_files:
        file_path = os.path.join(doors_references_folder_path, file_name)
        data = pd.read_csv(file_path)  # Read the CSV file
        data.columns.values[1] = 'SecondColumn'  # Renamed to properly append tables
        combined_data = pd.concat([combined_data, data], ignore_index=True)
    
    combined_data_idx = combined_data.iloc[:, 0]
    
    main_data = pd.read_csv(main_folder_path)  # Read the main CSV file

    # Looking for indices through hyphens, assuming the first
    # column of combined_data corresponds to the first column of the main data
    for i in range(len(main_data)):
        main_data_array = main_data.iloc[i, 1].split('{', ', .')
        
        main_data_vector = [str(element) for element in main_data_array]
        logical_array = ['-' in element for element in main_data_vector]
        match_hyphen = [element for element, logical in zip(main_data_vector, logical_array) if logical]
        
        # Uses last element in array for comparison. If no hyphen present, skips to next line.
        match = main_data_array[-1]
        
        for match_hyp in match_hyphen:
            # Check to see if the character string with the hyphen has format 'ABC-123'
            if match_hyp.split('-')[0].isalpha() and match_hyp.split('-')[1].isdigit():
                match = match_hyp
        
        pos = combined_data_idx.str.find(match)
        matching_row_index = [index for index, value in enumerate(pos) if value != -1]
        
        if len(combined_data.iloc[matching_row_index, 0].unique()) > 1:
            matching_row_index = [matching_row_index[0]]
        
        if matching_row_index:
            main_data.iloc[i, 1] = combined_data.iloc[matching_row_index[0], 1]

    # Write the combined data to a new CSV file
    main_data.to_csv(output_file_path, index=False)
    print(f'Output CSV file saved at: {output_file_path}')

if __name__ == "__main__":
    main()
