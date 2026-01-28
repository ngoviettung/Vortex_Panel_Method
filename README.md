# Vortex Panel Method for Wing using NACA Profile

This repository implements the **Vortex Panel Method** in **MATLAB** for analyzing the potential flow around NACA airfoil profiles and computing aerodynamic quantities such as **pressure distribution**, **lift**, and **aerodynamic coefficients**.

The Vortex Panel Method is a numerical technique for solving 2D incompressible, irrotational flow around an airfoil by discretizing the surface into panels with vortex elements. It is widely used in aerodynamic education and early-stage design. :contentReference[oaicite:0]{index=0}

---

## 📁 Repository Structure

├── computeAerodynamicCoeffs.m # Calculate aerodynamic coefficients (e.g., Cl, Cp)
├── computeControlPoints.m # Compute panel control points
├── computeCp.m # Compute pressure coefficient distribution
├── createNACA4WingSTL.m # Generate STL geometry for a NACA 4-digit wing
├── generateVortexFromSTL_withAoA.m # Convert STL geometry to vortex panels
├── getMidspanCutProfile3D_2016b.m # Extract 2D profile from 3D STL
├── readSTL_ASCII.m # Read ASCII STL files
├── runNACA4Vortex.m # Main script to run vortex panel solver on a NACA profile
├── solveVortexPanel.m # Solver for panel vortex strengths
├── velocitySegment.m # Induced velocity from a vortex segment
├── velocityVortexRing.m # Induced velocity from a vortex ring
├── vortex_panel.m # Core method implementation
├── wing_2412.stl # Example STL for NACA2412 wing
├── writeSTL_ASCII.m # Write mesh to ASCII STL
└── README.md # (This file)

---

## 🚀 Quick Start

### 📥 Requirements

- MATLAB (any recent version, tested with R2016b+)
- Basic familiarity with running `.m` scripts

### 🧪 Run Example

1. **Open MATLAB**
2. Set the repository folder as the current working directory.
3. Run the main script to compute aerodynamic results. For example:
runNACA4Vortex
4. Results such as pressure coefficient (Cp) and lift coefficient (Cl) will be generated and plotted.

📌 What It Does

✔️ Loads airfoil or wing geometry (e.g., NACA series)
✔️ Discretizes the surface into panels
✔️ Solves the boundary integral equations using vortex panel theory
✔️ Computes velocity and pressure distributions
✔️ Outputs aerodynamic coefficients like Cp, Cl, and others

🧠 Algorithm Overview

The Vortex Panel Method works by discretizing a 2D body surface into straight panels with vortex elements. Boundary conditions enforce no-penetration, resulting in a linear system that solves for vortex strengths. From these, flow velocities and pressure coefficients are computed.

📊 Results

Typical outputs include:

Pressure coefficient distribution Cp(x)

Velocity field around airfoil

Lift (Cl) / Drag (Cd) estimates (if extended)

You can visualize Cp and velocity distribution using plots within MATLAB.

🧩 Contributing

Feel free to improve:

Support for more NACA profiles

Automated test cases

Export results (CSV / FIG)

GUI interface for interactive runs

📜 License

This project is open-source and free to use for academic and research purposes.

📚 References

Panel & Vortex Methods in Aerodynamics (MATLAB implementations found on File Exchange)
