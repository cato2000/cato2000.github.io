---
title:      Van Leer & HLLC Part 2   # Title
author:     Robert Caddy               # Author Name
date:       2020-10-09 15:00:00 -0400  # Date
categories: [Hydrodynamics, Course Work]     # Catagories, no more than 2
tags:       [Van Leer, CTU, General Relativity, Riemann Solver, MHD]  # Tags, any number
pin:        false                      # Should this post be pinned?
toc:        true                       # Table of Contents?
math:       false                      # Does this post contain math?
# image:      /assets/img/...            # Header image path
---

# General Relativity (GR)
Moving from special relativity to general relativity this week. The homework was
pretty long so I spent two days on that.

# HLLC Riemann Solvers
I'm about half done writing an HLLC Riemann solver, specifically the one from
[Batten et al. 1997](https://doi.org/10.1137/S1064827593260140). The details of
the solver can be found in my previous post [HLLC Algorithm]({{ site.baseurl}}{%
link _posts/2020-10-08-HLLC-Algorithm.md %}). I've had to make some tweaks to
the implementation of the exact Riemann solver, namely moving the position
argument to the end of the parameter list and making it optional. In numerical
simulations it's always zero and doesn't usually show up in approximate solvers
so now I can just neglet it when I don't need it.



# Van Leer Integration
With the help of my advisor I found the issues with my Van Leer integrator. There were two separate issues:

1. Since the Van Leer integrator requires a first order and then a second order
   reconstruction you need a third ghost cell. I was just updating the real part
   of the grid.
2. The first order reconstruction and Riemann solve serve the purpose of
   updating the grid half a time step and the plain second order reconstruction
   does the second half of the time step. Instead of using a plain second order
   reconstruction I was using the same reconstruction algorithm from my CTU
   integrator which contains characteristic tracing. That characteristic tracing
   is what does the half time step update in the CTU integrator. Since I was
   doing it after already doing a half time step update I was effectively
   updating past one time step which is bad.

Fixing these two issues and changing the resolution and CFL number to more
realistic values (1000 cells and 0.4) fixed all the issues I was having as you
can see in the plot below.

<video muted autoplay controls>
    <source type="video/mp4" src="/assets/img/2020-post-assets/10-October/Sod-VL-PLM-Corrected.mp4">
</video>
*The Sod Shock Tube using a Van Leer algorithm and PLM reconstruction*