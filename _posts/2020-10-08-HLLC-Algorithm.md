---
title:      HLLC Algorithm             # Title
author:     Robert Caddy               # Author Name
date:       2020-10-08 17:00:00 -0400  # Date
categories: [Hydrodynamics, Riemann Solvers]     # Catagories, no more than 2
tags:       [HLLC, Hydro, Computational Methods, Numerical Methods, Riemann Solver]  # Tags, any number
pin:        false                      # Should this post be pinned?
toc:        true                       # Table of Contents?
math:       true                      # Does this post contain math?
# image:      /assets/img/...            # Header image path
---

# Overview

This is a step through of the particular HLLC Riemann solver I'm going to add to
my [hydro-sandbox](https://github.com/bcaddy/hydro-sandbox) code. It will serve as a
base and teaching tool for my future implementation of an HLLD MHD Riemann
solver. The algorithm is from [Batten et al.
1997](https://doi.org/10.1137/S1064827593260140) though my basic understanding
of HLL family solvers is from Toro.

## Glossary of Symbols
- \\(k \\), Subscript to indicate left or right. i.e. \\( k = L \ \text{or}\ R \\)
- \\(*  \\), Superscript that indicates if the variable is the value within the star region, ie the region between the two acoustic waves
- \\\( \vec{F} \\),  Flux
- \\(\rho  \\), Density
- \\(p  \\), Pressure
- \\(E \\), Energy
- \\(v  \\), Velocity
- \\(S_L  \\), Approximation for left moving wave speed
- \\(S_M  \\), Approximation for center (contact) wave speed
- \\(S_R  \\), Approximation for right moving wave speed
- \\(c \\), Sound speed
- \\(\vec{U}  \\), Vector of conserved variables


# Algorithm
Our goal is to choose the correct HLLC flux depending on the interface states.

## 1. Compute Acoustic & Contact Wave Speeds
First we need to compute \\\( S_L, S_M, \text{and}, S_R \\) using the below
equations.

$$
    S_L = \min( v_L - c_L , \widetilde{v} - \widetilde{c} )
$$

$$
    S_R = \max( v_R + c_R , \widetilde{v} + \widetilde{c} )
$$

$$
    S_M = \frac
    {\rho_R v_R \left( S_R - v_R\right) - \rho_L v_L \left( S_L - v_L\right) + p_L - p_R}
    {\rho_R \left( S_R - v_R\right) - \rho_L \left( S_L - v_L\right)}
$$

Where

$$
    \widetilde{v} = \frac
    {v_L + v_R R_\rho}
    {1 + R_\rho}
$$

$$
    \widetilde{c} = \sqrt{
        (\gamma - 1) \left[ \widetilde{H} - \frac{1}{2}\widetilde{v}^2 \right]
    }
$$

$$
    \widetilde{H} = \frac{H_L + H_R R_\rho}{1 + R_\rho}
$$

$$
    R_\rho = \sqrt{\frac{\rho_R}{\rho_L}}
$$

$$
    H_K = \frac{E_k + p_k}{\rho_k} \ \text{(enthalpy)}
$$

## 2. Determine Which State We're In
Use the equation below with the wave speeds to determine which state we're in.
If we're in the first or fourth state go to step 3a, otherwise go to 3b.

$$

    \vec{F}_{HLLC} =
        \begin{cases}
            \vec{F}_L  & \text{if}\ 0 < S_L
            \\
            \\
            \vec{F}_L^*  & \text{if}\ S_L \leq 0 < S_M
            \\
            \\
            \vec{F}_R^*  & \text{if}\ S_M \leq 0 \leq S_R
            \\
            \\
            \vec{F}_R  & \text{if}\ S_R < 0
        \end{cases}

$$


## 3. Compute & Return the Fluxes

### 3a. \\( F_L \\) or \\( F_R \\) State
This is easy, simply compute fluxes with the below equation and return.

$$
    \vec{F}_k = \begin{bmatrix}
            \rho_k v_k \\
            \rho_k v_k^2 + p_k \\
            v_k \left( E_k + p_k \right)
         \end{bmatrix}
$$

### 3b. \\( F_L^* \\) or \\( F_R^* \\) State
These fluxes are more complicated and require the use of the fluxes from step 3a as well. The algorithm is exactly the same for the left and right star states so the subscript \\\( k \\) is used to indicate \\( R \\) or \\( L \\).

$$
    \vec{F}_k^* = \vec{F}_k + S_k \left( \vec{U}_k^* - \vec{U}_k \right)
$$

Where

$$
    \vec{U}_k^* = \begin{bmatrix}
            \rho_k^* \\
            \left( \rho_k v_k \right) ^*\\
            E_k^*
         \end{bmatrix},
    \; \; \; \text{and} \; \;
    \vec{U}_k = \begin{bmatrix}
            \rho_k \\
            \rho_k S_k \\
            E_k
         \end{bmatrix}
$$

and

$$
    \rho_k^* = \rho_k \frac
    {S_k - v_k}
    {S_k - S_M}
$$

$$
    p^* = p_L + \rho_L \left( v_L - S_L \right) \left( v_L - S_M \right)
$$

$$
    \left( \rho_k v_k \right) ^* = \frac{\rho_k v_k \left(S_k - v_k\right) + p^* - p_k}
                                        {S_k - S_M}
$$

$$
    E_k^* = \frac
    {E_k \left( S_k - v_K \right) - p_k v_k + p^* S_M}
    {S_k - S_M}
$$

Note that since \\( p_L^* = p_R^* \\) we can just compute the pressure in the star region using one of the interface states. The dependence on the other interface state comes from the \\( S_L \\) and \\( S_M \\) terms. Now you've computed the fluxes just return them and you're done!