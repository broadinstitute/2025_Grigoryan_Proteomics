# Notes on the inputs

Inside of the **proteomics_data** there are the following files:

- **24-00101.1_2025-01-16_405_24-00101.1 (HESI_Broad)_789__Excel.xlsx**: this is the raw data downloaded from the Nomic Bio data portal. It contains various forms of raw and processed data in different sheets. 
- **24-00101.1_2025-01-16_405_24-00101.1 (HESI_Broad)_789__analyte_df.csv**: these are notes on the profiled proteins, also downloaded from the Nomic Bio data portal. This data is not ingested into the pipeline, but it is included in case we want to refer to it in the future. 
- **normalized_signal.csv**: this file is data from the "Normalized nELISA Signal" sheet in the raw data Excel file. It has been slightly modified to make it machine readable. Uniprot IDs are used to label the proteins (any column without the "Metadata_" prefix).
- **protein_metadata**: this file maps the Uniprot IDs to nELISA Nomic IDs, protein names, and the maximum nElisa signal. It was also derived from the overall raw data Excel file.