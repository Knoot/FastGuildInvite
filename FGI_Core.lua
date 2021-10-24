local addon = FGI
local fn = addon.functions
local L = FGI:GetLocale()
local interface = addon.interface
local Console = LibStub("AceConsole-3.0")
local GUI = LibStub("AceGUI-3.0")
local FastGuildInvite = addon.lib
local DB = addon.DB
local debugDB = addon.debugDB
addon.icon = LibStub("LibDBIcon-1.0")
local icon = addon.icon
local color = addon.color
local debug = fn.debug
local Analytic = addon.lib.WagoAnalytics

addon.dataBroker = LibStub("LibDataBroker-1.1"):NewDataObject("FGI",
	{type = "launcher", label = "FGI", icon = "Interface\\AddOns\\FastGuildInvite\\img\\minimap\\MiniMapButton"}
)
local function mainFrameToggle()
	local mf = interface.mainFrame
	if mf.frame:IsShown() then
		mf:Hide()
	else
		mf:Show()
	end
end

function addon.dataBroker.OnClick(self, button)
	local shift = IsShiftKeyDown()
	if button == "LeftButton" and not shift then
		interface.scanFrame.invite.frame:Click()
	elseif button == "LeftButton" and shift then
		interface.scanFrame.pausePlay.frame:Click()
	elseif button == "RightButton" then
		mainFrameToggle()
	end
end

local function CanInteraction(name, server, unit)
	if unit and not UnitIsPlayer(unit) then return false end
	if name then
		local canInvited = true
		if server ~= nil then
			canInvited = false
			for i=1,#addon.autoCompleteRealms do
				if addon.autoCompleteRealms[i] == server then
					canInvited = true
					name = format("%s-%s",name,server)
					break;
				end
			end
		end

		return canInvited
	end
	return false
end

local supportedTypes = {
	-- SELF = 1, -- do we really need this? can always target self anywhere else and copy our own url
	PARTY = 1,
	PLAYER = 1,
	RAID_PLAYER = 1,
	RAID = 1,
	FRIEND = 1,
	-- BN_FRIEND = 1,
	GUILD = 1,
	GUILD_OFFLINE = 1,
	CHAT_ROSTER = 1,
	TARGET = 1,
	ARENAENEMY = 1,
	FOCUS = 1,
	WORLD_STATE_SCORE = 1,
	COMMUNITIES_WOW_MEMBER = 1,
	COMMUNITIES_GUILD_MEMBER = 1,
}
local function HandlesGlobalMouseEvent(self, button, event)
	if event == "GLOBAL_MOUSE_DOWN" and (button == "LeftButton" or button == "RightButton")then
		return true
	end
	return false
end

addon.MENU = GUI:Create("SimpleGroup")
local f = addon.MENU
f:SetWidth(135)
f:SetHeight(63)
f:SetLayout("NIL")

local invite = GUI:Create('Button')
invite:SetText('FGI - Guild Invite')
invite:SetWidth(135)
invite:SetHeight(20)
invite.frame.HandlesGlobalMouseEvent = HandlesGlobalMouseEvent
invite:SetCallback('OnClick', function()
	local name = f.name
	GuildInvite(name)
	fn:rememberPlayer(name)
	CloseDropDownMenus()
end)
invite:SetPoint("TOPLEFT", f.frame, "TOPLEFT", 0, 0)
f:AddChild(invite)

local blacklist = GUI:Create('Button')
blacklist:SetText('FGI - Black List')
blacklist:SetWidth(135)
blacklist:SetHeight(20)
blacklist.frame.HandlesGlobalMouseEvent = HandlesGlobalMouseEvent
blacklist:SetCallback('OnClick', function()
	local name = f.name
	fn:blackList(name)
	interface.settings.Blacklist.content:update()
	if not DB.global.fastBlacklist then
		StaticPopup_Show("FGI_BLACKLIST_CHANGE", _,_,  {name = name})
	end
	CloseDropDownMenus()
end)
blacklist:SetPoint("TOPLEFT", invite.frame, "BOTTOMLEFT", 0, 0)
f:AddChild(blacklist)

