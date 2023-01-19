
class MainUI {
    __New(Title := "Key Burst") {
        this.Title := Title
        this.UI := Gui("", this.Title)
        this.ListView := this.UI.AddListView("x15 y15 w450 h255", ["Hotkey", "Text"])
        this.BtnAdd := this.UI.AddButton("x15 y275 w150 h30", "Add")
        this.BtnEdit := this.UI.AddButton("x165 y275 w150 h30", "Edit")
        this.BtnRemove := this.UI.AddButton("x315 y275 w150 h30", "Remove")
        this.BtnAdd.OnEvent("Click", this.BtnAdd_Action.bind(this))
        this.BtnEdit.OnEvent("Click", this.BtnEdit_Action.bind(this))
        this.BtnRemove.OnEvent("Click", this.BtnRemove_Action.bind(this))
        this.UI.OnEvent("Close", this.Exit.bind(this))
        this.CurrentEditHotkey := ""

        this.Add_UI := Gui("", this.Title . " - Add")
        this.Add_UI.AddText("x25 y25 w75 h15", "Input hotkey:")
        this.Add_InputHotkey := this.Add_UI.AddHotkey("x25 y45 w135 h20")
        this.Add_UI.AddText("x25 y75 w55 h15", "Input text:")
        this.Add_InputText := this.Add_UI.AddEdit("x25 y95 w290 h20")
        this.Add_BtnAdd := this.Add_UI.AddButton("x25 y130 w145 h30", "Add")
        this.Add_BtnDiscard := this.Add_UI.AddButton("x170 y130 w145 h30", "Discard")
        this.Add_BtnAdd.OnEvent("Click", this.Add_BtnAdd_Action.bind(this))
        this.Add_BtnDiscard.OnEvent("Click", this.Add_BtnDiscard_Action.bind(this))
        this.Add_UI.OnEvent("Close", this.Add_BtnDiscard_Action.bind(this))

        this.Edit_UI := Gui("", this.Title . " - Add")
        this.Edit_UI.AddText("x25 y25 w75 h15", "Input hotkey:")
        this.Edit_InputHotkey := this.Edit_UI.AddHotkey("x25 y45 w135 h20")
        this.Edit_UI.AddText("x25 y75 w55 h15", "Input text:")
        this.Edit_InputText := this.Edit_UI.AddEdit("x25 y95 w290 h20")
        this.Edit_BtnSave := this.Edit_UI.AddButton("x25 y130 w145 h30", "Save")
        this.Edit_BtnDiscard := this.Edit_UI.AddButton("x170 y130 w145 h30", "Discard")
        this.Edit_BtnSave.OnEvent("Click", this.Edit_BtnSave_Action.bind(this))
        this.Edit_BtnDiscard.OnEvent("Click", this.Edit_BtnDiscard_Action.bind(this))
        this.Edit_UI.OnEvent("Close", this.Edit_BtnDiscard_Action.bind(this))
    }

    ; main
    Update() {
        this.ListView.Delete()
        for i,c in config.Read()
            this.ListView.Add(, c[1], c[2])
    }

    Show() {
        this.Update()
        this.UI.Show("w480 h319")
    }

    Exit(*) {
        ExitApp()
    }

    ; add
    BtnAdd_Action(*) {
        this.UI.Opt("+Disabled")
        Burst.Suspend()
        this.Add_InputHotkey.Value := ""
        this.Add_InputText.Value := ""
        this.Add_UI.Show("w340 h192")
    }
    Add_BtnAdd_Action(*) {
        if (!this.Add_InputHotkey.Value) or (!this.Add_InputText.Value){
            MsgBox("Please fill in the blank(s).")
            return
        }
        try {
            config.Write(this.Add_InputHotkey.Value, this.Add_InputText.Value)
        } catch Any as e {
            if (e == -1){
                MsgBox("Hotkey already exist.")
                return
            }
            if (e == -2){
                MsgBox("Can't write.")
                return
            }
        }
        this.UI.Opt("-Disabled")
        this.Update()
        this.Add_UI.Hide()
        Burst.Run()
    }
    Add_BtnDiscard_Action(*) {
        this.UI.Opt("-Disabled")
        this.Update()
        this.Add_UI.Hide()
        Burst.Run()
    }

    ; edit
    BtnEdit_Action(*) {
        if (this.ListView.GetText(this.ListView.GetNext(0, "Focused")) == "Hotkey"){
            return
        }
        this.UI.Opt("+Disabled")
        Burst.Suspend()
        this.CurrentEditHotkey := this.ListView.GetText(this.ListView.GetNext(0, "Focused"))
        this.Edit_InputHotkey.Value := this.CurrentEditHotkey
        this.Edit_InputText.Value := config.GetText(this.ListView.GetText(this.ListView.GetNext(0, "Focused")))
        this.Edit_UI.Show("w340 h192")
    }
    Edit_BtnSave_Action(*) {
        if (!this.Edit_InputHotkey.Value) or (!this.Edit_InputText.Value){
            MsgBox("Please fill in the blank(s).")
            return
        }
        try{
            config.Remove(this.CurrentEditHotkey)
        } catch Any as e {
            if (e == -1){
                MsgBox("Can't write.")
                return
            }
        }
        try {
            config.Write(this.Edit_InputHotkey.Value, this.Edit_InputText.Value)
        } catch Any as e {
            if (e == -1){
                MsgBox("Hotkey already exist.")
                return
            }
            if (e == -2){
                MsgBox("Can't write.")
                return
            }
        }
        this.UI.Opt("-Disabled")
        this.Update()
        this.Edit_UI.Hide()
        Burst.Run()
    }
    Edit_BtnDiscard_Action(*) {
        this.UI.Opt("-Disabled")
        this.Update()
        this.Edit_UI.Hide()
        Burst.Run()
    }

    ; remove
    BtnRemove_Action(*) {
        this.UI.Opt("+Disabled")
        Burst.Suspend()
        if (this.ListView.GetText(this.ListView.GetNext(0, "Focused")) == "Hotkey"){
            this.Update()
            this.UI.Opt("-Disabled")
            Burst.Run()
            return
        }
        if (MsgBox("Are you sure you want to remove this hotkey?", this.Title . " - Remove", "YN") != "Yes"){
            this.Update()
            this.UI.Opt("-Disabled")
            Burst.Run()
            return
        }
        try {
            config.Remove(this.ListView.GetText(this.ListView.GetNext(0, "Focused"), 1))
        } catch Any as e {
            if (e == -1){
                MsgBox("Can't write.")
            }
        }
        this.Update()
        this.UI.Opt("-Disabled")
        Burst.Run()
    }
}
