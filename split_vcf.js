const fs = require('fs');
const path = require('path');

// Function to split the VCF file
function splitVcfFile(inputFile, outputDirectory) {
  // Ensure the output directory exists
  if (!fs.existsSync(outputDirectory)) {
    fs.mkdirSync(outputDirectory, { recursive: true });
    console.log(`Created directory: ${outputDirectory}`);
  } else {
    console.log(`Directory already exists: ${outputDirectory}`);
  }

  // Read the input VCF file
  fs.readFile(inputFile, 'utf8', (err, data) => {
    if (err) {
      console.error(`Error reading file: ${err}`);
      return;
    }

    // Split the file into records
    const records = data.split(/(?=BEGIN:VCARD)/);

    // Write each record to a separate file
    records.forEach((record, index) => {
      if (record.trim()) { // Skip empty records
        const uidLine = record.split('\n')[1]
        const uid = uidLine.split(':')[1]
        const fileName = `${uid.trim()}.vcf`
        const filePath = path.join(outputDirectory, fileName);

        fs.writeFile(filePath, record, 'utf8', (err) => {
          if (err) {
            console.error(`Error writing file ${fileName}: ${err}`);
          } else {
            console.log(`Written file: ${fileName}`);
          }
        });
      }
    });
  });
}

// Usage example
const inputFile = '~/Downloads/contacts.vcf';  // Change to your input file path
const outputDirectory = './vcf_contacts';  // Change to your output directory path

splitVcfFile(inputFile, outputDirectory);
