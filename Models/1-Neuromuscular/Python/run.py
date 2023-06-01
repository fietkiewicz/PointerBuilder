'''
Documentation: https:github.com/fietkiewicz/PointerBuilder
 Description: Muscle with calcium dynamics and neural activation.
 Notes:
   The muscle model is adapted from the following paper:
   Kim H. Linking Motoneuron PIC Location to Motor Function in Closed-Loop Motor Unit System Including Afferent
   Feedback: A Computational Investigation. eNeuro. 2020 Apr 27;7(2)
   On ModelDB: https://modeldb.science/266732
'''

from neuron import h
from neuron.units import mV, ms, µM
import matplotlib.pyplot as plt

# Create neuron model
cell = h.Section(name = 'cell')
cell.insert(h.hh)

# Create stimulus for neuron
ns = h.NetStim()
ns.interval = 100 * ms
syn = h.ExpSyn(cell(0.5))
nc = h.NetCon(ns, syn)
nc.delay = 0 * ms
nc.weight[0] = 2

# Create muscle model
body = h.Section(name = 'body')
calciumObject = h.calcium(body(0.5))
forceObject = h.force(body(0.5))

# connect neuron to muscle
neuron_muscle_synapse = h.NetCon(cell(0.5)._ref_v, calciumObject, sec=cell)
neuron_muscle_synapse.threshold = -40 * mV
neuron_muscle_synapse.delay = 0 * ms

# Set Pointers
forceObject._ref_aPointer = calciumObject._ref_A
forceObject._ref_xmPointer = calciumObject._ref_xm

# Record data for plots
v = h.Vector().record(cell(0.5)._ref_v)
ca = h.Vector().record(calciumObject._ref_Ca)
f = h.Vector().record(forceObject._ref_F)
t = h.Vector().record(h._ref_t)

# Run simulation
tstop = 500 * ms
h.load_file('stdrun.hoc')
h.finitialize(-65 * mV)
h.continuerun(tstop)


# Plotting
plt.figure(figsize=(6, 6))
ax1 = plt.subplot(311)
ax1.plot(t, v, 'b-')
ax1.axis([0, tstop, -80, 40])
ax1.set_ylabel('Vm (mV)')

ax2 = plt.subplot(312)
ax2.plot(t, ca / µM, 'b-')
ax2.axis([0, tstop, 0, 0.03])
ax2.set_ylabel('Calcium (µM)')

ax3 = plt.subplot(313)
ax3.plot(t, f, 'b-')
ax3.axis([0, tstop, 0, 15])
ax3.set_ylabel('Force (N)')
ax3.set_xlabel('t (ms)')

plt.show()
