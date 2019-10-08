local addon=FGI
local fn=addon.functions
local L = LibStub("AceLocale-3.0"):GetLocale("FastGuildInvite")
local CLASS = L.class
local interface = addon.interface
local settings = L.settings
local GUI = LibStub("AceGUI-3.0")
local color = addon.color
local FastGuildInvite = addon.lib
addon.search = {progress=1, inviteList={}, timeShift=0, tempSendedInvites={}, whoQueryList = {}}
addon.removeMsgList = {}
addon.libWho = {}
local DB
local debugDB
local nextSearch


addon.searchInfo = {unique = {0}, sended = {0}, invited = {0}, filtered = {0}}
local mt = {
	__call = function(self,n)
		self[1] = self[1] + (n==0 and -self[1] or (n or 1))
		interface.mainFrame.searchInfo.update(addon.searchInfo())
		return self[1]
	end
}
setmetatable(addon.searchInfo.unique,mt);setmetatable(addon.searchInfo.sended,mt);setmetatable(addon.searchInfo.invited,mt);setmetatable(addon.searchInfo.filtered,mt);
setmetatable(addon.searchInfo,{__call = function(self)
	return {self.unique[1], self.sended[1], self.invited[1], self.filtered[1]}
end});

local time, next = time, next

--@retail@
local RaceClassCombo = {
	Orc = {CLASS.Warrior,CLASS.Hunter,CLASS.Rogue,CLASS.Shaman,CLASS.Mage,CLASS.Warlock,CLASS.Monk,CLASS.DeathKnight},
	Undead = {CLASS.Warrior,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Mage,CLASS.Warlock,CLASS.Monk,CLASS.DeathKnight},
	Tauren = {CLASS.Warrior,CLASS.Paladin,CLASS.Hunter,CLASS.Priest,CLASS.Shaman,CLASS.Monk,CLASS.Druid,CLASS.DeathKnight},
	Troll = {CLASS.Warrior,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Shaman,CLASS.Mage,CLASS.Warlock,CLASS.Monk,CLASS.Druid,CLASS.DeathKnight},
	Human = {CLASS.Warrior,CLASS.Paladin,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Mage,CLASS.Warlock,CLASS.Monk,CLASS.DeathKnight},
	Dwarf = {CLASS.Warrior,CLASS.Paladin,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Shaman,CLASS.Mage,CLASS.Warlock,CLASS.Monk,CLASS.DeathKnight},
	NightElf = {CLASS.Warrior,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Mage,CLASS.Monk,CLASS.Druid,CLASS.DemonHunter,CLASS.DeathKnight},
	Gnome = {CLASS.Warrior,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Mage,CLASS.Warlock,CLASS.Monk,CLASS.DeathKnight},
	BloodElf = {CLASS.Warrior,CLASS.Paladin,CLASS.Hunter,CLASS.Priest,CLASS.Mage,CLASS.Warlock,CLASS.Monk,CLASS.DemonHunter,CLASS.DeathKnight},
	Goblin = {CLASS.Warrior,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Shaman,CLASS.Mage,CLASS.Warlock,CLASS.DeathKnight},
	Nightborne = {CLASS.Warrior,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Mage,CLASS.Warlock,CLASS.Monk},
	HightmountainTauren = {CLASS.Warrior,CLASS.Hunter,CLASS.Shaman,CLASS.Monk,CLASS.Druid},
	MagharOrc = {CLASS.Warrior,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Shaman,CLASS.Mage,CLASS.Monk},
	Pandaren = {CLASS.Warrior,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Shaman,CLASS.Mage,CLASS.Monk},
	Draenei = {CLASS.Warrior,CLASS.Paladin,CLASS.Hunter,CLASS.Priest,CLASS.Shaman,CLASS.Mage,CLASS.Monk,CLASS.DeathKnight},
	Worgen = {CLASS.Warrior,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Mage,CLASS.Warlock,CLASS.Druid,CLASS.DeathKnight},
	VoidElf = {CLASS.Warrior,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Mage,CLASS.Warlock,CLASS.Monk},
	LightforgedDraenei = {CLASS.Warrior,CLASS.Paladin,CLASS.Hunter,CLASS.Priest,CLASS.Mage},
	DarkIronDwarf = {CLASS.Warrior,CLASS.Paladin,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Shaman,CLASS.Mage,CLASS.Warlock,CLASS.Monk},
	KulTiran = {CLASS.Warrior,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Shaman,CLASS.Mage,CLASS.Monk,CLASS.Druid,},
	ZandalariTroll = {CLASS.Warrior,CLASS.Paladin,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Shaman,CLASS.Mage,CLASS.Monk,CLASS.Druid,},	
}
--@end-retail@
--[===[@non-retail@
local RaceClassCombo = {
	Orc = {CLASS.Warrior,CLASS.Hunter,CLASS.Rogue,CLASS.Shaman,CLASS.Mage,CLASS.Warlock,CLASS.Monk,CLASS.DeathKnight},
	Undead = {CLASS.Warrior,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Mage,CLASS.Warlock,CLASS.Monk,CLASS.DeathKnight},
	Tauren = {CLASS.Warrior,CLASS.Paladin,CLASS.Hunter,CLASS.Priest,CLASS.Shaman,CLASS.Monk,CLASS.Druid,CLASS.DeathKnight},
	Troll = {CLASS.Warrior,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Shaman,CLASS.Mage,CLASS.Warlock,CLASS.Monk,CLASS.Druid,CLASS.DeathKnight},
	Human = {CLASS.Warrior,CLASS.Paladin,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Mage,CLASS.Warlock,CLASS.Monk,CLASS.DeathKnight},
	Dwarf = {CLASS.Warrior,CLASS.Paladin,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Shaman,CLASS.Mage,CLASS.Warlock,CLASS.Monk,CLASS.DeathKnight},
	NightElf = {CLASS.Warrior,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Mage,CLASS.Monk,CLASS.Druid,CLASS.DemonHunter,CLASS.DeathKnight},
	Gnome = {CLASS.Warrior,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Mage,CLASS.Warlock,CLASS.Monk,CLASS.DeathKnight},
}
--@end-non-retail@]===]
function fn:FilterChange(id)
	local filtersFrame = interface.settings.filters.content.filtersFrame
	local addfilterFrame = interface.settings.filters.content.addfilterFrame
	local filter = FGI.DB.realm.filtersList[id]
	local class = filter.classFilter
	local raceFilter = filter.raceFilter
	
	filtersFrame.frame:Hide()
	addfilterFrame.frame:Show()
	
	
	if not class then
		addfilterFrame.classesCheckBoxIgnore:SetValue(true)
	else
		--@retail@
		addfilterFrame.classesCheckBoxIgnore:SetValue(false)
		addfilterFrame.classesCheckBoxDruid:SetValue(class[CLASS.Druid] or false)
		addfilterFrame.classesCheckBoxHunter:SetValue(class[CLASS.Hunter] or false)
		addfilterFrame.classesCheckBoxMage:SetValue(class[CLASS.Mage] or false)
		addfilterFrame.classesCheckBoxPaladin:SetValue(class[CLASS.Paladin] or false)
		addfilterFrame.classesCheckBoxPriest:SetValue(class[CLASS.Priest] or false)
		addfilterFrame.classesCheckBoxRogue:SetValue(class[CLASS.Rogue] or false)
		addfilterFrame.classesCheckBoxShaman:SetValue(class[CLASS.Shaman] or false)
		addfilterFrame.classesCheckBoxWarlock:SetValue(class[CLASS.Warlock] or false)
		addfilterFrame.classesCheckBoxWarrior:SetValue(class[CLASS.Warrior] or false)
		addfilterFrame.classesCheckBoxDeathKnight:SetValue(class[CLASS.DeathKnight] or false)
		addfilterFrame.classesCheckBoxDemonHunter:SetValue(class[CLASS.DemonHunter] or false)
		addfilterFrame.classesCheckBoxMonk:SetValue(class[CLASS.Monk] or false)
		--@end-retail@
		--[===[@non-retail@
		addfilterFrame.classesCheckBoxIgnore:SetValue(false)
		addfilterFrame.classesCheckBoxDruid:SetValue(class[CLASS.Druid] or false)
		addfilterFrame.classesCheckBoxHunter:SetValue(class[CLASS.Hunter] or false)
		addfilterFrame.classesCheckBoxMage:SetValue(class[CLASS.Mage] or false)
		addfilterFrame.classesCheckBoxPaladin:SetValue(class[CLASS.Paladin] or false)
		addfilterFrame.classesCheckBoxPriest:SetValue(class[CLASS.Priest] or false)
		addfilterFrame.classesCheckBoxRogue:SetValue(class[CLASS.Rogue] or false)
		addfilterFrame.classesCheckBoxShaman:SetValue(class[CLASS.Shaman] or false)
		addfilterFrame.classesCheckBoxWarlock:SetValue(class[CLASS.Warlock] or false)
		addfilterFrame.classesCheckBoxWarrior:SetValue(class[CLASS.Warrior] or false)
		--@end-non-retail@]===]
	end
	
	
	if not raceFilter then 
		addfilterFrame.rasesCheckBoxIgnore:SetValue(true)
	else
		addfilterFrame.rasesCheckBoxIgnore:SetValue(false)
		for i=1, #addfilterFrame.rasesCheckBoxRace do
			local race = addfilterFrame.rasesCheckBoxRace[i]
			local name = race:GetLabel()
			race:SetValue(raceFilter[name] and true or false)
		end
	end
	
	addfilterFrame.filterNameEdit:SetText(id)
	addfilterFrame.filterNameEdit:SetDisabled(true)
	addfilterFrame.excludeNameEditBox:SetText(filter.filterByName or "")
	addfilterFrame.lvlRangeEditBox:SetText(filter.lvlRange or "")
	addfilterFrame.excludeRepeatEditBox:SetText(filter.letterFilter or "")
	
	fn:classIgnoredToggle()
	fn:racesIgnoredToggle()
	addfilterFrame.change = true
