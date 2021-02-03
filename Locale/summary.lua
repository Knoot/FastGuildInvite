local function GetRaceName(id)
	return C_CreatureInfo.GetRaceInfo(id) and C_CreatureInfo.GetRaceInfo(id).raceName or nil
end

local L = {}

local locale = GetLocale()
local function GetL(ru,en,cur)
	ru = ru or FGI.L["ruRU"]
	en = en or FGI.L["enUS"] or {}
	cur = cur or FGI.L[locale] or {}
	local L = {}
	for k,v in pairs(ru) do
		if type(v) == "table" then
			L[k] = GetL(v,en[k] or {},cur[k] or {})
		else
			L[k] = cur[k] or en[k] or v
		end
	end
	return L
end
FGI.L[locale] = GetL()
L = FGI.L[locale]


L.synchType = {
	L["Черный список"],
	L["Список приглашенных"],
}

L.femaleRace = {
	Orc = L["Orc"],
	Tauren = L["Tauren"],
	Dwarf = L["Dwarf"],
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
	Mechagnome = L["Mechagnome"],
}

L.class = {
	DeathKnight = LOCALIZED_CLASS_NAMES_MALE.DEATHKNIGHT,
	DemonHunter = LOCALIZED_CLASS_NAMES_MALE.DEMONHUNTER,
	Druid = LOCALIZED_CLASS_NAMES_MALE.DRUID,
	Hunter = LOCALIZED_CLASS_NAMES_MALE.HUNTER,
	Mage = LOCALIZED_CLASS_NAMES_MALE.MAGE,
	Monk = LOCALIZED_CLASS_NAMES_MALE.MONK,
	Paladin = LOCALIZED_CLASS_NAMES_MALE.PALADIN,
	Priest = LOCALIZED_CLASS_NAMES_MALE.PRIEST,
	Rogue = LOCALIZED_CLASS_NAMES_MALE.ROGUE,
	Shaman = LOCALIZED_CLASS_NAMES_MALE.SHAMAN,
	Warlock = LOCALIZED_CLASS_NAMES_MALE.WARLOCK,
	Warrior = LOCALIZED_CLASS_NAMES_MALE.WARRIOR,
}
L.race = {
	Horde = {
		Orc = GetRaceName(2),	--	"Орк"
		Tauren = GetRaceName(6),	--	"Таурен"
		Troll = GetRaceName(8),	--	"Тролль"
		Undead = GetRaceName(5),	--	"Нежить"
		BloodElf = GetRaceName(10),	--	"Эльф крови"
		Goblin = GetRaceName(9),	--	"Гоблин"
		HightmountainTauren = GetRaceName(28),	--	"Таурен Крутогорья"
		MagharOrc = GetRaceName(36),	--	"Маг'хар"
		Nightborne = GetRaceName(27),	--	"Ночнорожденный"
		Pandaren = GetRaceName(26),	--	"Пандарен"
		ZandalariTroll = GetRaceName(31),	--	"Зандалар"
		Vulpera = GetRaceName(35),	--	"Вульпера"
	},
	Alliance = {
		Dwarf = GetRaceName(3),	--	"Дворф"
		Gnome = GetRaceName(7),	--	"Гном"
		Human = GetRaceName(1),	--	"Человек"
		NightElf = GetRaceName(4),	--	"Ночной эльф"
		DarkIronDwarf = GetRaceName(34),	--	"Дворф из клана Черного Железа"
		Draenei = GetRaceName(11),	--	"Дреней"
		LightforgedDraenei = GetRaceName(30),	--	"Озаренный дреней"
		Pandaren = GetRaceName(25),	--	"Пандарен"
		VoidElf = GetRaceName(29),	--	"Эльф Бездны"
		Worgen = GetRaceName(22),	--	"Ворген"
		KulTiran = GetRaceName(32),	--	"Култирасец"
		Mechagnome = GetRaceName(37),	--	"Механогном"
	},
}
--[===[@non-retail@
L.class = {
	Druid = LOCALIZED_CLASS_NAMES_MALE.DRUID,
	Hunter = LOCALIZED_CLASS_NAMES_MALE.HUNTER,
	Mage = LOCALIZED_CLASS_NAMES_MALE.MAGE,
	Paladin = LOCALIZED_CLASS_NAMES_MALE.PALADIN,
	Priest = LOCALIZED_CLASS_NAMES_MALE.PRIEST,
	Rogue = LOCALIZED_CLASS_NAMES_MALE.ROGUE,
	Shaman = LOCALIZED_CLASS_NAMES_MALE.SHAMAN,
	Warlock = LOCALIZED_CLASS_NAMES_MALE.WARLOCK,
	Warrior = LOCALIZED_CLASS_NAMES_MALE.WARRIOR,
}
L.race = {
	Horde = {
		Orc = GetRaceName(2),	--	"Орк"
		Tauren = GetRaceName(6),	--	"Таурен"
		Troll = GetRaceName(8),	--	"Тролль"
		Undead = GetRaceName(5),	--	"Нежить"
	},
	Alliance = {
		Dwarf = GetRaceName(3),	--	"Дворф"
		Gnome = GetRaceName(7),	--	"Гном"
		Human = GetRaceName(1),	--	"Человек"
		NightElf = GetRaceName(4),	--	"Ночной эльф"
	},
}
--@end-non-retail@]===]

