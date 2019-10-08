local L = LibStub("AceLocale-3.0"):GetLocale("FastGuildInvite")

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
	{L["Тестирование"], "Shujin", "-", "-"},
	{L["Тестирование"], "StreetX", "-", "-"},
	{L["Тестирование"], "Мойгосподин", "-", "-"},
	{L["Тестирование"], "Zipacna", "-", "-"},
	{L["Другая помощь"], "(Змейталак) <Нам Везёт Мы Играем>", "-", "-"},
}