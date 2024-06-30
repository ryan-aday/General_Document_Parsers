print("Ryan Aday\nFind Requirement Text\n")
print("Version 1.0\n")

print("Quick and dirty script to find requirements based on patterns in a .docx or .pdf document.\n")

try:
    import re
    import fitz  # PyMuPDF
    import pandas as pd
    from docx import Document
except ImportError:
    sys.exit("""
        You need the re, fitz, pandas, and docx libraries.
        To install these libraries, please enter:
        pip install re fitz pandas docx
        """)

# Function to extract text from .docx file
def extract_text_from_docx(docx_path):
    doc = Document(docx_path)
    full_text = []
    for para in doc.paragraphs:
        full_text.append(para.text)
    return '\n'.join(full_text)

# Function to extract text from .pdf file
def extract_text_from_pdf(pdf_path):
    doc = fitz.open(pdf_path)
    full_text = []
    for page_num in range(len(doc)):
        page = doc.load_page(page_num)
        full_text.append(page.get_text("text"))
    return '\n'.join(full_text)

# Function to extract requirements from text
def extract_requirements(text):
    # Regular expressions for different requirement formats
    requirement_patterns = [
        r'(\w+):\s*([\d\.]+[A-Za-z]*)',  # Pattern like 'Voltage: 300V'
        r'The\s+(\w+)\s+of\s+this\s+device\s+is\s+rated\s+for\s+([\d\.]+[A-Za-z]*)'  # Pattern like 'The output voltage of this device is rated for 300V'
    ]

    requirements = []

    for pattern in requirement_patterns:
        matches = re.findall(pattern, text)
        for match in matches:
            requirements.append({'Type': match[0], 'Value': match[1]})

    return requirements

# Function to save requirements to CSV
def save_requirements_to_csv(requirements, output_csv_path):
    df = pd.DataFrame(requirements)
    df.to_csv(output_csv_path, index=False)

# Main function
def main(docx_path, pdf_path, output_csv_path):
    text = ""
    
    if docx_path:
        text += extract_text_from_docx(docx_path)
    
    if pdf_path:
        text += extract_text_from_pdf(pdf_path)
    
    requirements = extract_requirements(text)
    
    save_requirements_to_csv(requirements, output_csv_path)

# Example usage
docx_path = 'example.docx'  # Path to the .docx file
pdf_path = 'example.pdf'    # Path to the .pdf file
output_csv_path = 'requirements.csv'  # Output CSV file path

main(docx_path, pdf_path, output_csv_path)
