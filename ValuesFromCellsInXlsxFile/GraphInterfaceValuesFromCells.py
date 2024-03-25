import tkinter as tk
from TkinterDnD2 import DND_FILES
from TkinterDnD2 import TkinterDnD
from tkinter import *
from tkinter import ttk
from TryExcel import *
import tkinter.messagebox as messagebox

root = TkinterDnD.Tk()
root.geometry('450x800')
root.title('Restituzione elementi in celle contigue')

ListaDelleMail = []

var = tk.Variable(value=ListaDelleMail)

def convert_uppercase(*args):
    ColumnLetter.set(ColumnLetter.get().upper())
    if len(ColumnLetter.get()) > 0:
        if not ColumnLetter.get()[ len(ColumnLetter.get()) - 1].isupper() :
            ColumnLetter.set(ColumnLetter.get()[:-1])
    if len(ColumnLetter.get()) > 4:
        ColumnLetter.set( ColumnLetter.get()[:-1] )


def IsANumber(*args):
    if len(RowNumber.get()) > 0:
        if not(RowNumber.get()[-1].isdigit()):
            RowNumber.set(RowNumber.get()[:-1])
    if len(RowNumber.get()) > 4:
        RowNumber.set(RowNumber.get()[:-1])





def TakeData():

    if VariableRadioButton.get() == "Righe":
        Listaa=GetMailList(EntryExcelFilePath.get(),ColumnLetter.get(),RowNumber.get(),True)
    elif VariableRadioButton.get() == "Colonne":
        Listaa=GetMailList(EntryExcelFilePath.get(),ColumnLetter.get(),RowNumber.get(),False)
    else:
        messagebox.showerror("Attenzione", "Selezionare se si desidera scorrere lungo righe o colonne")
        return
    if Listaa == -1:
        messagebox.showwarning("Attenzione", "Il file sembra essere corretto, ma in base alle istruzioni non è stato trovato nessun indirizzo mail ")
        return
    if Listaa == -2:
        messagebox.showerror("Errore", "Il percorso del file sembra scorretto, reinseriscilo")
        return
    else:
        var.set(Listaa)


def drop(event):
    DroppableText.set(event.data)


ColumnLetter = tk.StringVar()
ColumnLetter.trace_add('write',convert_uppercase)


RowNumber = tk.StringVar()
RowNumber.trace_add('write',IsANumber)






Topframe = ttk.Frame(root, width = 400, height = 125, borderwidth = 1)#, relief = tk.GROOVE)
Topframe.pack(expand = True, fill = 'both')


frameInsideTopleft = ttk.Frame(Topframe, width = 50, height = 75, borderwidth = 10, relief = tk.GROOVE)
frameInsideTopleft.pack(expand = True, side = 'left', fill = 'both')

LabelLetterColumn = ttk.Label(frameInsideTopleft, text = "Lettera Colonna")
LabelLetterColumn.pack(expand=True, side = 'top')

EntryLetterColumn = ttk.Entry(frameInsideTopleft, width = 7, textvariable = ColumnLetter)
EntryLetterColumn.pack(expand=True)





frameInsideTopRight = ttk.Frame(Topframe, width = 50, height = 75, borderwidth = 10, relief = tk.GROOVE)
frameInsideTopRight.pack(expand = True, side = 'right', fill = 'both')

LabelNumberColumn = ttk.Label(frameInsideTopRight, text = "Numero Riga")
LabelNumberColumn.pack(expand=True, side = 'top')

EntryNumberColumn = ttk.Entry(frameInsideTopRight, width = 7, textvariable= RowNumber)
EntryNumberColumn.pack(expand=True)





BottomFrame = ttk.Frame(root, width = 400, height = 125, borderwidth = 10)#, relief = tk.GROOVE)
BottomFrame.pack(expand = True, fill = 'both',pady=10)




DroppableText = tk.StringVar()
DroppableText.set("Trascina qui...")

LabelExcelPathExplain = ttk.Label(BottomFrame, text = "Trascinare qui il file da cui estrarre i valori delle celle")
LabelExcelPathExplain.pack(expand=True, side = 'top')

EntryExcelFilePath = ttk.Entry(BottomFrame, width = 50, textvariable=DroppableText)
EntryExcelFilePath.pack(expand=True, pady=1)
EntryExcelFilePath.drop_target_register(DND_FILES)
EntryExcelFilePath.dnd_bind("<<Drop>>", drop)





VariableRadioButton = tk.StringVar()

FrameRadioButton = ttk.Frame(root, width = 400, height = 100, borderwidth = 10, relief = tk.GROOVE)
FrameRadioButton.pack(fill="both",expand=True)

LabelRadioButton = ttk.Label(FrameRadioButton, text = "Le celle scorrono per righe o colonne?")
LabelRadioButton.pack(side=tk.TOP, pady =15)

ColonneButton = tk.Radiobutton(FrameRadioButton,text="Colonne", value = "Colonne", variable = VariableRadioButton)
ColonneButton.pack(side=tk.RIGHT, expand=True)

RigheButton = tk.Radiobutton(FrameRadioButton,text="Righe", value = "Righe", variable = VariableRadioButton)
RigheButton.pack(side=tk.LEFT, expand=True)





Frameextract = ttk.Frame(root, width = 400, height = 50, borderwidth = 10, relief = tk.GROOVE)
Frameextract.pack(fill="both",expand=True)

BottoneInvio = ttk.Button(Frameextract, text = 'Estrai', command = TakeData)
BottoneInvio.pack(expand=True)








label = ttk.Label(root, text = 'Lista valori celle')
label.pack(expand = True)


ListaElementi = tk.Listbox(root, listvariable=var, height=20, selectmode=tk.MULTIPLE)
ListaElementi.pack(pady=4,expand=True,fill="both")


root.mainloop()
