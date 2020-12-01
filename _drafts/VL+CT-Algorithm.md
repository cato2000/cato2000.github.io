---
title:      VL+CT Algorithm            # Title
author:     Robert Caddy               # Author Name
date:       2020-12-03 17:00:00 -0400  # Date
categories: [MHD, Recontruction]       # Catagories, no more than 2
tags:       [MHD, Hydro, Computational Methods, Numerical Methods, Riemann Solver, Van Leer, VL+CT]
pin:        false                      # Should this post be pinned?
toc:        true                       # Table of Contents?
math:       true                       # Does this post contain math?
# image:      /assets/img/...           # Header image path
---

# Overview

This is a step through of the VL+CT (Van Leer plus Constrained Transport)
integrator I'm going to add to my
[hydro-sandbox](https://github.com/bcaddy/hydro-sandbox) code. The specific
algorithm is from [Stone & Gardiner
2009](https://ui.adsabs.harvard.edu/abs/2009NewA...14..139S/abstract) which is
the original paper where the VL+CT integrator was introduced. This will serve as
practice and figuring out any kinks before I add the VL+CT integrator to
[Cholla](https://github.com/cholla-hydro/cholla).

Overall the algorithm is very similar to the Van Leer algorithm, though with
significant new additions for Constrained Transport(CT). CT treats the magnetic
field as surface, rather than volume, averaged quantities then reconstructs the
volume averaged values. This automatically fulfills the divergence free
condition for magnetic fields so no magnetic monopoles will appears

## Glossary of Symbols
- \\( \vec{U} \\), Vector of conserved variables
- \\( \vec{F} \\), The flux in the \\( x \\)-direction
- \\( \vec{G} \\), The flux in the \\( y \\)-direction
- \\( \vec{H} \\), The flux in the \\( z \\)-direction
<!-- TODO Start here -->

- \\(k \\), Subscript to indicate left or right. i.e. \\( k = L \ \text{or}\ R \\)
- \\(j \\), Subscript to indicate which dimension we're using. i.e. \\( i = x, y, \text{or}\; z \\)
- \\(*  \\), Superscript that indicates if the variable is the value within the star region, ie the region between the fast magnetosonic waves and the Alfvén waves.
- \\(**  \\), Superscript that indicates if the variable is the value within the star region, ie the region between the Alfvén waves and the contact discontinuity.
- \\\( \vec{F} \\),  Flux
- \\(\rho  \\), Density
- \\(p  \\), Pressure
- \\(E \\), Energy
- \\(v  \\), Velocity
- \\(B \\), Magnetic Field
- \\(p_T \\), Total pressure
- \\(S_L  \\), Approximation of the speed of the left moving magnetosonic wave
- \\(S_L^* \\), Approximation of the speed of the left moving Alfvên wave
- \\(S_M  \\), Approximation of the speed of the center (contact) wave speed
- \\(S_R  \\), Approximation of the speed of the right moving magnetosonic wave
- \\(S_R^* \\), Approximation of the speed of the right moving Alfvên wave
- \\(c \\), Sound speed


## Glossary of New Equations
MHD comes along with many modifications to the various basic equations that we're used to; new terms in the pressure and energy equations, new wave speeds, new eigenvalues etc. I summarize the ones I plan to use here.

### Conservative Variable Vector and Flux

$$
    \vec{U}_k = \begin{bmatrix}
            \rho_k \\
            \rho_k v_{x,k} \\
            \rho_k v_{y,k} \\
            \rho_k v_{z,k} \\
            B_x \\
            B_y \\
            B_z \\
            E
         \end{bmatrix}

    \text{,}\; \;

    \vec{F}_k = \begin{bmatrix}
            \rho_k v_{x,k} \\
            \rho_k v_{x,k}^2 + p_{T,k} - B_{x,k}^2 \\
            \rho v_{x,k} v_{y,k} - B_{x,k} B_{y,k} \\
            \rho v_{x,k} v_{z,k} - B_{x,k} B_{z,k} \\
            0 \\
            B_{y,k} v_{x,k} - B_{x,k} v_{y,k} \\
            B_{z,k} v_{x,k} - B_{x,k} v_{z,k} \\
            v_{x,k} \left( E_k + p_{T,k} \right) - B_{x,k} \left( \vec{v_k} \cdot \vec{B_k} \right)
         \end{bmatrix}
$$

### Eigenvalues:

$$
    \lambda_{2,6} = v_x \mp c_a, \;
    \lambda_{1,7} = v_x \mp c_f, \;
    \lambda_{3,5} = v_x \mp c_s, \;
    \lambda_{4} = v_x
$$

### Alfvên Wave Speed:

$$
    c_a = \frac{\mid B_x \mid}{\sqrt{\rho}}
$$

### Fast & Slow Magnetosonic Wavespeeds:

$$
    c_{f,s} = \sqrt{\frac
    {\gamma p + \mid \vec{B} \mid^2 \pm \sqrt{\left( \gamma p \;+ \mid \vec{B} \mid^2 \right)^2 - 4\gamma p B_x^2 } }
    {2\rho}}
$$

### Pressure:

$$
    p = \left( \gamma - 1 \right)
        \left( E - \frac{1}{2} \rho \mid \vec{v}\mid ^2 - \frac{1}{2} \mid \vec{B} \mid ^2 \right)
$$

$$
    p_T = p_{Total} = p + \frac{1}{2} \mid \vec{B} \mid ^2
$$

### Energy:

$$
    E = \frac{p}{\gamma - 1} + \frac{1}{2}\left( \rho \mid \vec{v} \mid ^2 + \mid \vec{B} \mid ^2\right)
      = \frac{p_T - \frac{1}{2}\mid \vec{B} \mid^2 }{\gamma - 1} + \frac{1}{2}\left( \rho \mid \vec{v} \mid ^2 + \mid \vec{B} \mid ^2\right)
$$

### Which Variables are the Same Between States:

$$
    S_M = v_{x,L}^* = v_{x,L}^{**} = v_{x,R}^* = v_{x,R}^{**}
$$

$$
    p_T^* = p_{T_L}^* = p_{T_L}^{**} = p_{T_R}^* = p_{T_R}^{**}
$$

$$
    \rho_k^* = \rho_k^{**}
$$

$$
    \vec{v}_R^{**} = \vec{v}_L^{**} = \vec{v}^{**} \text{if}\; B_x = 0
$$

$$
    \vec{B}_R^{**} = \vec{B}_L^{**} = \vec{B}^{**}\; \text{if}\; B_x = 0
$$


# Algorithm
Our goal is to choose the correct HLLD flux depending on the interface states.

## 1. Compute Acoustic & Contact Wave Speeds
First we need to compute \\\( S_L, S_L^\*, S_M, S_R^\*, \text{and} S_R \\) using the below
equations.

### Computing \\\( S_L \\) and \\( S_R \\)
We can use either of the below approximations for \\( S_L \text{and} S_R \\)
(there are other options as well, these were just the two given in [Miyoshi &
Kusano
2005](https://www.sciencedirect.com/science/article/pii/S0021999105001142?via%3Dihub))

$$
    S_L = \min(\lambda_{min}(\vec{U}_L), \lambda_{min}(\vec{U}_R))
$$

$$
    S_R = \max(\lambda_{max}(\vec{U}_L), \lambda_{max}(\vec{U}_R))
$$

Where \\( \lambda_{min} \\) is the smallest eigenvalue and \\( \lambda_{max} \\)
is the largest.

**OR**

$$
    S_L = \min(v_{x,L}, v_{x,R}) - \max(c_{f,L}, c_{f,R})
$$

$$
    S_R = \max(v_{x,L}, v_{x,R}) + \max(c_{f,L}, c_{f,R})
$$

### Computing \\\( S_L^\* \\) and \\( S_R^\* \\)

$$
    S_L^* = S_M - \frac{\mid B_x \mid}{\sqrt{\rho_L^*}}
$$

$$
    S_R^* = S_M + \frac{\mid B_x \mid}{\sqrt{\rho_R^*}}
$$

where

$$
    \rho_k^* = \rho_k \frac{S_k - v_{x,k}}{S_k - S_M}
$$

### Computing \\\( S_M \\)

$$
    S_M = \frac
    {\rho_R v_{x,R} \left( S_R - v_{x,R}\right) - \rho_L v_{x,L} \left( S_L - v_{x,L}\right) + p_{T_L} - p_{T_R}}
    {\rho_R \left( S_R - v_{x,R}\right) - \rho_L \left( S_L - v_{x,L}\right)}
$$


## 2. Determine Which State We're In
Use the equation below with the wave speeds to determine which state we're in.
If we're in a non-star state go to step 3a, for star states go to step 3b, and
for double star states go to step 3c.

$$

    \vec{F}_{HLLC} =
        \begin{cases}
            \vec{F}_L  & \text{if}\ 0 < S_L
            \\
            \\
            \vec{F}_L^*  & \text{if}\ S_L \leq 0 < S_L^*
            \\
            \\
            \vec{F}_L^{**}  & \text{if}\ S_L^* \leq 0 < S_M
            \\
            \\
            \vec{F}_R^{**}  & \text{if}\ S_M \leq 0 < S_R^*
            \\
            \\
            \vec{F}_R^*  & \text{if}\ S_R^* \leq 0 \leq S_R
            \\
            \\
            \vec{F}_R  & \text{if}\ S_R < 0
        \end{cases}

$$


## 3. Compute & Return the Fluxes

### 3a. \\( F_L \\) or \\( F_R \\) State
This is the region outside of either magnetosonic wave. The flux is easy, simply
compute fluxes with the below equation and return.

$$
    \vec{F}_k = \begin{bmatrix}
            \rho_k v_{x,k} \\
            \rho_k v_{x,k}^2 + p_{T,k} - B_{x,k}^2 \\
            \rho v_{x,k} v_{y,k} - B_{x,k} B_{y,k} \\
            \rho v_{x,k} v_{z,k} - B_{x,k} B_{z,k} \\
            0 \\
            B_{y,k} v_{x,k} - B_{x,k} v_{y,k} \\
            B_{z,k} v_{x,k} - B_{x,k} v_{z,k} \\
            v_{x,k} \left( E_k + p_{T,k} \right) - B_{x,k} \left( \vec{v_k} \cdot \vec{B_k} \right)
         \end{bmatrix}
$$

### 3b. \\( F_L^* \\) or \\( F_R^* \\) State
This is the region between the fast magnetosonic waves and the Alfvên waves.
These fluxes are more complicated and require the use of the fluxes from step 3a
as well. The algorithm is exactly the same for the left and right star states so
the subscript \\\( k \\) is used to indicate \\( R \\) or \\( L \\).

$$
    \vec{F}_k^* = \vec{F}_k + S_k \left( \vec{U}_k^* - \vec{U}_k \right)
$$

and we find the components of \\(\vec{U}\_k^\* \\) with the following equations.
\\( \rho^\*\_k \\) was already computed when finding \\( S\_k^\* \\) and \\(
v\_{x,k}^\* = S\_M \\)

$$
    p_T^* = \frac
    {
        \rho_R p_{T_L} \left( S_R - v_{x,R} \right)
      - \rho_L p_{T_R} \left( S_L - v_{x,L} \right)
      + \rho_L \rho_R
        \left( S_R - v_{x,R} \right)
        \left( S_L - v_{x,L} \right)
        \left( v_{x,R} - v_{x,L} \right)
    }
    {\rho_R \left( S_R - v_{x,R} \right) - \rho_L \left( S_L - v_{x,L} \right)}
$$

$$
    E_k^* = \frac
            {
                E_k \left( S_k - v_{x,k} \right)
              - p_{T,k} v_{x,k}
              + p_T^* S_M
              + B_x \left( \vec{v}_k \cdot \vec{B}_k - \vec{v}_k^* \cdot \vec{B}_k^* \right)
            }
            {S_k - S_M}
$$

We can find the \\( y \\) and \\( z \\) components of \\( \vec{v} \\) and
\\(\vec{B} \\) with the follwing equations. Note these equations can give a term
that is \\( \frac{0}{0} \\) if \\( S_M = v_{x,k}\\), \\(S_k = v_{x,k} \pm
c_{f,k}\\), \\(B_{y,k} = B_{z,k} = 0\\), and \\(B_x^2 \ge \gamma p_k \\). If
this is the case then there is no shock across \\\( S_k \\), so set \\(
\vec{v}\_k^* = \vec{v}\_k\\), \\(B\_{y,k} = B\_{z,k} = 0\\), \\(\rho\_k^\* =
\rho\_k\\), and \\( p\_{T,k}^\* = p\_{T,k} \\).

$$
    v_{j,k}^* = v_{j,k} - B_x B_{j,k}
                \frac
                {S_M - v_{x,k}}
                {\rho_k \left( S_k - v_{x,k} \right) \left( S_k - S_M \right) - B_x^2 }
$$

$$
    B_{j,k}^* = B_{j,k}
                \frac
                {\rho_k \left( S_k - v_{x,k} \right)^2 - B_x^2 }
                {\rho_k \left( S_k - v_{x,k} \right) \left( S_k - S_M \right) - B_x^2 }
$$

Note that the denominators are the same

### 3c. \\( F_L^{\*\*} \\) or \\( F_R^{\*\*} \\) State
This is the region between the Alfvên waves and the contact discontinuity
(entropy wave). These fluxes require the fluxes from step 3a and 3b. The
algorithm is exactly the same for the left and right star states so the
subscript \\\( k \\) is used to indicate \\( R \\) or \\( L \\).

$$
    \vec{F}_k^{**} = \vec{F}_k^* + S_k^{**} \left( \vec{U}_k^{**} - \vec{U}_k^* \right)
$$

We already know some of the state variables from previous computations

$$
    v_{x,k}^{**} = S_M
$$

$$
    p_T^{**} = p_T^{*}
$$

$$
    \rho_k^{**} = \rho_k^*
$$

So all we need to compute directly is
\\( \; v\_y^{\*\*} \\),
\\( \; v\_z^{\*\*} \\),
\\( \; B\_y^{\*\*} \\),
\\( \; B\_z^{\*\*} \\), and
\\( \; E_k^{\*\*} \\)

$$
    v_j^{**} = \frac
                {
                    v_L^* \sqrt{\rho_L^*}
                  + v_R^* \sqrt{\rho_R^*}
                  + \left( B_{j,R}^* - B_{j,L}^* \right) \text{sign}\left( B_x \right)
                }
                {\sqrt{\rho_L^*} + \sqrt{\rho_R^*}}
$$

$$
    B_j^{**} = \frac
                {
                    B_{j,R}^* \sqrt{\rho_L^*}
                  + B_{j,L}^* \sqrt{\rho_R^*}
                  + \left( v_{j,R}^* - v_{j,L}^* \right) \sqrt{\rho_L^* \rho_R^*} \text{sign}\left( B_x \right)
                }
                {\sqrt{\rho_L^*} + \sqrt{\rho_R^*}}
$$

Note that the denominators are the same as is one of the coefficients in each
term in the numerator.

Lastly we compute the energy (the minus and plus correspond to the L and R side respectively)

$$
    E_k^{**} = E_k^*
                \mp \sqrt{\rho_k^*}
                    \left(
                            \vec{v}_k^* \cdot \vec{B}_k^*
                          - \vec{v}_k^{**} \cdot \vec{B}_k^{**}
                    \right)
                    \text{sign}\left( B_x \right)
$$


# Conclusion
And that's it. We're done! As you can see the HLLD solver is significantly more
complex than the HLLC solver to account for the extra waves. Note that many of
the star state primitive variables are used in a bunch of different places so
assigning them to member variables is probably a good idea if you're
implementing this as a class.