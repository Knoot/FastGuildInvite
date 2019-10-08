local addon = FGI
local fn = addon.functions
local L = LibStub("AceLocale-3.0"):GetLocale("FastGuildInvite")
local settings = L.settings
local size = settings.size
local color = addon.color
local interface = addon.interface
local GUI = LibStub("AceGUI-3.0")
local FastGuildInvite = addon.lib
local DB
local fontSize = fn.fontSize

local blackList, scrollBar
local w,h = 623, 568

interface.settings.Blacklist.content = GUI:Create("SimpleGroup")
blackList = interface.settings.Blacklist.content
blackList:SetWidth(w-20)
blackList:SetHeight(h-20)
blackList.frame:SetParent(interface.settings.Blacklist)
blackList:SetPoint("TOPLEFT", interface.settings.Blacklist, "TOPLEFT", 10, -10)
blackList:SetLayout("NIL")

blackList.scrollBar = GUI:Create("ScrollFrame")
scrollBar = blackList.scrollBar
scrollBar:SetWidth(blackList.frame:GetWidth())
scrollBar:SetHeight(blackList.frame:GetHeight())
scrollBar:SetPoint("TOPLEFT", blackList.frame, "TOPLEFT", 0, 0)
blackList:AddChild(scrollBar)
scrollBar:SetLayout("Flow")

scrollBar.items = {}

StaticPopupDialogs["FGI_BLACKLIST_CHANGE"] = {
	text = L["Причина"],
	button1 = "Ok",
	button2 = "Cancel",
	OnAccept = function(self, data)
		local reason = self.editBox:GetText()
		DB.realm.blackList[data.name] = reason
		if type(data.frame) == "table" then
			data.frame.r:SetText(reason)
			data.frame.r:SetTooltip(reason)
		else
			blackList:add({name=data.name, reason=reason})
			SendChatMessage(format("%s %s - %s", format(L["Игрок %s добавлен в черный список."], data.name), L["Причина"], reason) , "OFFICER",  GetDefaultLanguage("player"))
		end
		StaticPopup_Hide("FGI_BLACKLIST_CHANGE")
		blackList:update()
		return true
	end,
	OnCancel  = function(self, data)
		blackList:update()
	end,
	OnShow = function(self, data)
		self.text:SetText(format("%s - %s", L["Причина"], data.name))
		self.editBox:SetText(tostring(DB.realm.blackList[data.name]))
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
	hasEditBox = true
}

local function AddHookClick(frame, parent)
	local menu = {
		{text = "Select an Option", isTitle = true},
		{text = "Change", func = function()
			StaticPopup_Show("FGI_BLACKLIST_CHANGE", _,_,  {name = frame.label:GetText(), frame = parent})
		end},
		{text = "Delete", func = function()
			DB.realm.blackList[frame.label:GetText()] = nil
			blackList:update()
		end},
		{text = "", isTitle = true},
		{text = "Cancel", func = function()end},
		--[[{ text = "More Options", hasArrow = true,
			menuList = {
				{ text = "Option 3", func = function() print("You've chosen option 3"); end }
			} 
		}]]
	}
	local menuFrame = CreateFrame("Frame", nil, UIParent, "UIDropDownMenuTemplate")
	frame.frame:HookScript("OnMouseDown",function(self, button,...)
		if button == "RightButton" then
			EasyMenu(menu, menuFrame, "cursor", 0 , 0, "MENU");
		end
	end)
end
local help = "RBM - change"
function blackList:add(data)
	for i=1, #scrollBar.items do
		if not scrollBar.items[i].frame:IsShown() then return blackList:update() end
	end
	scrollBar.items[#scrollBar.items+1] = GUI:Create("SimpleGroup")
	local frame = scrollBar.items[#scrollBar.items]
	frame:SetFullWidth(true)
	frame:SetLayout("NIL")
	frame.n = GUI:Create("TLabel")
		frame.n:SetText(data.name)
		frame.n:SetWidth(120)
		frame.n:SetHeight(20)
		frame.n:SetTooltip(help)
		frame.n:SetPoint("TOPLEFT", frame.frame, "TOPLEFT", 0, 0)
		AddHookClick(frame.n, frame)
	fn.fontSize(frame.n.label)
	frame:AddChild(frame.n)
	frame.r = GUI:Create("TLabel")
		frame.r:SetText(data.reason)
		frame.r.label:SetMaxLines(1)
		frame.r:SetWidth(623-frame.n.frame:GetWidth()-50)
		frame.r:SetHeight(20)
		frame.r:SetTooltip(data.reason)
		frame.r:SetPoint("TOPLEFT", frame.n.frame, "TOPRIGHT", 0, 0)
	fn.fontSize(frame.r.label)
	frame:AddChild(frame.r)
	frame:SetHeight(frame.n.frame:GetHeight())
	scrollBar:AddChild(frame)
	if #scrollBar.items == 1 then
		frame:SetPoint("TOPLEFT", scrollBar.frame, "TOPLEFT", 0, 0)
	else
		frame:SetPoint("TOPLEFT", scrollBar.items[#scrollBar.items-1].frame, "BOTTOMLEFT", 0, -5)
	end
	blackList:update()
end

function blackList:update()
	local i=1
	for name, reason in fn:pairsByKeys(DB.realm.blackList) do
		local f = scrollBar.items[i]
		if not f then return end
		f.n:SetText(name)
		f.r:SetText(tostring(reason))
		f.r:SetTooltip(tostring(reason))
		AddHookClick(f.n, f)
		f.frame:Show()
		i = i+1
	end
	for i=i, #scrollBar.items do
		scrollBar.items[i].frame:Hide()
	end
end

local function showNext()
	local data = StaticPopupDialogs["FGI_BLACKLIST"].data
	if not data[1] then return end
	StaticPopupDialogs["FGI_BLACKLIST"].text = format(L["Игрок %s найденный в черном списке, находится в вашей гильдии!"],data[1])
	StaticPopup_Show("FGI_BLACKLIST")
end
StaticPopupDialogs["FGI_BLACKLIST"] = {
	text = '',
	button1 = "Ok",
	data = {},
	data2 = {},
	OnAccept = function()
		local data = StaticPopupDialogs["FGI_BLACKLIST"].data
		StaticPopupDialogs["FGI_BLACKLIST"].data2[data[1] ] = true
		table.remove(data, 1)
		StaticPopup_Hide("FGI_BLACKLIST")
		showNext()
		return true
	end,
	add = function(name)
		local data = StaticPopupDialogs["FGI_BLACKLIST"].data
		if not StaticPopupDialogs["FGI_BLACKLIST"].data2[name] then table.insert(data, name) end
		showNext()
	end,
	OnShow = function()
		local data = StaticPopupDialogs["FGI_BLACKLIST"].data
		if not data[1] then return end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = false,
	preferredIndex = 3,
}


-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB
	for k,v in pairs(DB.realm.blackList) do
		blackList:add({name=tostring(k),reason=tostring(v)})
	end
end)
