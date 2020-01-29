# prepare csv for webapp

# get nasa master
master <- read.csv(url("https://data.nasa.gov/api/views/gh4g-9sfh/rows.csv?accessType=DOWNLOAD&bom=true&format=true"))

dta <- data.frame(master["id"], master["mass..g."], master["year"], master["reclat"], master["reclong"])

# round year
dta["year"] <- substr(dta$year, 7, 10)

# purge invalid entries
dta["reclat"] <- as.numeric(dta$reclat)
dta["reclong"] <- as.numeric(dta$reclong)
dta["mass..g."] <- as.numeric(dta$mass..g.)
dta["year"] <- as.numeric(dta$year)
dta <- dta[{dta$reclat!=0.0 & dta$reclong!=0.0 & dta$mass..g.!=0 & dta$year!=0},]
dta <- na.omit(dta)

# save csv
write.table(dta, file = "meteorite.csv", sep = ";", col.names = TRUE, row.names = FALSE)
