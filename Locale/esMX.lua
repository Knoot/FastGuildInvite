local L = LibStub("AceLocale-3.0"):NewLocale("FastGuildInvite", "esMX")
if not L then return end
--@localization(locale="esMX", format="lua_additive_table", same-key-is-true=true)@

L.synchBaseType = {
	"blacklist",
	"invitations",
}

L = LibStub("AceLocale-3.0"):GetLocale("FastGuildInvite")

L.synchType = {
	L["Черный список"],
	L["Список приглашенных"],
}
L.femaleRace = {
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

L.femaleClass = {}
for k,v in pairs(L.class) do
	local n = LOCALIZED_CLASS_NAMES_FEMALE[k:upper()]
	if v~=n then
		L.femaleClass[k] = n
	end
end