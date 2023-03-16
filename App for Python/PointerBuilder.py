'''
Source: https://github.com/fietkiewicz/PointerBuilder
Description: Utility for pointers for NEURON simulations. See README.md for more details.
'''

import os
import csv
import tkinter as tk
from tkinter.filedialog import askopenfilename, asksaveasfilename
from functools import partial
from tkinter.ttk import Label, Style

column = 0 # Column index

def read_pointer_mod():
    filepath = askopenfilename(
        filetypes = [("Mod Files", "*.mod"), ("All files", "*.*")]
    )
    if not filepath:
        return
    with open(filepath, mode = "r", encoding = "utf-8") as mod_file:
        global window
        frame = tk.Toplevel(window)
        frame.title("Pointer Variables")
        for line in mod_file.readlines():
            if ("POINTER" in line):
                new_line = remove_spaces(line).strip()
                variables = new_line[7:].split(",")
                for i in range(len(variables)):
                    make_widget(frame, "button", i, 0, variables[i], setSticky = 'we', setCommand = partial(set_pointer_mod, filepath, variables[i]), setWidth = 20)
                break
        else:
            error_message = make_widget(frame, "label", 0, 0, "Error: No POINTER statement found.", setSticky = 'we', setWidth = 1000)
            error_message.configure(pady = 20, fg = "red")
            make_widget(frame, "button", 1, 0, "Try again", setSticky = 'we', setCommand = lambda: close_read_pointer_mod(frame), setWidth = 20)
            make_widget(frame, "button", 2, 0, "Close", setSticky = 'we', setCommand = lambda: frame.destroy(), setWidth = 20)

def set_pointer_mod(filepath, variable):
    global ent_pointer, ent_pointer_mod
    ent_pointer_mod.delete(0, 'end') # Clear text
    file_name = os.path.basename(filepath)
    ent_pointer_mod.insert(0, os.path.splitext(file_name)[0])
    ent_pointer.delete(0, 'end') # Clear text
    ent_pointer.insert(0, variable)

def close_read_pointer_mod(frame):
    frame.destroy()
    read_pointer_mod()

def read_source_mod():
    filepath = askopenfilename(
        filetypes = [("Mod Files", "*.mod"), ("All files", "*.*")]
    )
    if not filepath:
        return
    with open(filepath, mode = "r", encoding = "utf-8") as mod_file:
        global ent_source_mod
        ent_source_mod.delete(0, 'end') # Clear text
        file_name = os.path.basename(filepath)
        ent_source_mod.insert(0, os.path.splitext(file_name)[0])

def make_py():
    filepath = asksaveasfilename(
        defaultextension=".py",
        filetypes=[("Python Script", "*.py"), ("All Files", "*.*")],
    )
    if not filepath:
        return
    if (typeSelect.get() == 0): # State variable
        commandText = ent_pointer_cell.get() + "(0.5)." + \
                      ent_pointer_mod.get() + "." + \
                      "_ref_" + ent_pointer.get() + " = " + \
                      ent_source_cell.get() + "(0.5)." + \
                      ent_source_mod.get() + "." + \
                      "_ref_" + ent_source.get()
    else: # Parameter
        commandText = ent_pointer_cell.get() + "(0.5)." + \
                      ent_pointer_mod.get() + "." + \
                      "_ref_" + ent_pointer.get() + " = " + \
                      "h._ref_" + ent_source.get() + "_" + \
                      ent_source_mod.get()
    with open(filepath, mode="w", encoding="utf-8") as py_file:
        py_file.write(commandText)

