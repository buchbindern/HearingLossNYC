#!/usr/bin/env awk -f

# This code finds and saves percent of people above the age of 65 in NY zip codes

BEGIN{

    FS = "|"
    
    infile = "ageByZCTA5.gz"
    incmd  = "zcat " infile

    # Load in NYC and NYS zips
    while ((getline zip < "NYCzips.txt") > 0) {
	gsub(/"/, "", zip)
	nycZips[zip] = 1
    }
    while ((getline zip < "NYSzips.txt") > 0) {
	gsub(/"/, "", zip)
        nysZips[zip] = 1
    }

    # Go through age by zip data, save percent of people over age of 65 in NYC and NYS zipcodes
    while((incmd | getline) > 0){
	zipFull = $2
	zip = substr(zipFull, length(zipFull)-4)
   
	over65 = $137
      
	if (over65 >= 0 && over65 <= 100 && (zip in nycZips || zip in nysZips)){
	    print zip, over65 >"over65.txt"
	}
    }
}
