---
title:      HLLD Debugging and Exam                     # Title
author:     Robert Caddy                                # Author Name
date:       2020-11-20 16:00:00 -0400                   # Date
categories: [Course Work, MHD]                          # Catagories, no more than 2
tags:       [HLLD, Riemann Solver, General Relativity]  # Tags, any number
pin:        false                                       # Should this post be pinned?
toc:        true                                        # Table of Contents?
math:       false                                       # Does this post contain math?
# image:      /assets/img/...                             # Header image path
---

# General Relativity (GR)
We started on Black Holes this week and had a midterm exam. It went well but
studying for it took a lot of time.

# HLLD Solver
As of last week I finished writing the HLLD solver so I spent part of last week
and the first few days of this week writing the tools I need for testing and
debugging. I updated my visualizer program for MHD and 3D hydro and updated my
Riemann tester to test the HLLD solver using the MHD shock tubes from Brio & Wu
1988 and Dai & Woodward 1994. Both contain slow magnetosonic waves that the HLLD
solver doesn't resolve so I am hoping that between the two of them I can test
the HLLD solver independently of the
[VL+CT](https://www.sciencedirect.com/science/article/abs/pii/S1384107608000754?via%3Dihub)
integrator.

To test the HLLD solver I have been running it on it's own (without any
interface reconstruction) by feeding it the interface states and a position
divided by time value. This should trace out all the characteristics except the
slow magnetosonic wave since the HLLD solver doesn't include it. However, unlike
a full simulation no rarefaction fans or other gradual features will be
resolved, they will just look like discontinuities. Below you can see the
results of running the current version of my code compared to the fiducial plots
from [Miyoshi & Kusano
2005](https://www.sciencedirect.com/science/article/pii/S0021999105001142?via%3Dihub).
The little spike near the center and the wave near 0.1 are slow magnetosonic
waves so we don't expect to resolve them until I'm running a full simulation. As
you can see the waves appear to be in the right spots but there are clearly bugs
that are preventing the HLLD solver from getting the correct values in each
state. Finding and fixing those is my next goal.

![HLLD Bugged](/assets/img/2020-post-assets/11-November/HLLD-buggy output.png)
*The current output of my HLLD solver using the Brio & Wu MHD shock tube with \\( \gamma = 5/3 \\)*

![fiducial](/assets/img/2020-post-assets/11-November/Brio-Wu-MHD-shock-tube-fiducial.png)
*The fiducial version of the shock tube from [Miyoshi & Kusano 2005](https://www.sciencedirect.com/science/article/pii/S0021999105001142?via%3Dihub)*



## Useful links
Original HLLD paper: [Miyoshi & Kusano 2005](https://www.sciencedirect.com/science/article/pii/S0021999105001142?via%3Dihub)

Blog post on the HLLD Algorithm: [HLLD Algorithm]({% post_url 2020-10-23-HLLD-Algorithm%})

Original VL+CT paper: [Stone & Gardiner 2009](https://www.sciencedirect.com/science/article/abs/pii/S1384107608000754?via%3Dihub)
