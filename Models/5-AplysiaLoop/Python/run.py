'''
Documentation: https://github.com/fietkiewicz/PointerBuilder
Description: Closed-loop model of feeding behavior in the sea hare Aplysia californica that incorporates biologically-motivated nonsmooth dynamics.
'''

import tkinter as tk
from neuron import h, gui
from matplotlib.figure import Figure
from matplotlib.backends.backend_tkagg import (FigureCanvasTkAgg)

global a0, a1, a2, u0, u1, sw, t

def init_and_run():
    model = h.Section(name = 'model')
    model = h.Section(name = 'model')

    model.insert('brain')
    model.insert('body')

    h.setpointer(model(0.5)._ref_a0_brain, 'a0Pointer', model(0.5).body)
    h.setpointer(model(0.5)._ref_a1_brain, 'a1Pointer', model(0.5).body)
    h.setpointer(model(0.5)._ref_a2_brain, 'a2Pointer', model(0.5).body)
    h.setpointer(model(0.5)._ref_xr_body, 'xrPointer', model(0.5).brain)

    a0 = h.Vector().record(model(0.5)._ref_a0_brain)
    a1 = h.Vector().record(model(0.5)._ref_a1_brain)
    a2 = h.Vector().record(model(0.5)._ref_a2_brain)
    u0 = h.Vector().record(model(0.5)._ref_u0_body)
    u1 = h.Vector().record(model(0.5)._ref_u1_body)
    sw = h.Vector().record(model(0.5)._ref_sw_body)
    t = h.Vector().record(h._ref_t)

    h.load_file('stdrun.hoc')
    h.init()
    if len(ent_time.get())!=0:
        h.tstop = float(ent_time.get())
    if len(ent_mu.get())!=0:
        h.mu_brain = float(ent_mu.get())
    h.cvode.active(True)
    h.cvode.atol(1e-9)
    h.run()

##    fig = Figure(figsize = (20, 10), dpi = 75)
    fig = Figure(figsize = (6, 5), dpi = 100)
    plt = fig.add_subplot(311)
    plt.plot(t, a0, "k-", label = "a0")
    plt.plot(t, a1, "b-", label = "a1")
    plt.plot(t, a2, "r-", label = "a2")
    plt.set_ylabel('Neural\nActivation')
##    plt.set_title('"brain" state variables')
    plt.legend(loc = 'upper right', frameon = True)
    plt.axis([0, h.tstop, 0, 1.2])

    plt = fig.add_subplot(312)
    plt.plot(t, u0, "b-", label = "u0")
    plt.plot(t, u1, "r-", label = "u1")
    plt.set_xlabel('time')
    plt.set_ylabel('Muscle\nActivation')
##    plt.set_title('"body" state variable')
    plt.legend(loc = 'upper right', frameon = True)
    plt.axis([0, h.tstop, 0.1, 1])

    plt = fig.add_subplot(313)
    plt.plot(t, sw, "k-", label = "sw")
    plt.set_xlabel('time (sec)')
    plt.set_ylabel('Seaweed\nPosition')
    plt.axis([0, h.tstop, -0.5, 3.8])
##    plt.set_title('"body" state variable')
##    plt.legend(loc = 'upper right', frameon = True)

    canvas = FigureCanvasTkAgg(fig, master = window)
    canvas.draw()
    canvas.get_tk_widget().grid(row = 1, column = 0, sticky = "ns", padx = 5, pady = 5)

def update_time():
    time = ent_time.get()
    h.tstop = float(time)

def update_mu():
    new_mu = ent_mu.get()
    h.mu_brain = float(new_mu)

#GUI stuff
window = tk.Tk()
window.title("Aplysia Model GUI")

window.columnconfigure(0, weight = 1)
window.rowconfigure(1, weight = 1)

frm_graphs = tk.Frame(window, relief = tk.RAISED, bd = 2)
frm_buttons = tk.Frame(window, relief = tk.RAISED, bd = 2)

btn_run = tk.Button(frm_buttons, text = "Initiate & Run", command = init_and_run)
lbl_tstop = tk.Label(frm_buttons, text = "Duration:")
ent_time = tk.Entry(frm_buttons, width = 7)
ent_time.insert(0, "30")
lbl_mu = tk.Label(frm_buttons, text = "\u03BC:")
ent_mu = tk.Entry(frm_buttons, width = 7)
ent_mu.insert(0, "0.00001")

btn_run.grid(row = 0, column = 0, sticky = "ew", padx = 5)
lbl_tstop.grid(row = 0, column = 1, sticky = "e", padx = 5)
ent_time.grid(row = 0, column = 2, sticky = "ew", padx = 5)
lbl_mu.grid(row = 0, column = 3, sticky = "ew", padx = 5)
ent_mu.grid(row = 0, column = 4, sticky = "ew", padx = 5)

frm_buttons.grid(sticky = "ns")
frm_graphs.grid(sticky = "nsew")

window.mainloop()
