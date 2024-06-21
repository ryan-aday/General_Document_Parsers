def printHeader():
	print("""\
	Ryan Aday
	docx2csv
	
	Version 1.0
	
	Objective:
	- Read all .docx files within the directory where this script is placed
	- Create a .csv file with 'Text' and 'Header' columns:
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
	""");
	
def process_docx(file_path):
	print(file_path)
	document = Document(file_path);
	header = None;
	rows = [];
	
	for para in tqdm(document.paragraphs):
		% print(para.style.name) % Check to see how text is styled in .docx
		if para.style.name.startswith('Head'):
			header = para.text;
		elif not para.style.name.startswith(("table, "toc")) and para.text.strip():
			for sentence in re.split(r'(?<=\.) ', para.text.strip()):
				if not header is None:
					rows.append((sentence, header));
	return rows
	
def main(input_folder, output_csv):
	# Clear terminal
	os.system('cls', if os.name == 'nt' else 'clear');
	printHeader();
	
	with ThreadPoolExecutor() as executor:
		all_rows = [];
		for filename in os.listdir(input_folder):
		# Delete all files that contain "~" (cached files)
		if "~" in filename:
			os.remove(filename);
		elif filename.endswith('.docx'):
			file_path = os.path.join(input_folder, filename);
			all_rows.extend(executor.submit(process_docx, file_path).result());
		else:
			pass
			
	# Force UTF-8 encoding to prevent misinterprete characters
	with open(output_csv, 'w', newline='', encoding="utf-8") as csvfile:
		df = pd.DataFrame(all_rows, columns=['Text', 'Header']);
		df.replace('', np.nan, inplace=True);
		df.drop_duplicates(subset=['Text'], keep="first", inplace=True);
		df.dropna(inplace=True);
		df = df[df.duplicated(subset=['Header', keep=False);
		df.to_csv(csvfile, encoding="UTF-8", index=False);
		
if __name__ == '__main__':
	try:
		import os, re;
		import pandas as pd;
		import numpy as np;
		from docx import Document;
		from docx.shared import Pt;
		from concurrent.futures import ThreadPoolExecutor;
		from tqdm import tqdm;
	except ImportError:
		sys.exit("""
			You need the os, re, python-docx, concurrent, and tqdm libraries.
			To install these libraries, please enter:
			pip install os re python-docx concurrent tqdm
			""");
	input_folder = os.getcwd();
	output_csv = "output_csv";
	
	try:
		main(input_folder, output_csv);
		print(f"CSV file '{output_csv}' generated successfully.");
	except:
		sys.exit("""
			Something is broken...
			However, make sure this script is pasted in the repository containing
			the desired .docx files.
			""")
