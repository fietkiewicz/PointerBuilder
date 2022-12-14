'''
Documentation: https://github.com/fietkiewicz/PointerBuilder
Description: Pedagogical model of a nonsmooth brain/body system.
'''

from neuron import h
import matplotlib.pyplot as plt

model = h.Section(name = 'model')
model.insert('brain')
model.insert('body')

h.setpointer(model(0.5)._ref_b_body, 'bPointer', model(0.5).brain)

a = h.Vector().record(model(0.5)._ref_a_brain)
b = h.Vector().record(model(0.5)._ref_b_body)
t = h.Vector().record(h._ref_t)

h.load_file('stdrun.hoc')
h.init()
h.cvode.active(True)
h.cvode.atol(1e-4)
h.tstop = 50.0
h.run()

plt.figure(figsize=(6, 3.8))
ax1 = plt.subplot(211)
ax1.plot(t, a, 'b-')
##ax1.axis([0, h.tstop, -40, 60])
##ax1.set_xlabel('t (ms)')
ax1.set_ylabel('a')
##ax1.legend(loc = 'upper right', frameon = True)

ax2 = plt.subplot(212)
ax2.plot(t, b, 'b-')
##ax2.axis([0, h.tstop, -0.1, 1.6])
ax2.set_xlabel('t (ms)')
ax2.set_ylabel('b')
##ax2.legend(loc = 'upper right', frameon = True)
##plt.savefig('Lotka-Volterra-graph.png', dpi=300)
plt.show()
