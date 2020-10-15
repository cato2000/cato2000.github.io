---
title:      HLLC Implementation        # Title
author:     Robert Caddy               # Author Name
date:       2020-10-15 17:02:56 -0400  # Date
categories: [Hydrodynamics, Course Work]     # Catagories, no more than 2
tags:       [General Relativity, Riemann Solver]  # Tags, any number
pin:        false                      # Should this post be pinned?
toc:        true                       # Table of Contents?
math:       false                      # Does this post contain math?
# image:      /assets/img/...            # Header image path
---

# General Relativity (GR)
In class we're covering Newtonian curved spacetime. I spent Monday on the
homework and we have an exam next Monday so that's what I will be studying for
the rest of the week

# HLLC Riemann Solvers
I finished writing my HLLC Riemann solver! The details of
the solver can be found in my previous post [HLLC Algorithm]({{ site.baseurl}}{%
link _posts/2020-10-08-HLLC-Algorithm.md %}).

Debugging took some time this week. A few +/- or </> signs got swapped along
with me misunderstanding part of the algorithm (specifically how to compute the
momentum in the star state) but that's all fixed now and it looks great! The big
challenge was figuring out how to let the program choose between using the exact
or HLLC riemann solver. With some guidance I chose the [Strategy design
pattern](https://sourcemaking.com/design_patterns/strategy) where you create a
virtual base class and derive each Riemann solver class from that. Then in the
main program you make a pointer to point at the base class type and during
setup/construction you allocate that pointer to point at the specific
class/solver you want to use. It's surprisingly elegant and easily scalable.

<video muted autoplay controls>
    <source type="video/mp4" src="/assets/img/2020-post-assets/10-October/Sod-HLLC.mp4">
</video>
*A Sod shock tube problem solved using the new HLLC solver along with a second order Van Leer integrator*