def view_command():
    '''
    Format: section(position).mechanism._ref_variable
    Examples:
    model(0.5).body._ref_V1pointer = model(0.5).brain._ref_V1
    model(0.5).brain._ref_L1pointer = h._ref_L1_body
    '''
    global window
    foundPointer = False # Remember whether a POINTER statement was found
    frame = tk.Toplevel(window)
    frame.title("Python pointer command")
    if (typeSelect.get() == 0): # State variable
        commandText = ent_pointer_cell.get() + "(0.5)." + \
                      ent_pointer_mod.get() + "." + \
                      "_ref_" + ent_pointer.get() + " = " + \
                      ent_source_cell.get() + "(0.5)." + \
                      ent_source_mod.get() + "." + \
                      "_ref_" + ent_source.get()
    else: # Parameter
        commandText = ent_pointer_cell.get() + "(0.5)." + \
                      ent_pointer_mod.get() + "." + \
                      "_ref_" + ent_pointer.get() + " = " + \
                      "h._ref_" + ent_source.get() + "_" + \
                      ent_source_mod.get()
    make_widget(frame, "label", 0, 0, "Copy the following pointer command:", setWidth = 70)
    make_widget(frame, "entry", 1, 0, commandText, setWidth = 70)

def save_settings():
    global ent_pointer_mod, ent_pointer, ent_pointer_cell, ent_source_mod, ent_source, ent_source_cell, typeSelect
    filepath = asksaveasfilename(
        defaultextension=".py",
        filetypes=[("CSV Files", "*.csv"), ("All Files", "*.*")],
    )
    if not filepath:
        return
    with open(filepath, "w", encoding = "utf-8") as settings_file:
        writer = csv.writer(settings_file)
        data = []
        data.append(ent_pointer_mod.get())
        data.append(ent_pointer.get())
        data.append(ent_pointer_cell.get())
        data.append(ent_source_mod.get())
        data.append(ent_source.get())
        data.append(ent_source_cell.get())
        data.append(str(typeSelect.get()))
        writer.writerow(data)

def load_settings():
    global ent_pointer_mod, ent_pointer, ent_pointer_cell, ent_source_mod, ent_source, ent_source_cell, typeSelect
    filepath = askopenfilename(
        filetypes = [("CSV Files", "*.csv"), ("All files", "*.*")]
    )
    if not filepath:
        return
    # Clear entry boxes
    ent_pointer_mod.delete(0, 'end')
    ent_pointer.delete(0, 'end')
    ent_pointer_cell.delete(0, 'end')
    ent_source_mod.delete(0, 'end')
    ent_source.delete(0, 'end')
    ent_source_cell.delete(0, 'end')
    with open(filepath, mode = "r", encoding = "utf-8") as settings_file:
        lines = settings_file.readlines()
        entries = lines[0].split(",")
        ent_pointer_mod.insert(0, entries[0])
        ent_pointer.insert(0, entries[1])
        ent_pointer_cell.insert(0, entries[2])
        ent_source_mod.insert(0, entries[3])
        ent_source.insert(0, entries[4])
        ent_source_cell.insert(0, entries[5])
        typeSelect.set(entries[6][0:1])

def remove_spaces(string):
    return string.replace(" ", "")

def do_nothing():
    # Do nothing. This is used as a default argument for make_widget.
    pass

def help_screen():
    global window
    new = tk.Toplevel(window)
    new.title("Pointer Builder Help")
    text = tk.Text(new, wrap = tk.WORD)
    text.pack()
    text.insert(tk.INSERT, "PointerBuilder.py is a tool that assists the user in using pointers for NEURON simulations. It creates a pointer assignment statement with the correct syntax. Additional support is available at this site: \n\nhttps://github.com/fietkiewicz/PointerBuilder")
    text.configure(state = tk.DISABLED)

def make_widget(frame, widgetType, setRow, setColumn, setText, setSticky = 'w', setCommand = do_nothing, setRadio = 0, setWidth = 18):
    fontSize = 20
    fontName = 'Arial'

    global typeSelect # Value of raidobutton for selecting variabel type (state or parameter)

    if (widgetType == "label"):
        obj = tk.Label(master = frame, text = setText, font = (fontName, fontSize))

    elif (widgetType == "entry"):
        obj = tk.Entry(master = frame, width = setWidth, font = (fontName, fontSize))
        obj.insert(0, setText)

    elif (widgetType == "button"):
        obj = tk.Button(frame, text = setText, command = setCommand, width = setWidth, font = (fontName, fontSize))

    elif (widgetType == "radio"):
        obj = tk.Radiobutton(frame, text = setText, variable = typeSelect, value = setRadio, font = (fontName, fontSize))

    # Grid settings for all widgets
    obj.grid(row = setRow, column = setColumn, pady = pad, sticky = setSticky)
    return obj


