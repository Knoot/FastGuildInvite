local addon = FGI
local fn = addon.functions
local L = FGI:GetLocale()
local interface = addon.interface
local settings = L.settings
local Console = LibStub("AceConsole-3.0")
local GUI = LibStub("AceGUI-3.0")
local AceSerializer = LibStub("AceSerializer-3.0")
local libc = LibStub:GetLibrary("LibCompress")
local FastGuildInvite = addon.lib
local DB = addon.DB
local debugDB = addon.debugDB
addon.icon = LibStub("LibDBIcon-1.0")
local icon = addon.icon
local color = addon.color
local debug = fn.debug

local function istable(t)
	return type(t) == "table"
end

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

local function MenuButtons(self)
	local button = self.value;
	if (button == "BLACKLIST") then
		local dropdownFrame = UIDROPDOWNMENU_INIT_MENU;
		local name = dropdownFrame.name;
		local server = dropdownFrame.server;
		
		fn:blackList(name)
		interface.settings.Blacklist.content:update()
		StaticPopup_Show("FGI_BLACKLIST_CHANGE", _,_,  {name = name})
		
	elseif (button == "GUILD_INVITE") then
		local dropdownFrame = UIDROPDOWNMENU_INIT_MENU;
		local unit = dropdownFrame.unit;
		local name = dropdownFrame.name;
		GuildInvite(name)
		fn:rememberPlayer(name)
	end
end

local FGIBlackList = CreateFrame("Frame","FGIMenuButtons")
FGIBlackList:SetScript("OnEvent", function() hooksecurefunc("UnitPopup_OnClick", MenuButtons) end)
FGIBlackList:RegisterEvent("PLAYER_LOGIN")

local PopupUnits = {}

UnitPopupButtons["BLACKLIST"] = { text = "FGI - Black List"}
UnitPopupButtons["GUILD_INVITE"] = { text = "FGI - Guild Invite"}

