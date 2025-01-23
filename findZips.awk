#!/usr/bin/env awk -f

# This code finds and saves relevant zip codes (those in NYC and NYS)

BEGIN{
    FS = ","

    inpath = "~/SemesterProject/uszips.csv"
    incommand = "cat " inpath

    outputNYC = "NYCzips.txt"
    outputNYS = "NYSzips.txt"

    # Go through zipcode data, save NYC and NYS zip codes
    while((incommand | getline) > 0){
	zip = $1
	if( $5 ~ "NY"  && tolower($12) ~ /(kings|new york|queens|bronx|richmond)/){
            print zip >outputNYC
        } else if ($5 ~ "NY"  && tolower($12) !~ /(kings|new york|queens|bronx|richmond)/){
	    print zip >outputNYS
	}
    }
}
