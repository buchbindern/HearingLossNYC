#!/usr/bin/env awk -f

# This code calculates the docters per capita in NYC and NYS

BEGIN {
    
    FS = ","
    infile = "uszips.csv"
    incmd  = "cat " infile

    # Load in NYC and NYS zips, Doctors in NYC and NYS
    while((getline zip < "NYCzips.txt") > 0){
	gsub(/"/, "", zip)
	nycZips[zip] = 1
    }
    while((getline zip < "NYSzips.txt") > 0){
	gsub(/"/, "", zip)
	nysZips[zip] = 1
    }
    while((getline < "earDocsNYC.txt") > 0){
	earDocsNYC[$1] = $2
    }
    while ((getline < "earDocsNYS.txt") > 0){
	earDocsNYS[$1] = $2
    }

    # Go through US Zipcode data, get zip code and population size, skip invalid data
    while ((incmd | getline) > 0){
	zip = $1
	gsub(/"/, "", zip)
	pop = $9
	gsub(/"/, "", pop)
       	if (pop !~ /^[0-9]+$/ || pop <= 0) {
	    continue
	}
	
	# if the zip code is in NYC or NYS (what we are focused on), get the amount of ear doctors in that zip
	if(zip in nycZips || zip in nysZips){
	    if(zip in earDocsNYC){
		docs = earDocsNYC[zip]
	    }else if(zip in earDocsNYS){
		docs = earDocsNYS[zip]
	    }else{
		continue
	    }
	    # calculate the doctors per capita, save it
	    perCap = docs / pop
	    print zip, perCap >"docsPerCapita.txt"
	}
    }
}