end

function fn.fontSize(frame, font, size)
	font = font or settings.Font
	size = size or settings.FontSize
	frame:SetFont(font, size)
end



function fn:parseBL(str)
	local name, reason
	str = str:gsub("blacklist", '')
	if str:find('-') then
		name,reason = str:match("([^%s-]+)[%s-]+([^-]+)")
	else
		name = str:match("([^-%s]+)")
		reason = false
	end
	return name, reason
end

function fn:pairsByKeys(t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, f)
	local i = 0      -- iterator variable
	local iter = function ()   -- iterator function
		i = i + 1
		if a[i] == nil then return nil
			else return a[i], t[a[i]]
		end
	end
	return iter
end


local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_SYSTEM")
frame:SetScript("OnEvent", function(_,_,msg)
	local place = strfind(ERR_GUILD_JOIN_S,"%s",1,true)
	if (place) then
		local n = strsub(msg,place)
		local name = strsub(n,1,(strfind(n,"%s") or 2)-1)
		if format(ERR_GUILD_JOIN_S,name) == msg then
			if DB.realm.alreadySended[name] then
				addon.searchInfo.invited()
			end
		end
	end
end)

function fn:initDB()
	DB = addon.DB
	debugDB = addon.debugDB
end

local function IsInBlacklist(name)
	return DB.realm.blackList[name] and true or false
