#!/usr/bin/env python3

import matplotlib.pyplot as plt
import random
import math

# Fuction to load zipcodes
def loadZips(filename):
    with open(filename, 'r') as f:
        return set(line.strip().strip('"').strip("'") for line in f)

# Funciton to load data
def loadData(filename):
    data = {}
    with open(filename, 'r') as f:
        for line in f:
            parts = line.strip().split()
            zipCode, val = parts
            if val == "-":
                val = 0
            data[zipCode] = float(val)

    return data

# Load NYC and NYS zips
NYCzips = loadZips("NYCzips.txt")
NYSzips = loadZips("NYSzips.txt")

# Load % of population above the age of 65
over65data = loadData("over65.txt")

# Load doctor per capita data
docPerCap = loadData("docsPerCapita.txt")

# Prep data
nycPoints = {"x": [], "y": []}
nysPoints = {"x": [], "y": []}

# Loop through Doctors, catagorizing them into correct group (NYC or NYS)
for zipCode, percent in docPerCap.items():
    over65 = over65data.get(zipCode)
    if zipCode in NYCzips:
        nycPoints["x"].append(percent)
        nycPoints["y"].append(over65)
    if zipCode in NYSzips:
        nysPoints["x"].append(percent)
        nysPoints["y"].append(over65)
        
# Plot data
fig = plt.figure(figsize=(10, 6))

# NYC points
plt.scatter(
    nycPoints["x"], nycPoints["y"], c="blue", label = "NYC", alpha = 0.7
    )

# NYS points
plt.scatter(
    nysPoints["x"], nysPoints["y"], c="red", label = "NYS", alpha = 0.7
    )

plt.xscale("log")
# Set axis limits
#plt.xlim(-5, 100)
plt.ylim(-5, 45)

# Labels
plt.xlabel("Percentage Over 65")
plt.ylabel("Doctors per Capita")
plt.title("Doctors vs. Percentage of Population Over 65 by ZIP Code")
plt.legend()
plt.grid(alpha=0.3)
plt.tight_layout()

fig.savefig("plot.pdf")
