# nms-auto-hex-mod-builder
Auto Hex Mod Builder for NMS - Build Mods without the need of MbinCompiler

No more wait for MbinCompiler updates after game updates to quickly update your mods.
Only suited for simple number value change based mods.

Usage: 
Delete all contents of MODBUILDER\MOD\ folder.
Edit mod.lua to fit your needs.
Start BuildMod.bat and the mod appears in the same folder.

Creating new mod.lua scripts:
The structure of VALUE_CHANGE_TABLE:
{ Original Value, 	New Value, 	Order of Occurence (in case of multiple same values in mbin), Value Property Name (unneeded, only for reference) },

To find out the Order of Occurence number just search the value in a decompiled exml file and count how many times the value occurs until you reach
your desired property value.
