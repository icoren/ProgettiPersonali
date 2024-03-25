import tkinter as tk
from TkinterDnD2 import DND_FILES
from TkinterDnD2 import TkinterDnD
from tkinter import *
from tkinter import ttk
from tkinter import messagebox
from ActualEmailSender import *




def WriteMail(Root,entry_list):

    if not entry_list:
        messagebox.showerror("Attenzione!","Non hai specificato nessun indirzzo a cui mandare la mail!")
        return

    ListaMails = []
    for entry in entry_list:
        ListaMails.append(entry.get())


    Root.destroy()

    ListaFile = []

    def AggiungiAListaFile(Path, ListaFile = ListaFile):
        giapresente = False
        for elemento in ListaFile:
             if elemento == Path:
                giapresente = True
        if giapresente:
            pass
        else:
            ListaFile.append(Path)
        Path = ""
        return giapresente



    def drop_inside_list_box(event, ListaFile=ListaFile):

        print(f"{event.data}\n")

        ApertaParentesi = False
        Path : str = "" 
        lng = 0

        for lettera in event.data:
            lng += 1
            if lettera == "{":
                ApertaParentesi = True
            else:
                if ApertaParentesi == False:
                    if lng == len(event.data):
                        Path = Path + lettera
                        if not AggiungiAListaFile(Path):
                            Files.insert("end",Path.split("/")[-1])
                        Path=""
                    if lettera == " " and Path != "" :
                        if not AggiungiAListaFile(Path):
                            Files.insert("end",Path.split("/")[-1])
                        Path = ""
                    if lettera == " " and Path == "":
                        pass
                    else:
                        Path = Path + lettera
                        
                if ApertaParentesi:
                    if lettera == "}":
                        ApertaParentesi = False
                        if not AggiungiAListaFile(Path):
                            Files.insert("end",Path.split("/")[-1])
                        Path=""
                    else:
                        Path = Path + lettera



        for elemento in ListaFile:
            print(f"{elemento}\n")
    
    def Remove():
        selected_indices = Files.curselection()
        RemoveList = []
        for index in reversed(selected_indices): 
            RemoveList.append(Files.get(index))
            Files.delete(index)
        indices_to_remove = [index for index, path in enumerate(ListaFile) if any(filename in path for filename in RemoveList)]
        for index in reversed(indices_to_remove):
            ListaFile.pop(index)
        for i in ListaFile:
            print(f"{i}\n")





    Writewndw = TkinterDnD.Tk()
    Writewndw.title("Scrivi la mail")
    Writewndw.geometry('550x800+50+50') 

    Writewndw.columnconfigure(0, weight=1)
    Writewndw.rowconfigure(0, weight=3)
    Writewndw.rowconfigure(1, weight=1)
    Writewndw.rowconfigure(2, weight=1)
    Writewndw.rowconfigure(3, weight=1)
    Writewndw.rowconfigure(4, weight=10)

    #Frames
    ObjectFrame = ttk.Frame(Writewndw)
    ObjectFrame.grid(column=0,row=0,sticky="nswe")
    CenterFrame = ttk.Frame(Writewndw)
    CenterFrame.grid(column=0,row=1,sticky="nswe")
    TextFrame = ttk.Frame(Writewndw)
    TextFrame.grid(column=0,row=2,sticky="nswe")
    TextFrame2 = ttk.Frame(Writewndw)
    TextFrame2.grid(column=0,row=3,sticky="nswe")
    BottomFrame = ttk.Frame(Writewndw)
    BottomFrame.grid(column=0,row=4,sticky="nswe")
    #Button
    Remov = ttk.Button(TextFrame2, text="Rimuovi", command=Remove)
    Remov.pack(padx=100,pady=5)


    Send = ttk.Button(BottomFrame,text="Invia",command=lambda: Snd(ListaFile,ListaMails,ObjEntry.get(),Body.get("1.0", tk.END)))
    Send.pack(side=BOTTOM,padx=5,pady=50)
    #Labels
    ObjLabl = ttk.Label(ObjectFrame, text="Oggetto:")
    ObjLabl.pack(side=LEFT, padx=5, pady=5)
    TxtLabl = ttk.Label(CenterFrame, text="Corpo:")
    TxtLabl.pack(side=LEFT, padx=5, pady=5)
    lbl = ttk.Label(BottomFrame, text="Trascinare qui i file da allegare, selezionarli e premere Rimuovi per annullare")
    lbl.pack(side=BOTTOM, padx=5, pady=5)
    #Entries
    ObjEntry = ttk.Entry(ObjectFrame,width=100,background="red")
    ObjEntry.pack(padx=5, side=RIGHT)
    #Text
    Body = tk.Text(TextFrame,width=200,font=("Arial",10))
    Body.pack(padx=25)
    #FileDragNDrop
    Files = tk.Listbox(BottomFrame,selectmode=tk.MULTIPLE)
    Files.pack(pady=1,padx=25,fill=BOTH,expand=True)
    Files.drop_target_register(DND_FILES)
    Files.dnd_bind("<<Drop>>", drop_inside_list_box)



    Writewndw.mainloop()