'''
Documentation: https://github.com/fietkiewicz/PointerBuilder
Description: Neuromechanical, closed-loop model of a half-center oscillator coupled to a rudimentary motor system.
'''

from neuron import h
import matplotlib.pyplot as plt
from matplotlib.figure import Figure

# Create section and insert mechanisms
model = h.Section(name = 'model')
model.insert('brain')
model.insert('body')

# Set Pointers
model(0.5).brain._ref_L1Pointer = h._ref_L1_body
model(0.5).brain._ref_L2Pointer = h._ref_L2_body
model(0.5).body._ref_V1Pointer = model(0.5).brain._ref_V1
model(0.5).body._ref_V2Pointer = model(0.5).brain._ref_V2

# Record data for plots
V1 = h.Vector().record(model(0.5)._ref_V1_brain)
V2 = h.Vector().record(model(0.5)._ref_V2_brain)
A1 = h.Vector().record(model(0.5)._ref_A1_body)
A2 = h.Vector().record(model(0.5)._ref_A2_body)
x = h.Vector().record(model(0.5)._ref_x_body)
t = h.Vector().record(h._ref_t)

# Run simulation
h.load_file('stdrun.hoc')
h.init()
h.cvode.active(True)
h.cvode.atol(1e-4)
h.tstop = 4500.0
h.run()

# Plotting
plt.figure(figsize=(6, 6))
ax1 = plt.subplot(311)
ax1.plot(t, V1, 'b-', label = 'model.V1_brain(0.5)')
ax1.plot(t, V2, 'r--', label = 'model.V2_brain(0.5)')
ax1.axis([0, h.tstop, -40, 60])
ax1.set_xlabel('t (ms)')
ax1.set_ylabel('V')
ax1.legend(loc = 'upper right', frameon = True)

ax2 = plt.subplot(312)
ax2.plot(t, A1, 'b-', label = 'model.A1_body(0.5)')
ax2.plot(t, A2, 'r--', label = 'model.A2_body(0.5)')
ax2.axis([0, h.tstop, -0.1, 1.6])
ax2.set_xlabel('t (ms)')
ax2.set_ylabel('A')
ax2.legend(loc = 'upper right', frameon = True)

ax3 = plt.subplot(313)
ax3.plot(t, x, 'k-', label = 'model.x_body(0.5)')
ax3.axis([0, h.tstop, -4, 4])
ax3.set_xlabel('t (ms)')
ax3.set_ylabel('x')
ax3.legend(loc = 'upper right', frameon = True)

plt.show()
##plt.savefig('CPG-graph.png', dpi=300)
