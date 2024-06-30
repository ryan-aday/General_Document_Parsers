print("Ryan Aday\nFind Requirement Text- SpaCy\n")
print("Version 1.0\n")

print("Quick and dirty script to find requirements based on patterns in a .docx or .pdf document using an NLP (SpaCy).\n")


try:
    import spacy
    import fitz  # PyMuPDF
    import pandas as pd
    from docx import Document
except ImportError:
    sys.exit("""
        You need the re, fitz, pandas, and docx libraries.
        To install these libraries, please enter:
        pip install spacy fitz pandas docx
        """)

# Load spaCy model
nlp = spacy.load("en_core_web_sm")

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

# Function to extract requirements using spaCy
def extract_requirements(text):
    doc = nlp(text)
    requirements = []

    for ent in doc.ents:
        if ent.label_ in ["QUANTITY", "CARDINAL", "MONEY", "PERCENT"]:
            # Find the context around the entity
            start = max(0, ent.start_char - 50)
            end = min(len(text), ent.end_char + 50)
            context = text[start:end]
            # Extract the type of requirement from the context
            type_match = re.search(r'(\w+):', context)
            if not type_match:
                type_match = re.search(r'The\s+(\w+)', context)
            if type_match:
                req_type = type_match.group(1)
                requirements.append({'Type': req_type, 'Value': ent.text})
    
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
