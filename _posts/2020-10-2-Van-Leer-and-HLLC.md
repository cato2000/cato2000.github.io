---
title:      Van Leer and HLLC      # Title
author:     Robert Caddy               # Author Name
date:       2020-10-02 16:00:00 -0400  # Date
categories: [Hydrodynamics, Course Work]     # Catagories, no more than 2
tags:       [Van Leer, CTU, General Relativity, Riemann Solver, MHD]                     # Tags, any number
pin:        false                      # Should this post be pinned?
toc:        true                       # Table of Contents?
math:       false                      # Does this post contain math?
# image:      /assets/img/...            # Header image path
---

# General Relativity (GR)
Still working on special relativity this week. Spent most of Monday and Tuesday
morning on homework. We did derive the relativistic rocket equation and that was
fun.

# HLL Family Riemann Solvers
I read the chapter of Toro on HLL family Riemann solvers since we're planning to implement a HLLD Riemann Solver for MHD. The solver is way simplier than Toro's exact solver (thankfully) and I think I'll implement it next week. The general algorithm for the HLLC Riemann Solver is:

1. Estimate the pressure in the Star region. A PVRS estimate is usually good enough
2. Estimate the wave speeds
3. Based on the wave speeds figure out which of 4 states we're in
4. Compute the HLLC flux (there are two variants, one that assures constant pressure accross the contact wave and one that doesn't)
5. Profit :)

# Van Leer Integration
I've finished converting my hydro code in
[hydro-sandbox](https://github.com/bcaddy/hydro-sandbox) to use a Van Leer
integrator instead of a CTU integrator so that I can use the VL+CT method for
MHD detailed in Stone & Gardiner 2009.

Currently it is running and giving broadly correct results but is way too diffusive and I'm not sure why. You can see in the first video how clear the shock is using the CTU algorithm. In the second video it's significantly more diffuse and I'm not sure why. Both are using piecewise linear methods to compute the interface states.

<video muted autoplay controls>
    <source type="video/mp4" src="/assets/img/2020-post-assets/08-August/Sod-PLM-MC.mp4">
</video>
*The Sod Shock Tube using a CTU algorithm and PLM reconstruction*

<video muted autoplay controls>
    <source type="video/mp4" src="/assets/img/2020-post-assets/10-October/Sod-VL-PLM.mp4">
</video>
*The Sod Shock Tube using a Van Leer algorithm and PLM reconstruction*