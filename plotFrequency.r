library('ggplot2')

options(warn = - 1, width = 150)
print("Starting plotFrequency.r")


args <- commandArgs(trailingOnly = TRUE)

input = args[1]
day = args[2]
hour = args[3]

findOutlier <- function(data, cutoff = 3) {
    ## Calculate the sd
    sds <- apply(data, 2, sd, na.rm = TRUE)
    ## Identify the cells with value greater than cutoff * sd (column wise)
    result <- mapply(function(d, s) {
        which(d > cutoff * s)
    }, data, sds)
    result
}

removeOutlier <- function(data, outliers) {
    result <- mapply(function(d, o) {
        res <- d
        res[o] <- NA
        return(res)
    }, data, outliers)
    return(as.data.frame(result))
}

data.path = file.path('results', 'data', paste(input, '.csv', sep = ''))

print(paste('Read csv data from directory', data.path))

data <- read.table(data.path, header = T, sep = ",")

outliers <- findOutlier(data)
dataFixed <- removeOutlier(data, outliers)

ggplot(data = dataFixed, aes(x = range, y = frequency)) +
    geom_bar(stat = "identity", fill = "steelblue") +
    scale_fill_brewer(palette = "Reds") +
    ggtitle(paste('Frequency against range for ', input, hour, day)) +
    theme_light()

ggsave(file = file.path('results', 'graphs', paste(input, '-', day, '-', hour, '.png', sep = '')))

