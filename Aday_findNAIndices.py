print("Ryan Aday")
print("N/A Data Lister")
print("Version 1.0")

print("Outputs a .csv file that contains the data relative to " +
      "the indices of any N/A data present in a provided .csv file.\n")

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
folder_path = 'your/folder/path/here'
###############################################################################################################

# List all .csv files in the directory
csv_files = [f for f in os.listdir(folder_path) if f.endswith('.csv')]

# Loop through each .csv file
for file_name in csv_files:
    # Read the current .csv file
    cur_file_path = os.path.join(folder_path, file_name)
    data = pd.read_csv(cur_file_path)
    
    # Check if the selected column contains "n/a" or variations
    sel_column = data.iloc[:, 1]  # User to modify depending on which column(s) to check
    na_indices = sel_column.str.lower().str.contains('n/a', na=False)
    
    # Extract the desired data w/ indices for the cells in the selColumn that are 'n/a'
    extracted_data = data.loc[na_indices, data.columns[0]]
    
    # Create a new .csv file to store the extracted data
    filename, _ = os.path.splitext(file_name)
    new_csv_file_path = os.path.join(folder_path, f'{filename}_extracted_NA.csv')
    extracted_data.to_csv(new_csv_file_path, index=False)
    
    print(f'Extracted data from {file_name} to {new_csv_file_path}')