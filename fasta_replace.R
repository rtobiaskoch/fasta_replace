#!/usr/bin/env Rscript

rm(list = ls())

# Load packages using pacman::p_load
if (!require("pacman")) install.packages("pacman")
pacman::p_load("seqinr", "stringr")

fn = list.files(path = "data_input/new",
                pattern = "fasta|fa",
                full.names = T)

if(length(fn) > 1){
  print("you can only have 1 file in the data_input/new folder")
}

if(length(fn) == 0){
  print("data_input/new folder is empty")
}


fasta_new = read.fasta(fn)

fn = list.files(path = "data_input/old",
                pattern = "fasta|fa",
                full.names = T)

if(length(fn) > 1){
  print("you can only have 1 file in the data_input/old folder")
}

if(length(fn) == 0){
  print("data_input/old folder is empty")
}

fasta_old = read.fasta(fn)
rm(fn)

pattern = readLines("data_input/new_to_old_pattern_match", warn = F)

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#extract the ID's from the new names for matching to the old name which is just the ID
new_match = str_extract(names(fasta_new), pattern)
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#>#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#>#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#get the location of the sequences in the old list that match to the new list
index_old = match(new_match, names(fasta_old), nomatch = 0)

#check to see if some items didn't match
if (0 %in% index_old) {
  print("You have missing IDs in your list.")
} else {
  print("All IDs are present in your list.")
}

#removes the sequences in the fasta old list and replaces it with the new
fasta_comb = c(fasta_new, fasta_old[-index_old])

#get positions of new names in combined file
index_comb = match(names(fasta_new), names(fasta_comb), nomatch = 0)

#get names of old, new, and combined name for double check
old_index = index_old
comb_index = index_comb
old_nm = names(fasta_old[index_old])
new_nm = names(fasta_new)
comb_nm = names(fasta_comb[index_comb])

name_check = data.frame(old_index, comb_index, old_nm, new_nm, comb_nm)

write.csv(name_check, "data_output/name_switch_report.csv")

if(!identical(new_nm, comb_nm)){
  print("the combined fasta name doesn't match the new names")
}

write.fasta(sequences = fasta_comb,
            names = names(fasta_comb),
            file.out = "data_output/fasta_combined.fasta")

