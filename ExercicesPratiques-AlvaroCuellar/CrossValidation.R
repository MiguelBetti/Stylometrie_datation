# Load necessary library
library(stylo)

# Request parameters from the user
corpus_dir <- readline(prompt = "Enter the path to the corpus folder: ")
mfw_min <- as.integer(readline(prompt = "Enter the minimum number of MFW: "))
mfw_max <- as.integer(readline(prompt = "Enter the maximum number of MFW: "))
mfw_interval <- as.integer(readline(prompt = "Enter the interval between MFW: "))
classification_method <- readline(prompt = "Enter the classification method: ")
output_file_name <- readline(prompt = "Enter the name for the output file (include .txt): ")

# Load and process the corpus
texts <- load.corpus.and.parse(files = "all", corpus.dir = corpus_dir, ngram.size = 1)

# Create frequency list
freq.list <- make.frequency.list(texts, head = 12000)
word.frequencies = make.table.of.frequencies(corpus = texts, features = freq.list)

# Loop for culling, MFW, and cross-validation
tabla <- perform.culling(word.frequencies, 0)

for (i in seq(mfw_min, mfw_max, by = mfw_interval)) {
  
  # Select the top i MFW for analysis
  tabla1 <- tabla[, 1:i]
  
  # Apply cross-validation
  resultados <- crossv(tabla1, cv.mode = "leaveoneout", classification.method = classification_method)
  
  # Calculate and record the percentage of successful classifications
  porcentaje <- round(sum(resultados$y) / length(resultados$y), 4)
  
  # Format the output text
  output_text <- sprintf("%d MFW %.2f%% success\n", i, porcentaje * 100)
  
  # Save the results to a text file specified by the user
  cat(output_text, file = output_file_name, append = TRUE)
}
