---
title:      MHD Implemention Prep  # Title
author:     Robert Caddy               # Author Name
date:       2020-10-30 16:00:00 -0400  # Date
categories: [MHD, Course Work]     # Catagories, no more than 2
tags:       [HLLD, Riemann Solver, General Relativity, Presentation, dotfiles]                     # Tags, any number
pin:        false                      # Should this post be pinned?
toc:        true                       # Table of Contents?
math:       false                      # Does this post contain math?
# image:      /assets/img/...            # Header image path
---

# General Relativity (GR)
Nothing too exciting. Starting hard into curved spacetime.

# Dotfiles Presentation
On Wednesday I gave a presentation on how I organize dotfiles to the computational astrophysics seminar. It went well and now everybody has a scalable and portable way of organizing and moving their dotfiles from machine to machine. The skeleton of my dotfiles can be found here: [dotfiles repo](https://github.com/bcaddy/dotfiles-skeleton)

# HLLC Solver
I updated my HLLC solver to take a positional argument so that I can test the solver on it's own the same way I can with Toro's exact Riemann solver. As you can see in the below image it doesn't exactly reconstruct all the states on it's own, though it does work perfectly in an actual simulation. It does show that the estimate of the shock and contact wave speeds are a little low. This behavior seems to persist no matter what choice of wave speeds I use.

![exact vs HLLC](/assets/img/2020-post-assets/10-October/HLLC-standalone-test.png)
*Top: The output of the exact Riemann solver. Note the perfect reconstruction of the rarefaction fan and the position of the shock wave. Bottom: The output of the HLLC Riemann solver. Note how the fan is not resolved at all and the shock speed is a little underestimated*

# MHD Solver
I started implementing my MHD solver this week. So far I've just been working on setting the ground work for the HLLD solver and VL+CT integrator; there are lots of lots of small changes to make to the code to accommodate the additional complexities of magnetohydrodynamics and keeping the documentation updated requires care.  Progress is good though so I am hopeful.

## Useful links
Original HLLD paper: [Miyoshi & Kusano 2005](https://www.sciencedirect.com/science/article/pii/S0021999105001142?via%3Dihub)

Blog post on the HLLD Algorithm: [HLLD Algorithm]({% post_url 2020-10-23-HLLD-Algorithm%})

Original VL+CT paper: [Stone & Gardiner 2009](https://www.sciencedirect.com/science/article/abs/pii/S1384107608000754?via%3Dihub)