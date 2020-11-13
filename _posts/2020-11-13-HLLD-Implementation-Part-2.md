---
title:      HLLD Implemention Part 2   # Title
author:     Robert Caddy               # Author Name
date:       2020-11-13 17:00:00 -0400  # Date
categories: [MHD, Course Work]         # Catagories, no more than 2
tags:       [HLLD, Riemann Solver, General Relativity]  # Tags, any number
pin:        false                      # Should this post be pinned?
toc:        true                       # Table of Contents?
math:       false                      # Does this post contain math?
# image:      /assets/img/...          # Header image path
---


# General Relativity (GR)
Working on Schwartzchild solution to Einsteins field equation and how to work with
Schwartzchild coordinate and metric. GR this week took most of Monday and all of
Thursday. We have an exam next week so I likely won't get much else done.

# HLLD Solver
I finished writing the HLLD solver, the tester for it, and the visualization
script. Debugging still needs to be done and that will be my ongoing work. I
have a GR exam next week though so I'll likely be busy with that.

Actually implementing the HLLD solver turned out to be significantly more
complex than anticipated. I originally thought it would be a simple extension of
the HLLC solver but that was not the case. The L and R states were similar, just
a slightly different form of the flux equation. The star state was significantly
more complicated to implement and was made much more complicated by the needs of
the double star state. The double star state requires the entire star state and
star flux from one side as expected but it also requires the velocity and
magnetic field vectors from the other sides star state. Splitting out the
calculations for velocity and magnetic field into their own function partly
solved that issue. The other major complicating factor was that in different
spots in the algorithm you explicitly need the left or right star state and in
other spots you just need to state for whichever side you're on. Making sure the
logic worked for all of these constraints made the implementation significantly
more complex than the implementation of the HLLC Riemann solver.


## Useful links
Original HLLD paper: [Miyoshi & Kusano 2005](https://www.sciencedirect.com/science/article/pii/S0021999105001142?via%3Dihub)

Blog post on the HLLD Algorithm: [HLLD Algorithm]({% post_url 2020-10-23-HLLD-Algorithm%})

Original VL+CT paper: [Stone & Gardiner 2009](https://www.sciencedirect.com/science/article/abs/pii/S1384107608000754?via%3Dihub)
