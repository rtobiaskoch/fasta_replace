# Load packages using pacman::p_load
if (!require("pacman")) install.packages("pacman")
pacman::p_load("seqinr", "stringr")

fn = list.files(path = "data_input/new",
                pattern = "fasta|fa",
                full.names = T)

fasta_new = read.fasta(fn)

fn = list.files(path = "data_input/old",
                pattern = "fasta|fa",
                full.names = T)

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
index = match(new_match, names(fasta_old), nomatch = 0)

#check to see if some items didn't match
if (0 %in% index) {
  print("You have missing IDs in your list.")
} else {
  print("All IDs are present in your list.")
}

#create a new fasta list that will get the matching sequences replaced
fasta_comb = fasta_old


#where the sequence ID's matched replace the sequence
for(i in seq_along(fasta_new)){
  fasta_comb[[index[i]]] = fasta_new[[i]]
}

write.fasta(sequences = fasta_comb,
            names = names(fasta_comb),
            file.out = "data_output/fasta_combined.fasta")

