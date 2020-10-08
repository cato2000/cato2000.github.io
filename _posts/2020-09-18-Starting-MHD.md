---
title:      Starting Magnetohydrodynamics (MHD)           # Title
author:     Robert Caddy                                  # Author Name
date:       2020-09-18 13:17:27 -0400                     # Date
categories: [MHD, Course Work]                            # Catagories, no more than 2
tags:       [MHD, Numerical Methods, General Relativity]  # Tags, any number
pin:        false                                         # Should this post be pinned?
toc:        true                                          # Table of Contents?
math:       true                                          # Does this post contain math?
# image:      /assets/img/...                               # Header image path
---

# General Relativity (GR)

We're a few weeks into GR now. Working on non-Euclidean geometry and starting
Special Relativity. I spent Monday, Tuesday, and Friday afternoon on homework
and reading for that.


# Magnetohydrodynamics (MHD)

I started on MHD this week by reading Teyssier 2015 and Stone & Gardiner 2009. Extending the Euler equations to include ideal MHD gives the following series of equations


$$ \frac{\partial \rho}{\partial t} + \nabla \cdot (\rho \vec{v}) = 0$$

$$ \frac{\partial \rho\vec{v}}{\partial t} + \nabla \cdot (\rho \vec{v}\vec{v} - \vec{B}\vec{B} + P^*) = 0$$

$$ \frac{\partial E}{\partial t} + \nabla \cdot ( (E + P^*) \vec{v} + \vec{B}(\vec{B}\cdot\vec{v}) ) = 0$$

$$ \frac{\partial \vec{B}}{\partial t} - \nabla \times (\vec{v} \times \vec{B}) = 0$$

Where \\( P^* = P + \frac{1}{2}(\vec{B} \cdot \vec{B}) \\), \\( E \\) is total energy density. Note that \\( \mu_0 = 1 \\) in our units. If we use a gamma law for the pressure then

$$ P = \epsilon(\gamma - 1) $$

and

$$ E \equiv \epsilon + \frac{1}{2}\rho(\vec{v}\cdot\vec{v}) + \frac{1}{2}(\vec{B}\cdot\vec{B}) $$.

These equations can be solved with entirely Godunov methods but treating the magnetic field as a cell centered average can lead to small instabilities that manifest as magnetic monopoles. This is very bad. There are some methods of dealing with this but they're computationally expensive and don't fix the underlying problem. Instead we should probably use 'Constrained Transport' where we treat the magnetic field as averaged over each face of each cell; for example \\( B_x^{i} \\) would be the average magnetic field at the \\(i-1/2 \\) face of the ith cell and since that face is in the y-z plane then the magnetic field stored is along the x-axis. Doing this simplifies the algorithm (since we don't have to keep checking for magnetic monopoles) and makes it more stable. Pairing this with CTU or Van Leer integrators and a MHD Riemann Solver (like the HLLD solver in (Miyoshi & Kusano 2005) gives the CTU+CT or VL+CT methods of Stone & Gardiner 2005, 2008, and 2009.

## Future Plans
I'm presenting an overview of this next week during the computational astrophysics seminar. Then I need to implement the VL+CT (or maybe CTU+CT, possibly both) into my own hydro code before adding it to Cholla. That will likely take most of the semester.


## Questions:
- Since magnetic fields are inherently 3D does it make sense to model them in
  1D? Should I write a simple 3D hydro code and skip over my planned 1D MHD
  code?

### Sources:
- Teyssier 2015
- Stone & Gardiner 2005, 2008, 2009
- Miyoshi & Kusano 2005

# Miscellaneous Things
- Confirmed all dissertation committee members and submitted paperwork
