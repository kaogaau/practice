require 'tk'
root = TkRoot.new
root.title = "Hello, Tk!"
some = TkLabel.new(root) do
    text "Tk's job!!"
    height 5
    width 30
    grid("row"=>0, "column"=>0)
end
Tk.mainloop