local function addMenuButtons()
	for i,UPMenus in pairs(UnitPopupMenus) do
		for j=1, #UPMenus do
			if UPMenus[j] == "WHISPER" then
				PopupUnits[#PopupUnits + 1] = i
				pos = j + 1
				table.insert( UnitPopupMenus[i] ,pos , "BLACKLIST" )
				table.insert( UnitPopupMenus[i] ,j , "GUILD_INVITE" )
				break
			end
		end
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_SYSTEM")
frame:SetScript("OnEvent", function(...)
	local _,_, msg = ...
	place = strfind(ERR_GUILD_LEAVE_S ,"%s",1,true)
	if (place) then
		n = strsub(msg,place)
		name = strsub(n,1,(strfind(n,"%s") or 2)-1)
		if format(ERR_GUILD_LEAVE_S ,name) == msg then
			DB.realm.leave[name] = true
			debug(format("Player %s left the guild or was expelled.", name), color.yellow)
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
		SendChatMessage(" "..L.blacklistAdd , "OFFICER",  GetDefaultLanguage("player"))
		SendChatMessage(" "..L.blacklistDelete , "OFFICER",  GetDefaultLanguage("player"))
		SendChatMessage(" "..L.blacklistGetList , "OFFICER",  GetDefaultLanguage("player"))
	elseif msg:find("^!blacklistAdd") then
		msg = msg:gsub("!blacklistAdd ", '')
		local b,n,r = isCorrect(msg)
		if r==nil then return end
		print("add",b,n,r)
	elseif msg:find("^!blacklistDelete") then
		msg = msg:gsub("!blacklistDelete ", '')
		local b,n,r = isCorrect(msg)
		print("delete",b,n,r)
	elseif msg:find("^!blacklistGetList") then
		for k,v in pairs(DB.realm.blackList) do
			SendChatMessage(format("%s - %s", k, v) , "OFFICER",  GetDefaultLanguage("player"))
		end
	end
end)




function addon.dataBroker.OnTooltipShow(GameTooltip)
	local search = addon.search
	GameTooltip:SetText(format(L.minimap,#search.inviteList, interface.scanFrame.progressBar:GetProgress()), 1, 1, 1)
end


function FastGuildInvite:OnEnable()
	if DB.global.createMenuButtons then addMenuButtons() end
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
		
	interface.debugFrame = GUI:Create("ClearFrame")
	local debugFrame = interface.debugFrame
	debugFrame:SetTitle("FGI Debug")
	debugFrame:SetWidth(400)
	debugFrame:SetHeight(720)
	debugFrame:SetLayout("Fill")
	
	debugFrame.title:SetScript('OnMouseUp', function(mover)
		local frame = mover:GetParent()
		frame:StopMovingOrSizing()
		local self = frame.obj
		local status = self.status or self.localstatus
		status.width = frame:GetWidth()
		status.height = frame:GetHeight()
		status.top = frame:GetTop()
		status.left = frame:GetLeft()
	end)
	
	debugFrame.debugList = GUI:Create("MultiLineEditBox")
	local frame = debugFrame.debugList
	-- frame:SetNumLines(50)
	frame:SetLabel("")
	frame:SetWidth(interface.debugFrame.frame:GetWidth()-40)
	frame.txt = ''
	frame:DisableButton(true)
	frame:SetHeight(interface.debugFrame.frame:GetHeight()-40)
	debugFrame:AddChild(frame)
	
	debugFrame.closeButton = GUI:Create('Button')
	local frame = debugFrame.closeButton
	frame:SetText('X')
	frame:SetWidth(frame.frame:GetHeight())
	fn:closeBtn(frame)
	frame:SetCallback('OnClick', function()
		interface.debugFrame:Hide()
	end)
	debugFrame:AddChild(frame)
	-- debugFrame.closeButton:ClearAllPoints()
	debugFrame.closeButton:SetPoint("CENTER", debugFrame.frame, "TOPRIGHT", -8, -8)
	debugFrame:Hide()
	-- if not addon.debug then debugFrame:Hide() else debugFrame:Show() end
	
	fn:SetKeybind(DB.global.keyBind.invite, "invite")
	fn:SetKeybind(DB.global.keyBind.nextSearch, "nextSearch")
	
	
	
	
	
	
	interface.debugFrame:ClearAllPoints()
	interface.debugFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
	
	
	
	Console:RegisterChatCommand('fgi', 'FGIInput')
	Console:RegisterChatCommand('FastGuildInvite', 'FGIInput')
	Console:RegisterChatCommand('fgibl', 'FGIAddBlackList')
	Console:RegisterChatCommand('fgidebug', 'FGIdebug')
end


local defaultSettings =  { 
	profile = {
	},
	realm = {
		enableFilters = false,
		customWho = false,
		addonMSG = false,
		systemMSG = false,
		sendMSG = false,
		curMessage = 1,
		messageList = {},
		filtersList = {},
		blackList = {},
		alreadySended = {},
		leave = {},
	},
	faction = {
		customWhoList = {"1-15 c-\"Class\" r-\"Race\""},
	},
	global = {
		inviteType = 1,
		lowLimit = FGI_MINLVL,
		highLimit = FGI_MAXLVL,
		keyBind = {invite = false, nextSearch = false},
		clearDBtimes = 3,
		minimap = {hide = false},
		debug = false,
		security = {blacklist = true, sended = true},
		addonMSG = false,
		rememberAll = false,
		queueNotify = true,
		searchAlertNotify = true,
		createMenuButtons = true,
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
	if DB.global.customWhoList then
		DB.faction.customWhoList = DB.global.customWhoList
		DB.global.customWhoList = nil
	end
	if DB.global.blackList then
		DB.realm.blackList = DB.global.blackList
		DB.global.blackList = nil
	end
	if DB.global.messageList then
		DB.realm.messageList = DB.global.messageList
		DB.global.messageList = nil
	end
	if DB.realm.messageList[0] then
		table.insert(DB.realm.messageList, DB.realm.messageList[0])
		DB.realm.messageList[0] = nil
		DB.realm.curMessage = 1
	end
	if DB.global.alredySended then
		DB.realm.alreadySended = DB.global.alredySended
		DB.global.alredySended = nil
	end
	if DB.global.filtersList then
		DB.realm.filtersList = DB.global.filtersList
		DB.global.filtersList = nil
	end
	if DB.global.leave then
		DB.realm.leave = DB.global.leave
		DB.global.leave = nil
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

function isCorrect(str)
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
		SendChatMessage(format("%s %s - %s", format(L["Игрок %s добавлен в черный список."], n), L["Причина"], r) , "OFFICER",  GetDefaultLanguage("player"))
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
	elseif str == "invite" then
		fn:invitePlayer()
	elseif str == "nextSearch" then
		interface.scanFrame.pausePlay.frame:Click()
	elseif str:find("^blacklist") then 
		local name,reason = fn:parseBL(str)
		if not name then return print('Blacklist: nil name') end
		fn:blackList(name, reason)
		if not reason then
			StaticPopup_Show("FGI_BLACKLIST_CHANGE", _,_,  {name = name})
		end
	elseif str == 'debug' then 
		toggleDebug()
	elseif str == 'resetDB' then DB.realm.alreadySended = {}
	elseif str == 'resetWindowsPos' then
		interface.mainFrame:ClearAllPoints()
		interface.scanFrame:ClearAllPoints()
		interface.chooseInvites:ClearAllPoints()
		
		interface.mainFrame:SetPoint("CENTER", UIParent)
		interface.scanFrame:SetPoint("CENTER", UIParent)
		interface.chooseInvites:SetPoint("CENTER", UIParent)
		
		local point, relativeTo,relativePoint, xOfs, yOfs = interface.mainFrame.frame:GetPoint(1)
		DB.global.mainFrame = {point=point, relativeTo=relativeTo, relativePoint=relativePoint, xOfs=xOfs, yOfs=yOfs,}
		
		point, relativeTo,relativePoint, xOfs, yOfs = interface.scanFrame.frame:GetPoint(1)
		DB.global.scanFrame = {point=point, relativeTo=relativeTo, relativePoint=relativePoint, xOfs=xOfs, yOfs=yOfs,}
		
		point, relativeTo,relativePoint, xOfs, yOfs = interface.chooseInvites.frame:GetPoint(1)
		DB.global.chooseInvites = {point=point, relativeTo=relativeTo, relativePoint=relativePoint, xOfs=xOfs, yOfs=yOfs,}
		
		C_UI.Reload()
	elseif str == "factorySettings" then
		FastGuildInvite.db:ResetDB()
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
