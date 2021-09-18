local addon = FGI

addon.lib = LibStub("AceAddon-3.0"):NewAddon("FastGuildInvite")
addon.lib.WagoAnalytics = LibStub("WagoAnalytics"):Register("kRNLQ46o")
LibStub("AceEvent-3.0"):Embed(addon.lib)
local GUI = LibStub("AceGUI-3.0")
GUI:RegisterLayout("NIL", function()  end)

addon.DB = {}
addon.ruReg = "[%aабвгдеёжзийклмнопрстуфхцчшщъьыэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЬЫЭЮЯ'%s]"
addon.functions = {}
addon.autoCompleteRealms = GetAutoCompleteRealms()
table.insert(addon.autoCompleteRealms, (GetRealmName():gsub(" ", '')))
addon.interface = {}
addon.playerInfo = {
	faction = UnitFactionGroup('player') == "Horde" and 2 or 1
}
addon.version = GetAddOnMetadata('FastGuildInvite', 'Version')
addon.gversion = GetAddOnMetadata('FastGuildInvite', 'X-Interface')
addon.versionN = tonumber(GetAddOnMetadata('FastGuildInvite', 'Version')) or 0
addon.whoQueryList = {}
addon.color = {
	WARRIOR='|cffc79c6e',
	PALADIN='|cfff58cba',
	HUNTER='|cffabd473',
	ROGUE='|cfffff569',
	PRIEST='|cffffffff',
	DEATHKNIGHT='|cffc41f3b',
	SHAMAN='|cff0070de',
	MAGE='|cff3fc7eb',
	WARLOCK='|cff8788ee',
	MONK='|cff00ff96',
	DRUID='|cffff7d0a',
	DEMONHUNTER='|cffa330c9',
	green='|cff00ff00',
	red='|cffff0000',
	gray='|cff8c8c8c',
	yellow='|cffffff00',
	orange='|cffFFA500',
	blue='|cff00BFFF',
	purple='|cFF660099',
	pink='|cFFff6cff',
}
