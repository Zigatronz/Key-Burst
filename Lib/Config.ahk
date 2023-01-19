
class ConfigObj {
    __New(filename := "config.ini") {
        this.filename := filename
        this.HotkeyKey := "Hotkey"
        this.TextKey := "Text"
    }

    ; return array of [hotkey, text]
    Read() {
        output := []
        index := 0
        loop {
            index += 1
            try{
                output.Push([
                    IniRead(this.filename, String(index), this.HotkeyKey),
                    IniRead(this.filename, String(index), this.TextKey)
                ])
            }catch{
                break
            }
        }
        return output
    }

    ; return empty str if not found
    GetHotkey(Text) {
        for i,c in this.Read() {
            if (c[2] == Text){
                return c[1]
            }
        }
        return ""
    }

    ; return empty str if not found
    GetText(Hotkey) {
        for i,c in this.Read() {
            if (c[1] == Hotkey){
                return c[2]
            }
        }
        return ""
    }
    
    ;  0 : Success
    ; -1 : Same hotkey exists
    ; -2 : Problem when writing
    Write(Hotkey, Text) {
        if (this.GetText(Hotkey)){
            throw -1
        }
        try{
            index := this.Read().Length + 1
            IniWrite(StrUpper(Hotkey), this.filename, String(index), this.HotkeyKey)
            IniWrite(Text, this.filename, String(index), this.TextKey)
            throw 0
        }catch{
            throw -2
        }
    }
        
    ;  0 : Success
    ; -1 : Problem when writing
    Remove(Hotkey) {
        data := this.Read()
        oldDataFilename := this.filename . ".old"
        FileMove(this.filename, oldDataFilename) ; for data protection
        for i,c in data {
            if (c[1] != Hotkey){
                try {
                    this.Write(c[1], c[2])
                } catch Any as e {
                    if (e == -2) {
                        MsgBox("Failed to write")
                        if (FileExist(this.filename)){
                            FileDelete(this.filename)
                        }
                        FileMove(oldDataFilename, this.filename)
                        throw -1
                    }
                }
            }
        }
        FileDelete(oldDataFilename)
        throw 0
    }
}
