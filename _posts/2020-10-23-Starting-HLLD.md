---
title:      Starting On HLLD Riemann Solver  # Title
author:     Robert Caddy               # Author Name
date:       2020-10-23 17:00:00 -0400  # Date
categories: [MHD, Course Work]     # Catagories, no more than 2
tags:       [HLLD, Riemann Solver, General Relativity, Intel, Workshop, Dev tools]                     # Tags, any number
pin:        false                      # Should this post be pinned?
toc:        true                       # Table of Contents?
math:       false                      # Does this post contain math?
# image:      /assets/img/...            # Header image path
---

# General Relativity (GR)
We had an exam Monday and started into GR on Wednesday. Pretty uneventful.

# Intel Workshop
On Tuesday I went to the Intel Dev Tools workshop hosted at the Pitt CRC. It had
an excellent discussion of Intel compilers, Data Parallel C++, and a few other
topics

# HLLD Riemann Solver
I'm starting on writing an HLLD Riemann Solver this week. I've been basing my
work on [Miyoshi & Kusano
2005](https://www.sciencedirect.com/science/article/pii/S0021999105001142?via%3Dihub)
which is the original paper where the HLLD Riemann solver was introduced. See my
post on the [HLLD Algorithm]({% post_url 2020-10-23-HLLD-Algorithm
%}) for the details. I plan to start implementing it into my [1D hydro
code](https://github.com/bcaddy/hydro-sandbox) next week and hopefully will have
a fully working 1D MHD code in the next few weeks.