end

local function guildKick(name)
	StaticPopupDialogs["FGI_BLACKLIST"].add(name)
end

function fn:blacklistKick()
	for i=1, GetNumGuildMembers() do
		local name = GetGuildRosterInfo(i):match("(.*)-")
		if IsInBlacklist(name) then guildKick(name) end
	end
end

function fn:blackListAutoKick()
	if not IsInGuild() then return end
	-- autoKick on entering world
	fn:blacklistKick()
	
	--init autoKick on guild entering
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("CHAT_MSG_SYSTEM")
	frame:SetScript("OnEvent", function(_,_,msg)
		local place = strfind(ERR_GUILD_JOIN_S,"%s",1,true)
		if (place) then
			local n = strsub(msg,place)
			local name = strsub(n,1,(strfind(n,"%s") or 2)-1)
			if format(ERR_GUILD_JOIN_S,name) == msg then
				if IsInBlacklist(name) then guildKick(name) end
			end
		end
	end)
end

function fn:blackList(name, reason)
	DB.realm.blackList[name] = reason or L.defaultReason
	print(format("%s%s|r", color.red, format(L["Игрок %s добавлен в черный список."], name)))
	fn:blacklistKick()
end

function fn:closeBtn(obj)
	obj.text:SetPoint("TOPLEFT", 2, -1)
	obj.text:SetPoint("BOTTOMRIGHT", -2, 1)
end

function fn.debug(...)
	if not addon.debug then return end
	local msg, colored = ...
	if msg == nil or type(msg) == "table" then
		table.insert(debugDB,format("%swrong debug input - msg = %s\n%s",color.red,type(msg),text))
		return
	end
	if colored then msg = format("%s%s|r", colored, msg) end
	table.insert(debugDB,msg)
end
local debug = fn.debug

function fn:SetKeybind(key, keyType)
	local DBkey = addon.DB.global.keyBind
	if key then
		if keyType == "invite" then
			DBkey.invite = key
			SetBindingClick(key, interface.scanFrame.invite.frame:GetName())
		elseif keyType == "nextSearch" then
			DBkey.nextSearch = key
			SetBindingClick(key, interface.scanFrame.pausePlay.frame:GetName())
		end
	else
		DBkey[keyType] = false
	end
	
	interface.settings.KeyBind.content.invite:SetLabel(format(L["Назначить кнопку (%s)"], DBkey.invite or "none"))
	interface.settings.KeyBind.content.invite:SetKey(DBkey.invite)
	interface.settings.KeyBind.content.nextSearch:SetLabel(format(L["Назначить кнопку (%s)"], DBkey.nextSearch or "none"))
	interface.settings.KeyBind.content.nextSearch:SetKey(DBkey.nextSearch)
end

function fn:FiltersInit()
	local parent = interface.settings.filters.content.filtersFrame
	local list = parent.filterList
	for i=1, FGI_FILTERSLIMIT do
		local frame = GUI:Create("FilterButton")
		frame:Hide()
		parent:AddChild(frame)
		
		table.insert(list, frame)
		
	end
end


function fn:FiltersUpdate()
	local list = interface.settings.filters.content.filtersFrame.filterList
	for i=1, FGI_FILTERSLIMIT do
		list[i]:Hide()
	end
	local i = 1
	for name,v in pairs(DB.realm.filtersList) do
		local filter = DB.realm.filtersList[name]
		local frame = list[i]
		frame:Show()
		frame:SetID(name)
		frame:SetText(name)
		local state = filter.filterOn and L["Включен"]:upper() or L["Выключен"]:upper()
		local lvlRange = filter.lvlRange or L["Откл."]
		local filterByName = filter.filterByName or L["Откл."]
		local letterFilterVowels, letterFilterConsonants = filter.letterFilter==false and 0,0 or fn:split(filter.letterFilter, ":")
		local class = ""
		if not filter.classFilter then
			class = L["Откл."]
		else
			for k,v in pairs(filter.classFilter) do class = class..k.."," end
			class = class:sub(1, -2)
		end
		local race = ""
		if not filter.raceFilter then
			race = L["Откл."]
		else
			for k,v in pairs(filter.raceFilter) do race = race..k.."," end
			race = race:sub(1, -2)
		end
		local count = filter.filteredCount
		
		frame:SetTooltip(format(L["filterTooltip"], name, state, filterByName, lvlRange, letterFilterVowels, letterFilterConsonants, class, race, count))
		
		i = i + 1
		
	end
