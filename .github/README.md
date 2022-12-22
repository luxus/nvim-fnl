# my nvim config
i copied the config from https://github.com/aileot/nvim-fnl
it uses the https://github.com/aileot/nvim-laurel macros
at the moment i try to make it work with the instructions from https://github.com/aileot/nvim-laurel/issues/155
the init.lua needs to be ~/.config/nvim/init.lua and this folder ~/.config/nvim/fnl

```sh
#delete old stuff
rm -rf ~/.cache/nvim ~/.local/share/nvim ~/.config/nvim
#creating folder
mkdir ~/.config/nvim
#clone it
cd ~/.config/nvim
git clone https://github.com/luxus/nvim-fnl.git fnl
#link the init.lua
ln -s fnl/init.lua ./
```
