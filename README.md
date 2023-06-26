# Introduction

This repository contains models and tools discussed in the following paper:

Fietkiewicz, C., Corrales Marco, D., Chiel, H. J. and Thomas, P. J. (accepted). Tutorial: Using NEURON for Neuromechanical Simulations. *Frontiers in Computational Neuroscience*.

All models require [NEURON](https::/neuron.yale.edu) to be installed, and Python versions require [Python](https::/python.org).

Address questions and comments to Dr. Chris Fietkiewicz (fietkiewicz@hws.edu). The following sections are available:

# Models

This collection of NEURON models demonstrates various concepts for neuromechanical simulations using pointers, as detailed in the paper above (Fietkiewicz et al.). The following models are available:

## 1-Neuromuscular

**Neuromuscular** is adapted from a neuromuscular model from Kim, Hojeong. "Muscle length-dependent contribution of motoneuron Cav1. 3 channels to force production in model slow motor unit." *Journal of Applied Physiology* 123.1 (2017): 88-105., Kim, Hojeong. "Linking motoneuron PIC location to motor function in closed-loop motor unit system including afferent feedback: a computational investigation." *Eneuro* 7.2 (2020)., and Kim, Hojeong, and Charles J. Heckman. "A dynamic calcium-force relationship model for sag behavior in fast skeletal muscle." *PLOS Computational Biology* 19.6 (2023): e1011178.

## 2-OscillatorLoop

**OscillatorLoop** is adapted from a closed-loop motor control model from Yu, Zhuojun, and Peter J. Thomas. "Dynamical consequences of sensory feedback in a half-center oscillator coupled to a simple motor system." *Biological Cbernetics* 115.2 (2021): 135-160.

## 3-RespirationLoop

**RespirationLoop** is adapted from a closed-loop respiratory model from Diekman, Casey O., Peter J. Thomas, and Christopher G. Wilson. "Eupnea, tachypnea, and autoresuscitation in a closed-loop respiratory control model." *Journal of Neurophysiology* 118.4 (2017): 2194-2215.

## 4-NonsmoothOscillator

**NonsmoothOscillator** is a simple (1D) non-smooth forced oscillator model.

## 5-AplysiaLoop

**AplysiaLoop** is adapted from a closed-loop model of the feeding motor system in Aplysia californica from Shaw, Kendrick M., David N. Lyttle, Jeffrey P. Gill, Miranda J. Cullins, Jeffrey M. McManus, Hui Lu, Peter J. Thomas, and Hillel J. Chiel. "The significance of dynamical architecture for adaptive responses to mechanical loads during rhythmic behavior." *Journal of Computational Neuroscience* 38 (2015): 25-51., Lyttle, David N., Jeffrey P. Gill, Kendrick M. Shaw, Peter J. Thomas, and Hillel J. Chiel. "Robustness, flexibility, and sensitivity in a multifunctional motor control model." *Biological Cybernetics* 111 (2017): 25-47., and Wang, Y., Gill, J. P., Chiel, H. J., & Thomas, P. J. (2022). Variational and phase response analysis for limit cycles with hard boundaries, with applications to neuromechanical control problems. *Biological Cybernetics*, 1-24.

## 6-LotkaVolterra

**LotkaVolterra** is based on the classic Lotka-Volterra two-population predator-prey model (https://en.wikipedia.org/wiki/Lotka%E2%80%93Volterra_equations).

# PointerBuilder apps

These applications are graphical interfaces for working with NEURON pointers. They can be used to learn and verify pointer syntax.

* **NEURON:** This graphical interface, written entirely in NEURON, creates pointer instructions in hoc syntax.

* **Python:** This graphical interface, written entirely in Python, creates pointer instructions in Python syntax. It requires the Tkinter package, which is common to most Python installations.
