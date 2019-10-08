local function GetRaceName(id)
	return C_CreatureInfo.GetRaceInfo(id) and C_CreatureInfo.GetRaceInfo(id).raceName or nil
end


local L = LibStub("AceLocale-3.0"):NewLocale("FastGuildInvite", "ruRU", true)
--@localization(locale="ruRU", format="lua_additive_table", same-key-is-true=true)@

L.synchBaseType = {
	"blacklist",
	"invitations",
}

L = LibStub("AceLocale-3.0"):GetLocale("FastGuildInvite")

L.synchType = {
	L["Черный список"],
	L["Список приглашенных"],
}

L.settings = {
	size = {
		mainFrameW = 620,
		mainFrameH = 320,
		wheelHint = 350,
		inviteTypeGRP = 200,
		backgroundRun = 220,
		enableFilters = 150,
		startScan = 160,
		chooseInvites = 180,
		settingsBtn = 120,
		gratitude = 120,
		lvlRange = 150,
		searchInterval = 120,
		raceFilterStart = 160,
		classFilterStart = 160,
		settingsFrameW = 550,
		settingsFrameH = 260,
		addonMSG = 230,
		systemMSG = 245,
		sendMSG = 270,
		minimapButton = 260,
		rememberAll = 260,
		clearDBtimes = 150,
		filters = 150,
		keyBindingsW = 440,
		keyBindingsH = 150,
		keyBind = 200,
		setMSG = 160,
		filtersFrameW = 620,
		filtersFrameH = 300,
		addFilter = 150,
		addfilterFrameW = 600,
		addfilterFrameH = 600,
		messageFrameW = 600,
		messageFrameH = 300,
		yes = 100,
		no = 100,
		save = 100,
		delete = 100,
		add = 100,
		chooseInvitesW = 400,
		chooseInvitesH = 100,
		reject = 100,
		invite = 100,
		blackListW = 400,
		blackListH = 360,
		blackList = 150,
		uninviteW = 220,
		uninviteH = 160,
		customListW = 360,
		customListH = 360,
		customListBtn = 200,
		synchFrameW = 450,
		synchFrameH = 250,
		sendRequest = 150,
		synchBtn = 200,
		
		classLabel = 60,
		Ignore = 120,
		DeathKnight = 130,
		DemonHunter = 160,
		Druid = 70,
		Hunter = 80,
		Mage = 50,
		Monk = 70,
		Paladin = 80,
		Priest = 65,
		Rogue = 95,
		Shaman = 70,
		Warlock = 125,
		Warrior = 60,
		
		raceLabel = 60,
		Orc = 55,
		Undead = 80,
		Tauren = 75,
		Troll = 75,
		BloodElf = 100,
		Goblin = 75,
		Nightborne = 140,
		HightmountainTauren = 150,
		MagharOrc = 85,
		Pandaren = 95,
		Human = 100,
		Dwarf = 100,
		NightElf = 120,
		Gnome = 100,
		Draenei = 100,
		Worgen = 100,
		VoidElf = 130,
		LightforgedDraenei = 150,
		DarkIronDwarf = 160,
		ZandalariTroll = 120,
		KulTiran = 120,
		
		
		filterNameLabel = 200,
		excludeNameLabel = 200,
		lvlRangeLabel = 200,
		excludeRepeatLabel = 200,
		saveButton = 100,
		
		scanFrameW = 260,
		scanFrameH = 105,
		inviteBTN = 120,
		clearBTN = 70,
	},
	Font = 'Interface\\AddOns\\FastGuildInvite\\fonts\\PT_Sans_Narrow.ttf',
	FontSize = 16,
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