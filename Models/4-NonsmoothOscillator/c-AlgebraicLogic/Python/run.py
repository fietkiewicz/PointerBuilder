'''
Documentation: https://github.com/fietkiewicz/PointerBuilder
Description: Pedagogical model of a nonsmooth brain/body system.
'''

from neuron import h
import matplotlib.pyplot as plt

# Create section and insert mechanisms
model = h.Section(name = 'model')
model.insert('brain')
model.insert('body')

# Set pointer
model(0.5).brain._ref_bPointer = model(0.5).body._ref_b

# Record data for plots
a = h.Vector().record(model(0.5)._ref_a_brain)
b = h.Vector().record(model(0.5)._ref_b_body)
t = h.Vector().record(h._ref_t)

# Run simulation
h.load_file('stdrun.hoc')
h.init()
h.cvode.active(True)
h.cvode.atol(1e-4)
h.tstop = 50.0
h.run()

# Plotting
plt.figure(figsize=(6, 3.8))
ax1 = plt.subplot(211)
ax1.plot(t, a, 'b-')
ax1.set_ylabel('a')

ax2 = plt.subplot(212)
ax2.plot(t, b, 'b-')
ax2.set_xlabel('t (ms)')
ax2.set_ylabel('b')
plt.show()