local unblacklist = GUI:Create('Button')
unblacklist:SetText('FGI - Unblacklist')
unblacklist:SetWidth(135)
unblacklist:SetHeight(20)
unblacklist.frame.HandlesGlobalMouseEvent = HandlesGlobalMouseEvent
unblacklist:SetCallback('OnClick', function()
	local name = f.name
	fn:unblacklist(name)
	interface.settings.Blacklist.content:update()
	CloseDropDownMenus()
end)
unblacklist:SetPoint("TOPLEFT", blacklist.frame, "BOTTOMLEFT", 0, 0)
f:AddChild(unblacklist)

local function DropDownOnShow(self)
	local dropdown = self.dropdown
	if not dropdown then
		return
	end

	f.frame:SetParent(self)
	f.frame:SetFrameStrata(self:GetFrameStrata())
	f.frame:SetFrameLevel(self:GetFrameLevel() + 2)
	f:ClearAllPoints()

	if dropdown.Button == LFGListFrameDropDownButton then -- LFD
		-- ShowCustomDropDown(self, dropdown, dropdown.menuList[2].arg1)
	elseif dropdown.which and supportedTypes[dropdown.which] then -- UnitPopup
		local dropdownFullName
		if dropdown.name then
			if dropdown.server and not dropdown.name:find("-") then
				dropdownFullName = dropdown.name .. "-" .. dropdown.server
			else
				dropdownFullName = dropdown.name
			end
		end
		if not CanInteraction(dropdownFullName, dropdown.server, dropdown.unit) then return end
		f.name = dropdownFullName
	else
		return
	end

	if self:GetLeft() >= self:GetWidth() then
		f:SetPoint("TOPRIGHT", self, "TOPLEFT",0,0)
	else
		f:SetPoint("TOPLEFT", self, "TOPRIGHT",0,0)
	end
	f.frame:Show()
end
local function DropDownOnHide()
	f.frame:Hide()
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_SYSTEM")
frame:SetScript("OnEvent", function(...)
	local _,_, msg = ...
	local place = strfind(ERR_GUILD_LEAVE_S ,"%s",1,true)
	if (place) then
		local n = strsub(msg,place)
		local name = strsub(n,1,(strfind(n,"%s") or 2)-1)
		if format(ERR_GUILD_LEAVE_S ,name) == msg then
			DB.realm.leave[name] = true
			debug(format("Player %s left the guild or was expelled.", name), color.yellow)
			fn.updateTableForSync('leave', {name = name, time = true})
			fn.history:onLeave();
		end
	end
end)

local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_OFFICER")
frame:SetScript("OnEvent", function(_,_, msg,_,_,_,name,...)
	local function isCorrect(str)
		local n,r = str:match("([^-%s]+)[%s]*-[%s]*([^-]+)")
		if n==nil then
			n = msg
		end
		-- if n==nil then return false end
		return true, n, r
	end

	if name == UnitName("Player") then print("player -> exit")end
	if not msg:find("^!") then return end
	if msg:find("^!fgi") then
		SendChatMessage(" "..L.blacklistAdd , "OFFICER",  GetDefaultLanguage())
		SendChatMessage(" "..L.blacklistDelete , "OFFICER",  GetDefaultLanguage())
		SendChatMessage(" "..L.blacklistGetList , "OFFICER",  GetDefaultLanguage())
	elseif msg:find("^!blacklistAdd") then
		msg = msg:gsub("!blacklistAdd ", '')
		local b,n,r = isCorrect(msg)
		if r==nil then return end
		-- fn:blackList(name)
		-- interface.settings.Blacklist.content:update()
		print("test add",b,n,r)
	elseif msg:find("^!blacklistDelete") then
		msg = msg:gsub("!blacklistDelete ", '')
		local b,n,r = isCorrect(msg)
		-- fn:unblacklist(name)
		-- interface.settings.Blacklist.content:update()
		print("test delete",b,n,r)
	elseif msg:find("^!blacklistGetList") then
		for k,v in pairs(DB.realm.blackList) do
			SendChatMessage(format("%s - %s", k, v) , "OFFICER",  GetDefaultLanguage())
		end
	end
end)




