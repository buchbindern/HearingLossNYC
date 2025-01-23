all: plot.pdf

clean:
	rm NYCzips.txt NYSzips.txt earDocsNYC.txt earDocsNYS.txt docsPerCapita.txt over65.txt plot.pdf

# Find NYC zips - look through zipcodes, if its in a city county save it to NYCzips
NYCzips.txt: findZips.awk uszips.csv
	gawk -f findZips.awk

# Find NYS zips - look through zipcodes, if its not in a city county save it to NYSzips
NYSzips.txt: findZips.awk uszips.csv
	gawk -f findZips.awk

# Find ear doctors in NYC - go through npi data, if NPI is related to ear doctors
# and the doctor is living in a NYC zipcode, save the zip and count of doctors there
earDocsNYC.txt: findEarDocsZips.awk npi.gz NYCzips.txt NYSzips.txt
	gawk -f findEarDocsZips.awk

# Find ear doctors in NYS - go through npi data, if NPI is related to ear doctors
# and the doctor is living in a NYS zipcode, save the zip and count of doctors there
earDocsNYS.txt: findEarDocsZips.awk npi.gz NYCzips.txt NYSzips.txt
	gawk -f findEarDocsZips.awk

# Calculate the ear doctors per capita in each zip
# Go through zipcode data, for each NYC and NYS zip get the population size, number of doctors and get the doctors per capita
docsPerCapita.txt: findDocPerCapita.awk uszips.csv NYCzips.txt NYSzips.txt earDocsNYC.txt earDocsNYS.txt
	gawk -f findDocPerCapita

# Find percent of people over the age of 65 in each NYC and NYS zip code
over65.txt: over65.awk ageByZCTA5.gz NYCzips.txt NYSzips.txt
	gawk -f over65.awk

# Plot the findings - x axis is percent over 65, y axis is doctors per capita, each point is a zipcode
plot.pdf: plotit.py NYCzips.txt NYSzips.txt over65.txt docsPerCapita.txt
	python3 plotit.py