end




function fn:msgMod(msg, name)
	if not msg then return end
	if msg:find("NAME") then
		local guildName, guildRankName, guildRankIndex, realm = GetGuildInfo("player")
		msg = msg:gsub("NAME", name or 'PLAYER_NAME')
	end
	if msg:find("GUILD") then
		local guildName, guildRankName, guildRankIndex, realm = GetGuildInfo("player")
		msg = msg:gsub("GUILD", format("<%s>",guildName or 'GUILD_NAME'))
	end
	return msg
end

function fn.hideWhisper(...)
	local name = select(4,...):match("([^-]*)")
	if addon.removeMsgList[name] then
		--addon.removeMsgList[name] = nil
		return true
	else
		return false, select(3,...)
	end
end

function fn:sendWhisper(msg, name)
	if not msg or not name then return end
	msg = fn:msgMod(msg, name)
	
	if msg ~= nil then
		if DB.realm.sendMSG then
			addon.removeMsgList[name:match("([^-]*)")] = true
		end
		for i=0, msg:len(), 255 do
			SendChatMessage(msg:sub(i+1, i+255), 'WHISPER', GetDefaultLanguage("player"), name)
		end
	else
		print(L["Выберите сообщение"])
	end
end

local function inviteBtnText(text)
	interface.scanFrame.invite:SetText(text)
end

function fn:rememberPlayer(name)
	DB.realm.alreadySended[name] = time({year = date("%Y"), month = date("%m"), day = date("%d")})
	addon.search.tempSendedInvites[name] = nil
	debug(format("Remember: %s",name))
end

