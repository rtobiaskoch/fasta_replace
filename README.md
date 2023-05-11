# fasta_replace
Purpose: replace old sequences with new sequences that may have a different name and
 replace those matched sequences with the new ones

**Instructions:**
1. drop new fasta file to do the replacing in data_input/new
2. drop old fasta files with the names that you want replaced in the data_input/old
3. run the fasta_replace.R script and the file you want will be in the data_output.
*4. if the pattern to match the new names with the old changes you would 
need to figure out what the regex pattern is (ask chatgpt) then edit the data_input/new_to_old_pattern_match file.
