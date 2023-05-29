'''
Documentation: https://github.com/fietkiewicz/PointerBuilder
Description: Closed-loop model of neural control for respiration.
'''

from neuron import h
import matplotlib.pyplot as plt
from matplotlib.figure import Figure

# Set up transmembrane currents
neuron = h.Section(name = 'neuron')
neuron.insert('na')
neuron.insert('nap')
neuron.insert('k')
neuron.insert('leak')
neuron.insert('syn')

# Set up respiration components
body = h.Section(name = 'body')
body.insert('respiration')
neuron(0.5).cm = 22600 # Specific capacitance that approximates C = 21.

# Set pointers
body(0.5).respiration._ref_Vpointer = neuron(0.5)._ref_v
neuron(0.5).syn._ref_gtonicPointer = \
    body(0.5).respiration._ref_gtonic
neuron(0.5).na._ref_nPointer = neuron(0.5).k._ref_n

# Record data for plots
v = h.Vector().record(neuron(0.5)._ref_v)
vollung = h.Vector().record(body(0.5)._ref_vollung_respiration)
PO2blood = h.Vector().record(body(0.5)._ref_PO2blood_respiration)
t = h.Vector().record(h._ref_t)

# Run simulation
h.load_file('stdrun.hoc')
h.init()
h.tstop = 10000.0
h.run()

# Plotting
t = t / 1000 # Convert msec to sec
tStart = 1.2
plotLength = 9
tStop = tStart + plotLength
plt.figure(figsize=(6, 6))
ax1 = plt.subplot(311)
ax1.plot(t, v, 'k-', label = 'neuron(0.5).v', linewidth = 0.2)
ax1.axis([tStart, tStop, -80, 40])
ax1.set_ylabel('V (mV)')

ax2 = plt.subplot(312)
ax2.plot(t, vollung, 'k-', label = 'body.vollung_respiration(0.5)')
ax2.axis([tStart, tStop, 2, 3.2])
ax2.set_ylabel('Lung Volume (L)')

ax3 = plt.subplot(313)
ax3.plot(t, PO2blood, 'k-', label = 'body.PO2blood_respiration(0.5)')
ax3.axis([tStart, tStop, 92, 107])
ax3.set_xlabel('time (sec)')
ax3.set_ylabel('PaO2 (mm Hg)')

plt.show()