function addon.dataBroker.OnTooltipShow(GameTooltip)
	local search = addon.search
	GameTooltip:SetText(format(L.minimap,#search.inviteList, interface.scanFrame.progressBar:GetProgress()), 1, 1, 1)
end


function FastGuildInvite:OnEnable()
	if DB.global.createMenuButtons then
		DropDownList1:HookScript("OnShow", DropDownOnShow)
		DropDownList1:HookScript("OnHide", DropDownOnHide)
	end

	addon.debug = DB.global.debug
	fn:blackListAutoKick()
	local parent = interface.settings.filters.content.filtersFrame
	local list = parent.filterList
	fn:FiltersInit()
	C_Timer.After(0.1, function()
	for i=1, #list do
		local frame = list[i]
		frame:ClearAllPoints()
		if i == 1 then
			frame:SetPoint("TOPLEFT", parent.frame, "TOPLEFT", 15, -50)
		else
			if mod(i-1,7) == 0 then
				frame:SetPoint("TOP", list[7*math.floor(i/7)+1-7].frame, "BOTTOM", 0, -10)
			else
				frame:SetPoint("LEFT", list[i-1].frame, "RIGHT", 5, 0)
			end
		end
	end
	end)
	fn:FiltersUpdate()

	fn:SetKeybind(DB.global.keyBind.invite, "invite")
	fn:SetKeybind(DB.global.keyBind.nextSearch, "nextSearch")

	interface.debugFrame:ClearAllPoints()
	interface.debugFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)

	Console:RegisterChatCommand('fgi', 'FGIInput')
	Console:RegisterChatCommand('FastGuildInvite', 'FGIInput')
	Console:RegisterChatCommand('fgibl', 'FGIAddBlackList')
	Console:RegisterChatCommand('fgidebug', 'FGIdebug')

	Analytic:Switch('enable filters', DB.realm.enableFilters or false)
	Analytic:Switch('custom who', DB.realm.customWho or false)
	Analytic:SetCounter('invite type', DB.global.inviteType or 1)
	Analytic:Switch('use keybinds', DB.global.keyBind.invite or DB.global.keyBind.nextSearch or false)
	Analytic:SetCounter('clear DB period', DB.global.clearDBtimes)
	Analytic:Switch('minimap', not DB.global.minimap.hide)
	Analytic:Switch('debug mode', DB.global.debug or false)
	Analytic:Switch('blacklist in officer chat', DB.global.blacklistOfficer)
	Analytic:Switch('remember all', DB.global.rememberAll or false)
	Analytic:Switch('queue notify', DB.global.queueNotify)
	Analytic:Switch('search alert notify', DB.global.searchAlertNotify)
	Analytic:Switch('show addon submenu', DB.global.createMenuButtons)
	Analytic:Switch('set note', DB.global.setNote or false)
	Analytic:Switch('set officer note', DB.global.setOfficerNote or false)
	Analytic:Switch('confirm search clear', DB.global.confirmSearchClear)
	Analytic:Switch('fast blacklist', DB.global.fastBlacklist or false)
	Analytic:Switch('intro show', DB.global.introShow)
	Analytic:Switch('save search', DB.global.saveSearch)
	Analytic:Switch('quiet zones', DB.global.quietZones)

	DB.factionrealm.guild = GetGuildInfo('player') or DB.factionrealm.guild
end

local guildUpdate = CreateFrame('Frame')
guildUpdate:RegisterEvent('PLAYER_GUILD_UPDATE')
guildUpdate:SetScript('onEvent', function(...)
	if GetGuildInfo('player') ~= nil and DB.factionrealm.guild ~= GetGuildInfo('player') then
		print(format('|cff00ff00<FGI>|r \nLastGuild: %s \nNewGuild: %s \nClearing the list of those who left the guild \nClearing the list of sent invitations\n Now the data has not been deleted, this is just a test message',
			DB.factionrealm.guild,
			GetGuildInfo('player')
		))
		DB.factionrealm.guild = GetGuildInfo('player')
		-- clear data
		-- DB.realm.alreadySended = {}
		-- DB.realm.leave = {}
	end
end)


local defaultSettings =  {
	profile = {
	},
	realm = {
		enableFilters = false,
		customWho = false,
		strictCustom = false,
		addonMSG = false,
		systemMSG = false,
		sendMSG = false,
		filtersList = {},
		blackList = {},
		alreadySended = {},
		leave = {},
	},
	faction = {
		customWhoList = {"1-15 c-\"Class\" r-\"Race\""},
	},
	factionrealm  = {
		curMessage = 1,
		messageList = {},
		history = {
			search = {},
			found = {},
			send = {},
			accept = {},
			decline = {},
			autodecline = {},
			leave = {},
			joined = {},
		},
		guild = nil,
		locations = {},
	},
	global = {
		inviteType = 1,
		lowLimit = FGI_MINLVL,
		highLimit = FGI_MAXLVL,
		keyBind = {invite = false, nextSearch = false},
		clearDBtimes = 3,
		minimap = {hide = false},
		debug = false,
		security = {blacklist = true, sended = true}, --TODO remove? new sync
		addonMSG = false,
		blacklistOfficer = true,
		rememberAll = false,
		queueNotify = true,
		searchAlertNotify = true,
		createMenuButtons = true,
		setNote = false,
		noteText = "",
		setOfficerNote = false,
		officerNoteText = "",
		confirmSearchClear = true,
		fastBlacklist = false,
		introShow = true,
		saveSearch = true,
		logs = {
			on = false,
		},
		scanFrameChilds = {
			title = true,
			player = true,
			progress = true,
			buttons = true,
		},
		statistic = {
			send = true,
			decline = true,
			autodecline = false,
			accept = true,
			search = false,
			found = false,
			leave = true
		},
		quietZones = true,
	},
}


function FastGuildInvite:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("FGI_DB", defaultSettings, true)
	self.debugdb = LibStub("AceDB-3.0"):New("FGI_DEBUG")
	self.db.RegisterCallback(self, "OnDatabaseReset", function() C_UI.Reload() end)

	DB = self.db
	addon.DB = DB
	debugDB = self.debugdb.global
	for i=#debugDB, 1, -1  do
		if not debugDB[i][1] then table.remove(debugDB,i)end
	end
	table.insert(debugDB, {})
	addon.debugDB = debugDB[#debugDB]

	-- for DB update
	if DB.realm.messageList then
		DB.factionrealm.messageList = DB.realm.messageList
		DB.realm.messageList = nil
	end
	-- / for DB update
	if DB.global.clearDBtimes>1 then
		for k,v in pairs(DB.realm.alreadySended) do	-- delete player from sended DB after "FGI_RESETSENDDBTIME"
			if difftime(time({year = date("%Y"), month = date("%m"), day = date("%d")}), v) >= FGI_RESETSENDDBTIME[DB.global.clearDBtimes] then
				DB.realm.alreadySended[k] = nil
			end
		end
	end


	icon:Register("FGI", addon.dataBroker, DB.global.minimap)
	fn:initDB()
end

local function toggleDebug()
	DB.global.debug = not DB.global.debug
	addon.debug = DB.global.debug
	print("FGI Debug "..(DB.global.debug and color.green.."on" or color.red.."off").."|r")
end

function Console:FGIdebug(str)
	if not addon.debug then return end
	if str == '' then return Console:FGIdebugHelp()
	elseif str == 'show' then return interface.debugFrame:Show()
	elseif str == 'load' then
		local text = ''
		for k,v in pairs(addon.debugDB)do
			text = format("%s%s\n",text,v)
		end

		interface.debugFrame.debugList:SetText(text)
		return

	end
end

local function isCorrect(str)
  local n,r = str:match("([^-%s]+)[%s]*-[%s]*([^-]+)")
  if n==nil or r==nil then return false end
  r = (r:len()>2) and r or false
  return (n and r) and true or false, n, r
end

function Console:FGIAddBlackList(str)
	if str == '' then return
	else
		local b, n, r = isCorrect(str)
		if not b then return end
		fn:blackList(n,r)
		interface.blackList:add({name=n,reason=r})
		SendChatMessage(format("%s %s - %s", format(L["Игрок %s добавлен в черный список."], n), L["Причина"], r) , "OFFICER",  GetDefaultLanguage())
	end
end

function Console:FGIdebugHelp()
	if not addon.debug then return end
	print("/fgidebug show - show debug frame")
	print("/fgidebug load - load current debug info")
end

function Console:FGIInput(str)
	if str == '' or str == 'help' then return Console:FGIHelp()
	elseif str == 'help2' then return Console:FGIHelp2()
	elseif str == 'show' then return interface.mainFrame:Show()
	elseif str == 'dump' then return interface.dumpWindow:Show()
	elseif str == "invite" then
		fn:invitePlayer()
	elseif str == "nextSearch" then
		interface.scanFrame.pausePlay.frame:Click()
	elseif str:find("^blacklist") then
		local name,reason = fn:parseBL("blacklist", str)
		if not name then return print('Blacklist: nil name') end
		fn:blackList(name, reason)
		interface.settings.Blacklist.content:update()
		if not reason and not DB.global.fastBlacklist then
			StaticPopup_Show("FGI_BLACKLIST_CHANGE", _,_,  {name = name})
		end
	elseif str:find("^unblacklist") then
		local name = fn:parseBL("unblacklist", str)
		if not name then return print('Unblacklist: nil name') end
		fn:unblacklist(name)
	elseif str == 'debug' then
		toggleDebug()
	elseif str == 'resetDB' then DB.realm.alreadySended = {}
	elseif str == 'resetWindowsPos' then
		interface.mainFrame:ClearAllPoints()
		interface.scanFrame:ClearAllPoints()
		interface.dumpWindow:ClearAllPoints()

		interface.mainFrame:SetPoint("CENTER", UIParent)
		interface.scanFrame:SetPoint("CENTER", UIParent)
		interface.dumpWindow:SetPoint("CENTER", UIParent)

		local point, relativeTo,relativePoint, xOfs, yOfs = interface.mainFrame.frame:GetPoint(1)
		DB.global.mainFrame = {point=point, relativeTo=relativeTo, relativePoint=relativePoint, xOfs=xOfs, yOfs=yOfs,}

		point, relativeTo,relativePoint, xOfs, yOfs = interface.scanFrame.frame:GetPoint(1)
		DB.global.scanFrame = {point=point, relativeTo=relativeTo, relativePoint=relativePoint, xOfs=xOfs, yOfs=yOfs,}

		point, relativeTo,relativePoint, xOfs, yOfs = interface.dumpWindow.frame:GetPoint(1)
		DB.global.dumpWindow = {point=point, relativeTo=relativeTo, relativePoint=relativePoint, xOfs=xOfs, yOfs=yOfs,}

		C_UI.Reload()
	elseif str == "factorySettings" then
		FastGuildInvite.db:ResetDB()
	else
		return print(format("FGI - unregistered command \"%s\"", str))
	end
end

function Console:FGIHelp()
	print("|cffffff00<|r|cff16ABB5FGI|r|cffffff00>|r Help")
	print(L.show)
	print(L.resetDB)
	print(L.factorySettings)
	print(L.resetWindowsPos)
	print(L.invite)
	print(L.nextSearch)
	print(L.blacklist)
	print(L.unblacklist)
	print(L.dump)
	print(L.help2)
end

function Console:FGIHelp2()
	print("|cffffff00<|r|cff16ABB5FGI|r|cffffff00>|r Help2")
	print(L.intro)
	print(L.commandList)
	print(L.fgi)
	print(L.blacklistAdd)
	print(L.blacklistDelete)
	print(L.blacklistGetList)

end