# GUI stuff
pad = 0 # Padding for grid
window = tk.Tk()
window.title("Pointer Builder")
window.columnconfigure(0, weight = 1)
window.rowconfigure(1, weight = 1)
window.rowconfigure(2, weight = 1)

framePad = 10
fontSize = 20
fontName = 'Arial'
frm_pointer = tk.LabelFrame(window, padx = framePad, pady = framePad, text = "Pointer Settings", font = (fontName, fontSize))
frm_pointer.grid(row = 0, column = 0, sticky = "nsew", padx = framePad)
frm_source = tk.LabelFrame(window, padx = framePad, pady = framePad, text = "State/Parameter Settings", font = (fontName, fontSize))
frm_source.grid(row = 1, column = 0, sticky = "nsew", padx = framePad)
frm_buttons = tk.LabelFrame(window, padx = framePad, text = "Actions", font = (fontName, fontSize))
frm_buttons.grid(row = 2, column = 0, sticky = "nsew", padx = framePad)

# Pointer panel
make_widget(frm_pointer, "label", 1, 0, "NMODL file:")
ent_pointer_mod = make_widget(frm_pointer, "entry", 2, 0, "NOT ENTERED", setSticky = 'we')
make_widget(frm_pointer, "button", 3, 0, "Read .mod file", setSticky = 'we', setCommand = read_pointer_mod, setWidth = 1) # Note: setWidth is set to 1 because the actual width somehow ends up being wider than entry box for same width (can't figure out why!).
make_widget(frm_pointer, "label", 1, 1, "Name of pointer:")
ent_pointer = make_widget(frm_pointer, "entry", 2, 1, "NOT ENTERED")
make_widget(frm_pointer, "label", 1, 2, "Section name:")
ent_pointer_cell = make_widget(frm_pointer, "entry", 2, 2, "NOT ENTERED")

# State/parameter panel
make_widget(frm_source, "label", 1, 0, "NMODL file:")
ent_source_mod = make_widget(frm_source, "entry", 2, 0, "NOT ENTERED", setSticky = 'we')
make_widget(frm_source, "button", 3, 0, "Read .mod file", setSticky = 'we', setCommand = read_source_mod, setWidth = 1) # Note: setWidth is set to 1 because the actual width somehow ends up being wider than entry box for same width (can't figure out why!).
make_widget(frm_source, "label", 1, 1, "Name of state/parameter:")
ent_source = make_widget(frm_source, "entry", 2, 1, "NOT ENTERED")
make_widget(frm_source, "label", 1, 2, "Section name:")
ent_source_cell = make_widget(frm_source, "entry", 2, 2, "NOT ENTERED")
typeSelect = tk.IntVar() # Value of raidobutton for selecting variabel type (state or parameter)
make_widget(frm_source, "label", 1, 3, "Type:")
make_widget(frm_source, "radio", 2, 3, "State variable", setRadio = 0)
make_widget(frm_source, "radio", 3, 3, "Parameter", setRadio = 1)

# Button panel
buttonWidth = 12
make_widget(frm_buttons, "button", 1, 0, "Python command", setSticky = 'we', setCommand = view_command, setWidth = buttonWidth)
make_widget(frm_buttons, "button", 1, 1, "Make .py file", setSticky = 'we', setCommand = make_py, setWidth = buttonWidth)
make_widget(frm_buttons, "button", 1, 2, "Save settings", setSticky = 'we', setCommand = save_settings, setWidth = buttonWidth)
make_widget(frm_buttons, "button", 1, 3, "Load settings", setSticky = 'we', setCommand = load_settings, setWidth = buttonWidth)
make_widget(frm_buttons, "button", 1, 4, "Help", setSticky = 'we', setCommand = help_screen, setWidth = buttonWidth)

window.mainloop()
