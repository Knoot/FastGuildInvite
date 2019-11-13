local addon = FGI
local fn = addon.functions
local L = FGI:GetLocale()
local settings = L.settings
local size = settings.size
local color = addon.color
local interface = addon.interface
local GUI = LibStub("AceGUI-3.0")
local FastGuildInvite = addon.lib
local DB
local fontSize = fn.fontSize

local function btnText(frame)
	local text = frame.text
	text:ClearAllPoints()
	text:SetPoint("TOPLEFT", 5, -1)
	text:SetPoint("BOTTOMRIGHT", -5, 1)
end

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

blackList.items = {}
blackList.page = 1
blackList.pageCount = 1


local function lockPageButtons()
	if blackList.pageCount <= 1 then
		blackList.prevPage:SetDisabled(true)
		blackList.nextPage:SetDisabled(true)
		return
	end
	if blackList.page <= 1 then
		blackList.prevPage:SetDisabled(true)
	else
		blackList.prevPage:SetDisabled(false)
	end
	if blackList.page >= blackList.pageCount then
		blackList.nextPage:SetDisabled(true)
	else
		blackList.nextPage:SetDisabled(false)
	end
end


blackList.nextPage = GUI:Create("Button")
local frame = blackList.nextPage
frame:SetText("+")
btnText(frame)
frame:SetWidth(20)
frame:SetHeight(20)
frame:SetPoint("BOTTOMRIGHT", blackList.frame, "BOTTOMRIGHT", 0, 0)
frame:SetCallback("OnClick", function()
	blackList.page = blackList.page + 1
	blackList:update()
end)
blackList:AddChild(frame)

blackList.pageLabel = GUI:Create("TLabel")
local frame = blackList.pageLabel
frame:SetText(1)
fontSize(frame.label)
frame.label:SetJustifyH("CENTER")
frame:SetWidth(40)
frame:SetPoint("RIGHT", blackList.nextPage.frame, "LEFT", -5, 0)
blackList:AddChild(frame)

blackList.prevPage = GUI:Create("Button")
local frame = blackList.prevPage
frame:SetText("-")
btnText(frame)
frame:SetWidth(20)
frame:SetHeight(20)
frame:SetDisabled(true)
frame:SetPoint("RIGHT", blackList.pageLabel.frame, "LEFT", -5, 0)
frame:SetCallback("OnClick", function()
	blackList.page = blackList.page - 1
	blackList:update()
end)
blackList:AddChild(frame)

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
			-- blackList:add({name=data.name, reason=reason})
			if DB.global.blacklistOfficer then
				SendChatMessage(format("%s %s - %s", format(L["Игрок %s добавлен в черный список."], data.name), L["Причина"], reason) , "OFFICER",  GetDefaultLanguage("player"))
			end
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

for i=1,FGI_BLACKLIST_MAX do
	blackList.items[i] = GUI:Create("SimpleGroup")
	local frame = blackList.items[#blackList.items]
	frame:SetFullWidth(true)
	frame:SetLayout("NIL")
	frame.n = GUI:Create("TLabel")
		frame.n:SetText(i)
		frame.n:SetWidth(120)
		frame.n:SetHeight(20)
		frame.n:SetTooltip(help)
		frame.n:SetPoint("TOPLEFT", frame.frame, "TOPLEFT", 0, 0)
		AddHookClick(frame.n, frame)
	fn.fontSize(frame.n.label)
	frame:AddChild(frame.n)
	frame.r = GUI:Create("TLabel")
		frame.r:SetText("reason")
		frame.r.label:SetMaxLines(1)
		frame.r:SetWidth(623-frame.n.frame:GetWidth()-50)
		frame.r:SetHeight(20)
		frame.r:SetTooltip('data.reason')
		frame.r:SetPoint("TOPLEFT", frame.n.frame, "TOPRIGHT", 0, 0)
	fn.fontSize(frame.r.label)
	frame:AddChild(frame.r)
	frame:SetHeight(frame.n.frame:GetHeight())
	blackList:AddChild(frame)
	if i == 1 then
		frame:SetPoint("TOPLEFT", blackList.frame, "TOPLEFT", 0, 0)
	else
		frame:SetPoint("TOPLEFT", blackList.items[i-1].frame, "BOTTOMLEFT", 0, -5)
	end
end

function blackList:update()
	local p = blackList.page
	local list = {}
	for name, reason in fn:pairsByKeys(DB.realm.blackList) do
		table.insert(list, {name=name, reason=reason})
	end
	
	for i=1, FGI_BLACKLIST_MAX do
		local data = list[(p-1)*FGI_BLACKLIST_MAX+i]
		local f = blackList.items[i]
		if data then
			if not f then return end
			f.n:SetText(data.name)
			f.r:SetText(tostring(data.reason))
			f.r:SetTooltip(tostring(data.reason))
			AddHookClick(f.n, f)
			f.frame:Show()
		else
			f.frame:Hide()
		end
	end
	blackList.pageLabel:SetText(p)
	blackList.pageCount = math.ceil(#list/FGI_BLACKLIST_MAX)
	lockPageButtons()
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
	blackList:update()
end)