library('ggplot2')
library(dplyr)

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

dayName <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
dayLookup <- data.frame(dayName)

timeName <- c("1:00", "2:00", "3:00", "4:00", "5:00", "6:00", "7:00", "8:00", "9:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00", "0:00")
timeLookup <- data.frame(timeName)

dayOfWeek <- dayLookup$dayName[as.numeric(day)]
hourOfDay <- timeLookup$timeName[as.numeric(hour)]

print(paste('day is', day, 'day of week is', dayOfWeek))
print(paste('hour is', hour, 'hour of day', hourOfDay))

data.path = file.path('results', 'data', paste(input, '.csv', sep = ''))

print(paste('Read csv data from directory', data.path))

print(paste('Filtered on day', day, 'hour', hour))

data <- read.table(data.path, header = T, sep = ",")

outliers <- findOutlier(data)
dataFixed <- removeOutlier(data, outliers)

ggplot(data = dataFixed, aes(x = range, y = frequency)) +
    geom_bar(stat = "identity", fill = "steelblue") +
    ggtitle(paste('Frequency against range for ', input, hourOfDay, dayOfWeek)) +
    scale_x_continuous(breaks = seq(0, 30, 2), limits = c(0, 30)) +
    theme_light()

outputLocation <- file.path('results', 'graphs', paste(input, '-', dayOfWeek, '-', hour, '.png', sep = ''))

print(paste('Writing graph to ', outputLocation))

ggsave(file = outputLocation)