L.femaleClass = {}
for k,v in pairs(L.class) do
	local n = LOCALIZED_CLASS_NAMES_FEMALE[k:upper()]
	if v~=n then
		L.femaleClass[k] = n
	end
end

local size = L.settings.size

L.race = L.race[UnitFactionGroup("player")]


size.mainButtonsGRP = size.startScan + size.chooseInvites + size.settingsBtn
size.mainCheckBoxGRP = math.max(size.backgroundRun, size.enableFilters, size.customListBtn)
size.searchRangeGRP = math.max(size.lvlRange + size.raceFilterStart, size.searchInterval + size.classFilterStart)+30
size.settingsCheckBoxGRP = math.max(size.addonMSG, size.systemMSG, size.sendMSG, size.minimapButton, size.rememberAll)
size.settingsButtonsGRP = size.filters + size.keyBind + size.setMSG
size.raceShift = math.max(size.Ignore, size.DeathKnight, size.DemonHunter, size.Druid, size.Hunter, size.Mage, size.Monk, size.Paladin, size.Priest, size.Rogue, size.Shaman, size.Warlock, size.Warrior)
size.raceShift = size.raceShift - size.classLabel + 20
size.filterNameShift = {}
for k,v in pairs(L.race) do 
table.insert(size.filterNameShift, size[k]) 
end 
size.filterNameShift = math.max(unpack(size.filterNameShift) or size.raceShift) - size.raceLabel + 20
size.filtersEdit = math.max(size.filterNameLabel, size.excludeNameLabel, size.lvlRangeLabel, size.excludeRepeatLabel)

L.credits = {
	{L["Категория"], L["Имя"], L["Контакт"], "Donate"},
	{"", "", "", ""},
	{L["Автор"], "Knoot", "Knoot#7430", "paypal.me/Knoot"},
	{"Donate", "Anchep", "-", "-"},
	{"Donate", "dLuxian", "-", "-"},
	{"Donate", "Zipacna (Bleeding Hollow)\n<Imperial Patent>", "-", "-"},
	{L["Перевод"].."-zhTW", "Anchep", "Services@280i.com", "paypal.me/280i"},
	{L["Перевод"].."-koKR", "50000", "-", "-"},
	{L["Перевод"].."-enUS", "brute95", "-", "-"},
	{L["Перевод"].."-frFR", "Yazhura2017", "-", "-"},
	{L["Перевод"].."-deDE", "iamcekay", "-", "-"},
	{L["Перевод"].."-deDE", "Forge_User_70044994", "-", "-"},
	{L["Тестирование"], "Shujin", "-", "-"},
	{L["Тестирование"], "StreetX", "-", "-"},
	{L["Тестирование"], "Мойгосподин", "-", "-"},
	{L["Тестирование"], "Zipacna", "-", "-"},
	{L["Другая помощь"], "(Змейталак) <Нам Везёт Мы Играем>", "-", "-"},
}