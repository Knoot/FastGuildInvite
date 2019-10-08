local L = LibStub("AceLocale-3.0"):NewLocale("FastGuildInvite", "enUS")
if not L then return end
--@localization(locale="enUS", format="lua_additive_table", same-key-is-true=true)@


L.synchBaseType = {--		WARNING
	"blacklist",
	"invitations",
}

L = LibStub("AceLocale-3.0"):GetLocale("FastGuildInvite")
L.settings.size.Mage = 60
L.settings.size.Priest = 80
L.settings.size.Shaman = 80
L.settings.size.Warrior = 80


L.femaleClass = {
	Orc = L["Orc"],
	Tauren = L["Tauren"],
	Dwarf = L["Tauren"],
	Gnome = L["Gnome"],
	NightElf = L["NightElf"],
	BloodElf = L["BloodElf"],
	HightmountainTauren = L["HightmountainTauren"],
	MagharOrc = L["MagharOrc"],
	Nightborne = L["Nightborne"],
	Pandaren = L["Pandaren"],
	ZandalariTroll = L["ZandalariTroll"],
	DarkIronDwarf = L["DarkIronDwarf"],
	Draenei = L["Draenei"],
	LightforgedDraenei = L["LightforgedDraenei"],
	VoidElf = L["VoidElf"],
	KulTiran = L["KulTiran"],
}
