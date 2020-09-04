---
title: Research

# The Research page
# v2.0
# https://github.com/cotes2020/jekyll-theme-chirpy
# © 2017-2019 Cotes Chung
# MIT License
---

![Schneider et al 2020](/assets/img/tabs/Schneider-et-al-2020-horizontal.png)
*Image from Schneider et. al 2020*

# Ph.D Research
## Adding Magnetohydrodynamics (MHD) to Cholla (Spring 2020 - Present)
I am working with [Professor Evan Schneider](https://evaneschneider.org) to
further develop [Cholla](https://github.com/cholla-hydro/cholla) a code for
simulating astrophysical hydrodynamics. Cholla is a 3D hydrodynamics code that
uses GPUs in parallel to greatly accelerate solving the equations of hydrodynamics.
I am working on adding [magnetohydrodynamics (MHD)](https://en.wikipedia.org/wiki/Magnetohydrodynamics)
to Cholla to allow us to simulate the affects of electromagnetic fields on
galactic winds. This will lay the groundwork for adding cosmic rays to the
model in the future.

# Masters Thesis:
## Time Series Photometry of the Symbiotic Star V1825 Aql and New Variable Stars in Aquila (Fall 2016-Spring 2018)
My masters research was to conclusively classify and determine the characteristics of V1835 Aql, a symbiotic star
(SySt). The reason that SySt’s are so important is that they are a hypothesized progenitor of Type Ia supernovae. SySt
consist of a red giant and a compact object, typically a white dwarf star, orbiting each at distances greater than 1au.
Often the compact object is rapidly accreting material from its companion and this accretion could lead to the white
dwarf exceeding the Chandrasekhar limit and becoming a Type Ia supernova. In addition to studying SySt’s in general, I
took over the responsibility of making observations of this object via the PROMPT robotic telescopes located in Chile.
With this data we found the orbital period of the binary to be 419<span>&#177;</span>4 days and that its variability
is due to a combination of tidal deformation and polychromatism, i.e. surface heating by of the red giant by its
compact companion star.

**Links:**  <br>
[Masters Thesis](/assets/pdf/Thesis-Final-Version-(small-file).pdf)  <br>
[Poster](/assets/pdf/V1835Aql-Poster.pdf) (Contains preliminary results only, for full results see the upcoming paper.
Poster was presented at a Ohio Academy of Science conference)


# Undergraduate Research
## Biodynamic Imaging and Data Management (Summers of 2015 & 2016)
I worked with Professor David Nolte at Purdue University. His group is developing a technique called Biodynamic Imaging
(BDI) to create holograms of tissue that differentiate between living and dead cells. This process can be used to
determine, within a few hours, if specific chemotherapy drugs will work for a patient by testing different combinations
on tumor biopsies instead of waiting for weeks or months to see if the drugs given to the patient are effective against
a patient’s tumor. My primary responsibilities were to build and test an experimental 2-channel BDI system which has the
potential to provide significantly increased spatial and temporal resolution over the current BDI system. I was also
responsible for developing an entirely new workflow for analyzing the group’s experimental data. Before my arrival,
their ~100TB of experimental data was stored on numerous expensive and unreliable USB drives and each experiment was
analyzed with slow single threaded Matlab program on an underpowered desktop computer, a process which took 4-5 hours to
complete. I designed and implemented a new method of processing their data so now when a BDI experiment is run,
the raw data is automatically uploaded to Purdue’s networked
storage. A few commands run a script that analyzes the raw data on one of Purdue’s supercomputers, then the data is
automatically uploaded to archival storage and a copy is sent to a local machine for easy access. Working in Dr. Nolte’s
lab gave me the expertise to apply high-performance computational techniques to solving problems in physics that I have
used extensively in my later research.