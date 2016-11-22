require "tk"
 
class GUIDemo
    def initialize
        # 設定 GUI 各元件
        root = TkRoot.new { 
            title "EncryptGUI Demo"
        }
        @inputText = TkLabel.new(root) {
            text "Input:"
            width 8
            height 1
            grid('row'=>0, 'column'=>0)
        }
        @inputField = TkEntry.new(root) {
            width 60
            grid('row'=>0, 'column'=>1, 'columnspan'=>6)
        }
        @outputText = TkLabel.new(root) {
            text 'Output:'
            width 8
            height 1
            grid('row'=>1, 'column'=>0)
        }
        @outputField = TkEntry.new(root) {
            width 60
            grid('row'=>1, 'column'=>1, 'columnspan'=>6)
        }
        @newButton = TkButton.new(root) {
            text "New"
            grid('row'=>2, 'column'=>0)
        }
        @loadButton = TkButton.new(root) {
            text "Load"
            grid('row'=>2, 'column'=>1)
        }
        @saveButton = TkButton.new(root) {
            text "Save"
            grid('row'=>2, 'column'=>2)
        }
        @encodeButton = TkButton.new(root) {
            text "Encode"
            grid('row'=>2, 'column'=>3)
        }
        @decodeButton = TkButton.new(root) {
            text "Decode"
            grid('row'=>2, 'column'=>4)
        }
        @clearButton = TkButton.new(root) {
            text "Clear"
            grid('row'=>2, 'column'=>5)
        }
        @copyButton = TkButton.new(root) {
            text "Copy"
            grid('row'=>2, 'column'=>6)
        }
        @displayText = TkLabel.new(root) {
            text 'something happened'
            width 65
            height 1;
            grid('row'=>4, 'column'=>0, 'columnspan'=>7)
        }
    end
end
 
GUIDemo.new
Tk.mainloop