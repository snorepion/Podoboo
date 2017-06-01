Status Effect.
It's status bar editor, except it can edit stuff like super status bar editor can, instead of just the normal status bar.

New version contains significantly less suck. It's an entire code rewrite, switched to gtk instead of wx. It runs much faster since I'm not totally inept anymore. Includes such novel features as "Menus" and "Keyboard Shortcuts" and "Not using strings for everything".

This version now uses an installer for windows distribution. The directories created by py2exe are too messy to distribute normally and an installed application is nice anyways. If you don't want that, use the source.

Freespace can be either found automagicaly by the program or you can insert it yourself. Your choice.

If you don't know how to find freeRAM, you probably won't have to change it.

ROM should be expanded before use. The option to load directly from GFX files has been removed due to it being silly.

The program assumes a level105 palette. If you want to change this, load a new palette file with the
"Import Palette" menu or "ctrl+p". This vesion supports .pal, .mw3, and .zst as well as the normal .tpl.

"Found Nintendo's code, which needs to be replaced for you to edit counters"
Nintendo seems to have done something really stupid with the score counter and small bonus star counter
where instead of just storing where it's meant to, it stores to the begining of the status bar and indexes by x.
I can't think why it does that, and chaning it to be "normal" works fine, so that's what this does.
