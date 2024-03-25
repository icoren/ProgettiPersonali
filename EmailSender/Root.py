from WriteWindow import *

def validate_input(char):
   return char.isdigit() or char == ""

entry_list = []
entriesnumbr = 0

def getnmail():
    global entriesnumbr
    try:
        if NMails.get() > 25:
            messagebox.showwarning("Attenzione!","Puoi mandare un massimo di 25 Mail simultaneamente")
            return
    except TclError:
        return
    if entriesnumbr < NMails.get():
        for i in range(NMails.get() - entriesnumbr):
            entry = tk.Entry(EntriesFrame, width=35)
            entry.pack(pady=5, side=TOP)
            entry_list.append(entry)
            entriesnumbr += 1
    if entriesnumbr > NMails.get():
        temp = entriesnumbr -1
        while temp >= NMails.get():
            entry_list[temp].destroy()
            del entry_list[temp]
            temp -= 1
        entriesnumbr = temp + 1


root = tk.Tk()
root.title("Email Sender")
root.geometry('350x800+650+100')
root.iconbitmap('./email.ico')
#root.maxsize(700, 500)

#Righe e Colonne
root.columnconfigure(0, weight=1)
root.rowconfigure(0, weight=1)
root.rowconfigure(1, weight=15)
root.rowconfigure(2, weight=1)


#Frames
TopFrame = ttk.Frame(root)
EntriesFrame = ttk.Frame(root)
BottomFrame = ttk.Frame(root)
#Labels
labelText = ttk.Label(TopFrame, text="A quanti indirizzi mandare la Mail?") 
#SpinBox
validate_cmd = (root.register(validate_input), '%S') #definizione della tupla
NMails = tk.IntVar()   
MailEntry = ttk.Spinbox(TopFrame, width = 6, from_=0, to=25, textvariable=NMails, validate="key",validatecommand=validate_cmd)
MailEntry.focus_set()
MailEntry.delete(0)
#Buttons
n_mails_bttn = ttk.Button(TopFrame, text="Ok", command=getnmail)
WriteBtn = ttk.Button(BottomFrame, text="Scrivi la Mail", command=lambda: WriteMail(root,entry_list))

#Deploy
#Frame
TopFrame.grid(row=0,column=0, sticky='nsew')
EntriesFrame.grid(row=1,column=0, sticky='nsew')
BottomFrame.grid(row=2,column=0, sticky="nswe")
#Labels
labelText.pack(fill=BOTH,side=LEFT, padx=10)
#label1.grid()
#Entries
MailEntry.pack(side=LEFT, padx=10)
#Buttons
n_mails_bttn.pack(side=LEFT, padx=10)
WriteBtn.pack(pady=15, side=BOTTOM)

root.mainloop()