function fn:invitePlayer(noInv)
	local list = addon.search.inviteList
	if #list==0 then return end
	if DB.global.inviteType == 2 and not noInv then
		addon.msgQueue[list[1].name] = true
	elseif DB.global.inviteType == 3 and not noInv then
		local msg = DB.realm.messageList[math.random(1, math.max(1,#DB.realm.messageList))]
		debug(format("Send whisper: %s %s",list[1].name, msg))
		fn:sendWhisper(msg, list[1].name)
	end
	if (DB.global.inviteType == 1 or DB.global.inviteType == 2) and not noInv then
		debug(format("Invite: %s",list[1].name))
		GuildInvite(list[1].name)
	end
	if not noInv or DB.rememberAll then
		fn:rememberPlayer(list[1].name)
	end
	C_ChatInfo.SendAddonMessage(FGISYNCH_PREFIX, "REMEMBER|"..list[1].name, "GUILD")
	if not noInv then
		addon.searchInfo.sended()
	end
	table.remove(list, 1)
	inviteBtnText(format(L["Пригласить: %d"], #list))
	
	interface.chooseInvites.player:SetText(#list > 0 and format("%s%s %d %s %s|r", color[list[1].NoLocaleClass:upper()], list[1].name, list[1].lvl, list[1].class, list[1].race) or "")
end

local function SearchOnUpdate()
	interface.scanFrame.progressBar:SetProgress(GetTime())
end

local Searchframe = CreateFrame('Frame')


local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	
end)

local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
frame:SetScript('OnEvent', function()
	C_ChatInfo.SendAddonMessage(FGISYNCH_PREFIX, "LOGIN|GET_FGI_USERS", "GUILD")
end)

local function getSearchDeepLvl(query)
	local l2 = (("%%d+-%%d+ %s\"%s+"):format(L["r-"],addon.ruReg)):gsub("-","%%-")
	local l3 = (("%%d+-%%d+ %s\"%s+%%\" %s"):format(L["r-"],addon.ruReg,L["c-"])):gsub("-","%%-")
	if query:find(l3) then
		return 3
	elseif query:find(l2) then
		return 2
	elseif query:find("%d+%-%d+") then
		return 1
	else
		return false
	end
end

local function searchGetParams(query)
	local class = query:match(("%s%%\"(%s+)%%\""):format(L["c-"],addon.ruReg):gsub("-","%%-"))
	local race = query:match(("%s%%\"(%s+)%%\""):format(L["r-"],addon.ruReg):gsub("-","%%-"))
	local lvl = {}
	for s in query:gmatch("%d+") do
		table.insert(lvl, s)
	end
	
	return {class = class,race = race, min = lvl[1], max = lvl[2]}
end

local function isQueryFiltered(query)
	if DB.realm.filtersList == {} or not DB.realm.enableFilters then return false end
	local filter = {}
	local q = searchGetParams(query)
	q.min = tonumber(q.min)
	q.max = tonumber(q.max)
	for fName,v in pairs(DB.realm.filtersList) do
		local lvl = {}
		if v.filterOn then
			filter[fName] = {min = false, max = false, --[[race = false,class = false,]]}
			if v.lvlRange then
				for s in v.lvlRange:gmatch("%d+") do
					table.insert(lvl, tonumber(s))
				end
				filter[fName].min, filter[fName].max = lvl[1], lvl[2] or lvl[1]
			end
			if v.raceFilter then filter[fName].race = v.raceFilter[q.race] and q.race or false end
			if v.classFilter then filter[fName].class = v.classFilter[q.class] and q.class or false end
		end
	end
	for fName,f in pairs(filter) do
		local sLevel = getSearchDeepLvl(query)
		local lvlFiltered, raceFiltered, classFiltered = (f.min and (f.min <= q.min and f.max >= q.max)), (f.race and (f.race==q.race)), (f.class and (f.class==q.class))
		local queryFiltered = false
		if sLevel == 1 then
			queryFiltered = lvlFiltered and f.race==nil and f.class==nil
		elseif sLevel == 2 then
			queryFiltered = f.class==nil and ((lvlFiltered and raceFiltered) or (not f.min and raceFiltered)) or (lvlFiltered and f.race==nil and f.class==nil)
		elseif sLevel == 3 then
			queryFiltered = (lvlFiltered and (f.race==nil and f.class==nil) or (raceFiltered and f.class==nil) or (f.race==nil and classFiltered) or (raceFiltered and classFiltered)) or (not f.min and (raceFiltered and f.class==nil) or (f.race==nil and classFiltered))
		else
			debug('wrong search Level', color.red)
		end
		if queryFiltered then debug(string.format('query (%s) filtered by filter (%s)', query, fName), color.blue);return true end
	end
	return false
end

local function searchAddWhoList(query, lvl)
	local progress = addon.search.progress-1
	local tAddN =0
	local function LVLsplit(query)
		local v1 = query:gsub("(%d+)%-(%d+)", function(a,b)
			local dif = b-a
			b = b - math.floor(dif/2)-1
			tAddN = tAddN+1
			return a.."-"..b
		end)
		local v2 = query:gsub("(%d+)%-(%d+)", function(a,b)
			local dif = b-a
			a = a + math.ceil(dif/2)
			tAddN = tAddN+1
			return a.."-"..b
		end)
		table.remove(addon.search.whoQueryList, progress)
		
		
		if isQueryFiltered(v1) then
			tAddN = tAddN-1
		else
			debug(format("Add new lvl query: (%s); Query: %s", v1, query))
			table.insert(addon.search.whoQueryList, progress, v1)
		end
		if isQueryFiltered(v2) then
			tAddN = tAddN-1
		else
			debug(format("Add new lvl query: (%s); Query: %s", v2, query))
			table.insert(addon.search.whoQueryList, progress+1-(2-tAddN), v2)
		end
		
		
		
		local min, max = interface.scanFrame.progressBar:GetMinMax()
		-- interface.scanFrame.progressBar:SetMinMax(min, max+tAddN*FGI_SCANINTERVALTIME)
		addon.search.progress = addon.search.progress - 1
	end
	local function RACEsplit(query)
		local new = 0
		table.remove(addon.search.whoQueryList, progress)
		for _,v in pairs(L.race) do
			local newQuery = format("%s %s\"%s\"",query,L["r-"],v)
			if not isQueryFiltered(newQuery) then
				table.insert(addon.search.whoQueryList, progress+new, newQuery)
				new = new + 1
			end
		end
		if new==0 then return table.insert(addon.search.whoQueryList, progress, query) end
		debug(format("Add new race queries: %d; Query: %s", new, query))
		local min, max = interface.scanFrame.progressBar:GetMinMax()
		-- interface.scanFrame.progressBar:SetMinMax(min, max+(new)*FGI_SCANINTERVALTIME)
		addon.search.progress = addon.search.progress - 1
	end
	local function CLASSsplit(query, race)
		local new = 0
		table.remove(addon.search.whoQueryList, progress)
		if race then
			for k,v in pairs(L.race) do
				if v==race then
					race = k
					break
				end
			end
			
			if not RaceClassCombo[race] then return print("FGI Error race -",race) end
		else
			return table.insert(addon.search.whoQueryList, progress, query)
		end
		for k,v in pairs(RaceClassCombo[race]) do
			local newQuery = format("%s %s\"%s\"",query,L["c-"],v)
			if not isQueryFiltered(newQuery) then
				table.insert(addon.search.whoQueryList, progress+new, newQuery)
				new = new + 1
			end
		end
		if #RaceClassCombo[race]==0 then return table.insert(addon.search.whoQueryList, progress, query) end
		debug(format("Add new class queries: %d; Query: %s", #RaceClassCombo[race], query))
		local min, max = interface.scanFrame.progressBar:GetMinMax()
		-- interface.scanFrame.progressBar:SetMinMax(min, max+(new)*FGI_SCANINTERVALTIME)
		addon.search.progress = addon.search.progress - 1
	end
	local queryParams = searchGetParams(query, lvl)
	local difference = (queryParams.max - queryParams.min) > 0
	if difference then
		LVLsplit(query)
	elseif lvl == 1 then
		RACEsplit(query)
	elseif lvl == 2 then
		CLASSsplit(query, queryParams.race)
	end
end

local function findClass(className)
	for k,v in pairs(L.femaleClass) do
		if v==className then return L.class[k]  end
	end
	return false
end

local function findRace(raceName)
	for k,v in pairs(L.femaleRace) do
		if v==raceName then return L.race[k] end
	end
	return false
end

local function filtered(player)
	for k,v in pairs(DB.realm.filtersList) do
		if v.filterOn then
			if v.lvlRange then
				local min, max = fn:split(v.lvlRange, ":", -1)
				if player.Level >= min and player.Level <= max then
					v.filteredCount = v.filteredCount + 1
					fn:FiltersUpdate()
					return true--,"lvl"
				end
			end
			if v.filterByName then
				for k in v.filterByName:gmatch("([^;]+)") do
					if player.Name:find(k) then
						v.filteredCount = v.filteredCount + 1
						fn:FiltersUpdate()
						return true--,"name"
					end
				end
			end
			--[[if v.letterFilter then
				
			end]]
			if v.classFilter then
				if v.classFilter[player.Class] or v.classFilter[findClass(player.Class)] then
					v.filteredCount = v.filteredCount + 1
					fn:FiltersUpdate()
					return true--,"class"
				end
			end
			if v.raceFilter then
				if v.raceFilter[player.Race] or v.raceFilter[findRace(player.Race)] then
					v.filteredCount = v.filteredCount + 1
					fn:FiltersUpdate()
					return true--,"race"
				end
			end
			
		end
	end
	return false
end

local function addNewPlayer(t, p)
	local blackList = DB.realm.blackList[p.Name] and true or false
	local playerInfoStr = format("%s - lvl:%d; race:%s; class:%s; Guild: \"%s\"", p.Name, p.Level, p.Race, p.Class, p.Guild)
	if p.Guild == "" then
		if not blackList then
			if not DB.realm.leave[p.Name] then
				if not t.tempSendedInvites[p.Name] then
					if not DB.realm.alreadySended[p.Name] then
						if ((DB.realm.enableFilters and not filtered(p)) or not DB.realm.enableFilters) then
							table.insert(t.inviteList, {name = p.Name, lvl = p.Level, race = p.Race, class = p.Class,  NoLocaleClass = p.NoLocaleClass})
							t.tempSendedInvites[p.Name] = true
							debug(format("Add player %s", playerInfoStr), color.green)
						else
							addon.searchInfo.filtered()
							debug(format("Player (%s) has been fitlered", playerInfoStr), color.yellow)
						end
						addon.searchInfo.unique()
					else
						debug(format("Invitation has already been sent to the player %s", playerInfoStr), color.yellow)
					end
				else
					debug(format("Player (%s) alrady added", playerInfoStr), color.yellow)
				end
			else
				debug(format("Player (%s) previously exited (or was expelled) from the guild.", playerInfoStr), color.red)
			end
		else
			debug(format("Player (%s) was found in the blacklist.", playerInfoStr), color.red)
		end
	else
		debug(format("Player (%s) already have guild.", playerInfoStr), color.yellow)
	end
	local list = t.inviteList
	interface.chooseInvites.player:SetText(#list > 0 and format("%s%s %d %s %s|r", color[list[1].NoLocaleClass:upper()], list[1].name, list[1].lvl, list[1].class, list[1].race) or "")
end

local libWho = {whoQuery='', doHide=false, isFGI=false}
local function GetWho(query)
	libWho.isFGI = true
	libWho.whoQuery = query
	-- FriendsTabHeader	GuildFrame	RaidFrame
	libWho.doHide = (not WhoFrame:IsShown()) and (not FriendsFrame:IsShown())
	C_FriendList.SetWhoToUi(true)
	C_FriendList.SendWho(query)
	WhoFrameEditBox:SetText(query)
end

local function searchWhoResultCallback(query, results)
	local searchLvl = getSearchDeepLvl(query)
	if #results >= FGI_MAXWHORETURN and DB.realm.customWho then
		print(format(L["Поиск вернул 50 или более результатов, рекомендуется изменить настройки поиска. Запрос: %s"], query))
		debug(format("Query (%s) return 50 or more results; SearchLevel-%d", query, searchLvl))
	end
	addon.search.progress = addon.search.progress + 1
	debug(format("Query %s", query))
	if searchLvl == 1 and #results>=FGI_MAXWHORETURN then
		searchAddWhoList(query,1)
	elseif searchLvl == 2 and #results>=FGI_MAXWHORETURN then
		searchAddWhoList(query,2)
	-- 3lvl can't modified
	end
	
	for i=1,#results do
		local player = results[i]
		addNewPlayer(addon.search, player)
	end
	interface.scanFrame.progressBar:SetMinMax(0, #addon.search.whoQueryList)
	interface.scanFrame.progressBar:SetProgress(addon.search.progress-1)
	inviteBtnText(format(L["Пригласить: %d"], #addon.search.inviteList))
end

function fn:nextSearch()
	C_Timer.After(FGI_SCANINTERVALTIME, function() interface.scanFrame.pausePlay:SetDisabled(false) end)
	if #addon.search.whoQueryList == 0 then
		if  DB.realm.customWho then
			for i=1, #DB.faction.customWhoList do
				table.insert(addon.search.whoQueryList, DB.faction.customWhoList[i])
			end
		else
		addon.search.whoQueryList = {DB.global.lowLimit.."-"..DB.global.highLimit}
		end
	end
	
	
	addon.search.progress = (addon.search.progress <= (#addon.search.whoQueryList or 1)) and addon.search.progress or 1
	local curQuery = addon.search.whoQueryList[addon.search.progress]
	GetWho(curQuery)
end

local function returnWho(result)
	searchWhoResultCallback(libWho.whoQuery, result)
end

local whoFrame = CreateFrame('Frame')
whoFrame:RegisterEvent("WHO_LIST_UPDATE")
whoFrame:SetScript("OnEvent", function()
	if not libWho.isFGI then return end
	if libWho.doHide then
		-- FriendsFrame:Hide()
		FriendsFrameCloseButton:Click()
	end
	libWho.isFGI = false
	local result = {}

	local total, num = C_FriendList.GetNumWhoResults()
	for i=1, num do
	--	self.Result[i] = C_FriendList.GetWhoInfo(i)
		local info = C_FriendList.GetWhoInfo(i)
		--backwards compatibility START
		info.Name=info.fullName
		info.Guild=info.fullGuildName
		info.Level=info.level
		info.Race=info.raceStr
		info.Class=info.classStr
		info.Zone=info.area
		info.NoLocaleClass=info.filename
		info.Sex=info.gender
		--backwards compatibility END
		result[i] = info
	end
	
	C_FriendList.SetWhoToUi(false)
	returnWho(result)
end)

function dump(t,l)
  local str = '{'
  l = l or 1
  if l>100 then return 'overstack' end
  for k,v in pairs(t) do
    str = str.."\n"..string.rep('   ', l)..'['..(type(k)=='string' and "'"..k.."'" or k).."] = "
    if type(v) == 'table' then
        str = str..dump(v,l+1)
    elseif type(v) == 'function' then
        str = str..'function'
    elseif type(v) == 'string' then
        str = str.."'"..v.."'"
    else
        str = str..tostring(v)
    end
  end
  str = str..'\n'..string.rep('   ', l-1)..'},'
  if l==1 then
    print(str)
  else
    return str
  end
end

math.progress = function(End, cur)
  local percentageDone = cur*100/End
  return percentageDone>100 and 100 or percentageDone
end

math.round = function (val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end

table.pack = function(...)
    return { ... }
end

function fn:split(inputstr, sep, isNumber)
	isNumber = isNumber or false
	if sep == nil then sep = "%s" end
	if not inputstr:find(sep) then return inputstr end
	local t={}
	for str in inputstr:gmatch("([^"..sep.."]+)") do
		table.insert(t, (tonumber(str)==nil and not isNumber) and str or (tonumber(str) or isNumber))
	end
	return unpack(t)
end

function fn:inGuildCanInvite()
	if not addon.debug then
		if not IsInGuild() then return false end
		if not CanGuildInvite() then return false end
	end
	
	return true	
end

function fn.hideSysMsg()
	return true
end


--[[----------------------------------------------------------------------------------------------
									Synch
]]------------------------------------------------------------------------------------------------
FGI.ReceiveSynchStr = {[L["Все"]] = {}}
ReceiveSynchStr = FGI.ReceiveSynchStr
local writeReceiveData = {
	blacklist = function(arr)
		for i=1, #arr do
			local name, reason = arr[i][1], arr[i][2]
			if not DB.realm.blackList[name] then
				interface.blackList:add({name=name, reason=reason})
			end
			DB.realm.blackList[name] = reason
		end
		interface.blackList:update()
	end,
	invitations = function(arr)
		for i=1, #arr do
			local name, time = arr[i][1], tonumber(arr[i][2])
			DB.realm.alreadySended[name] = math.max(time, DB.realm.alreadySended[name] or 0)
		end
	end,
}

local function readSynchStr(sender, mod)
--print(str)
	local str = ReceiveSynchStr[sender][mod]
	local arr = {}
	for S in str:gmatch("(.-);") do
		local n, r = S:match("([^,]+),(.+)")
		r = r:gsub("~", ',')
		table.insert(arr, {n,r})
	end
	
	if writeReceiveData[mod] then
		writeReceiveData[mod](arr)
	else
		print(color.red.."writeReceiveData WRONG MOD|r")
	end
	ReceiveSynchStr[sender][mod] = nil
end


local function getSynchRequest(requestMSG, sender, allowed)
	local function confirm()
		getSynchRequest(requestMSG, sender, true)
	end
	local request = L.synchType[requestMSG]
	local requestType = L.synchBaseType[requestMSG]
	if not requestType then
		return C_ChatInfo.SendAddonMessage(FGISYNCH_PREFIX, 'ERROR|'..L["Ошибка типа синхронизации"], "WHISPER", sender)
	end
	if not allowed then
		if DB.global.security.sended and requestType == 'invitations' then
			confirmSending:NewConfirm(confirm, sender, request)
		elseif DB.global.security.blacklist and requestType == 'blacklist' then
			confirmSending:NewConfirm(confirm, sender, request)
		end
		return
	end
	C_ChatInfo.SendAddonMessage(FGISYNCH_PREFIX, 'SUCCESS|'..L["Начало синхронизации"], "WHISPER", sender)
	
	local SendSynchStr = ''
	if requestType=='blacklist' then
		for k,v in pairs(DB.realm.blackList) do
			SendSynchStr = string.format("%s%s,%s;", SendSynchStr, k, tostring(v):gsub(',','~'))
		end
	elseif requestType=='invitations' then
		for k,v in pairs(DB.realm.alreadySended) do
			SendSynchStr = string.format("%s%s,%s;", SendSynchStr, k, tostring(v))
		end
	end
	if SendSynchStr=='' then return end
	fn.SendSynchArray(SendSynchStr, requestType, sender)
	return
end

local synchFrame = CreateFrame("Frame")
synchFrame:RegisterEvent("CHAT_MSG_ADDON")
synchFrame:SetScript("OnEvent", function(self, event, ...)
	local prefix, msg, channel, sender = ...
	msg = tostring(msg)
	if prefix ~= FGISYNCH_PREFIX then return end
	-- print(prefix, msg, channel, sender)
	sender = sender:match("([^-]+)")
	if sender == UnitName('player') then return end
	local synch = interface.settings.Synchronization.content
	local requestType, requestMSG = msg:match("([^|]+)[|]*([^|]+)")
	requestMSG = tonumber(requestMSG) == nil and requestMSG or tonumber(requestMSG)
	
	if channel == "WHISPER" then
		if requestType == "ERROR" then
			synch.ticker:responseReceived()
			return synch.infoLabel:Error(requestMSG)
		elseif requestType == "SUCCESS" then
			synch.ticker:responseReceived()
			return synch.infoLabel:Success(requestMSG)
		elseif requestType == "GET" then
			return getSynchRequest(requestMSG, sender)
		elseif requestType == "LOGIN" and requestMSG == "GET_FGI_USERS" then
			return synch.rightColumn.synchPlayerReadyDrop:AddItem(sender, sender)
		end
		if synch.timer then synch.timer:Cancel() end
		
		local Start, End = msg:find("%(.+%)")
		End = End or 0
		local s,e,mod = msg:sub(Start, End):match("(%d+)[^%d](%d+);(%w+)")
		if not mod then return end
		s, e = tonumber(s), tonumber(e)
		synch.infoLabel:Success(format(L[ [=[Синхронизация с %s.
%d/%d]=] ], sender,s,e))
		if s == 1 then ReceiveSynchStr[sender] = { [mod] = ''} end
			msg = msg:sub(End+1, -1)
			ReceiveSynchStr[sender][mod] = ReceiveSynchStr[sender][mod]..msg
		if s == e then
			readSynchStr(sender, mod)
			synch.infoLabel:Success(format(L["Данные синхронизированы с игроком %s."], sender))
		end
		
	elseif channel == "GUILD" then
		if requestType == "GET" then
			getSynchRequest(requestMSG, sender)
		elseif requestType == "LOGIN" and requestMSG == "GET_FGI_USERS" then
			synch.rightColumn.synchPlayerReadyDrop:AddItem(sender, sender)
			C_ChatInfo.SendAddonMessage(FGISYNCH_PREFIX, "LOGIN|GET_FGI_USERS", "WHISPER", sender)
		elseif requestType == "REMEMBER"then
			fn:rememberPlayer(requestMSG)
		end
	end
end)


function fn.SendSynchArray(str, mod, playerName)
	local arr = {}
	local i = 0
	local step = 250-15-mod:len()-1
	repeat 
		table.insert(arr, string.format("(%d/%%d;%s)%s", #arr+1, mod or '', str:sub(i+1,i+step)))
		i=i+step
	until i>=str:len()
	
	local max = #arr
	C_Timer.NewTicker(0.05, function()
	-- for i=1, #arr do
		if not arr[1] then return end
		C_ChatInfo.SendAddonMessage(FGISYNCH_PREFIX, string.format(arr[1],max), "WHISPER", playerName)
		table.remove(arr,1)
	-- end
	end, max)

	return arr
end

function fn:sendSynchRequest(player, sType)
	local synch = interface.settings.Synchronization.content
	ReceiveSynchStr[player] = ReceiveSynchStr[player] or {}
	ReceiveSynchStr[player].start = GetTime()
	local start = GetTime()
	synch.ticker = C_Timer.NewTicker(1,function()
		local time = math.ceil(start+FGI_MAXSYNCHWAIT-GetTime())
		synch.infoLabel:During(format(L["Запрос синхронизации у: %s. %d"], player or L["Все"], time))
		if time == 0 then return synch.infoLabel:Error(L["Превышен лимит ожидания ответа"]) end
	end, FGI_MAXSYNCHWAIT)
	function synch.ticker:responseReceived()
		synch.ticker:Cancel()
		synch.timer = C_Timer.NewTimer(FGI_MAXSYNCHWAIT, function()
			synch.infoLabel:Error(L["Превышен лимит ожидания ответа"])
		end)
	end
	if player == L["Все"] then
		C_ChatInfo.SendAddonMessage(FGISYNCH_PREFIX, "GET||"..sType, "GUILD")
	else
		C_ChatInfo.SendAddonMessage(FGISYNCH_PREFIX, "GET||"..sType, "WHISPER", player)
	end
end