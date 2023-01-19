
class BurstObj {
    __New() {
        this.Active_Hotkey := []
    }

    Run() {
        this.Suspend()
        for i,c in config.Read() {
            this.Active_Hotkey.Push(c[1])
            Hotkey(c[1], this.Key_Action.bind(this), "On")
        }
    }

    Suspend() {
        for i,c in this.Active_Hotkey {
            Hotkey(c, this.Key_Action.bind(this), "Off")
        }
        this.Active_Hotkey := []
    }

    Key_Action(Hotkey) {
        SendInput(config.GetText(Hotkey))
    }
}
