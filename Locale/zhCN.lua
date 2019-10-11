local L = LibStub("AceLocale-3.0"):NewLocale("FastGuildInvite", "zhCN")
if not L then return end
L = FGI.Locale.zhCN

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



L.settings = {
	size = {
		mainFrameW = 600,
		mainFrameH = 300,
		wheelHint = 350,
		inviteTypeGRP = 200,
		backgroundRun = 220,
		enableFilters = 150,
		startScan = 130,
		chooseInvites = 130,
		settingsBtn = 130,
		gratitude = 130,
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
		blackListW = 200,
		blackListH = 360,
		blackList = 150,
		uninviteW = 220,
		uninviteH = 160,
		
		classLabel = 60,
		Ignore = 120,
		DeathKnight = 130,
		DemonHunter = 160,
		Druid = 70,
		Hunter = 80,
		Mage = 50,
		Monk = 70,
		Paladin = 80,
		Priest = 60,
		Rogue = 95,
		Shaman = 70,
		Warlock = 120,
		Warrior = 60,
		
		raceLabel = 60,
		Orc = 50,
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
	Font = 'Interface\\AddOns\\FastGuildInvite\\fonts\\simhei.ttf',
	FontSize = 16,
}

L.femaleClass = {}
for k,v in pairs(L.class) do
	local n = LOCALIZED_CLASS_NAMES_FEMALE[k:upper()]
	if v~=n then
		L.femaleClass[k] = n
	end
end