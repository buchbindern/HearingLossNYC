#!/usr/bin/env awk -f

# This code finds the number of ear doctors in each zip code in NYC and NYS

BEGIN {
    FS = "|"
    OFS = ","
    inpath = "~/SemesterProject/npi.gz"
    incommand = "zcat " inpath

    # Load in NYC and NYS zips
    while ((getline zip < "NYCzips.txt") > 0) {
	gsub(/"/, "", zip)
        nycZips[zip] = 1
    }
    while ((getline zip < "NYSzips.txt") > 0) {
	gsub(/"/, "", zip)
        nysZips[zip] = 1
    }

    # Go through npi data, if the npi relates to ear doctors
    # keep track of amount of doctors found per NYC or NYS zip
    while((incommand | getline) > 0){
	if($48 ~ /^(231H00000X|231HA2400X|231HA2500X|237600000X|237700000X|235500000X|2355A2700X|207YX0901X)$/) {
	    zipC = substr($25, 0, 5)
	    if (zipC in nycZips) {
		nycCounts[zipC]++
	    } else if (zipC in nysZips) {
		nysCounts[zipC]++
	    }
	}
    }

    # Save the info we found in a txt file
    for (zip in nycCounts) {
        print zip, nycCounts[zip] > "earDocsNYC.txt"
    }
    for (zip in nysCounts) {
        print zip, nysCounts[zip] > "earDocsNYS.txt"
    }
}
