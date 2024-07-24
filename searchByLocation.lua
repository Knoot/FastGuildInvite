local addon = FGI
local fn = addon.functions
local L = FGI:GetLocale()
local settings = L.settings
local size = settings.size
local interface = addon.interface
local GUI = LibStub("AceGUI-3.0")
local DB

local Locations

local function btnText(frame)
	local text = frame.text
	text:ClearAllPoints()
	text:SetPoint("TOPLEFT", 5, -1)
	text:SetPoint("BOTTOMRIGHT", -5, 1)
end

local w,h = 623, 568
interface.settings.locations = GUI:Create("GroupFrame")
Locations = interface.settings.locations
Locations:SetLayout("NIL")
interface.settings:AddChild(Locations)
interface.settings.AddContent('Locations', L["Поиск по локациям"], Locations, w-20, h-20)


Locations.list = GUI:Create("MultiLineEditBox")
local frame = Locations.list
frame:SetLabel("")
frame:SetHeight(h-60)
frame:SetNumLines(35)
frame:SetWidth(w-10)
frame:DisableButton(true)
frame:SetPoint("TOP", Locations.frame, "TOP", 0, 0)
Locations:AddChild(frame)

Locations.saveButton = GUI:Create("Button")
local frame = Locations.saveButton
frame:SetText(L["Сохранить"])
-- fontSize(frame.text)
btnText(frame)
frame:SetWidth(size.saveButton)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	DB.factionrealm.locations = {}
	for _,v in pairs(table.pack(fn:split(Locations.list:GetText(),"\n"))) do
		if v~="" then
			table.insert(DB.factionrealm.locations, v)
		end
	end
end)
frame:SetPoint("BOTTOM", Locations.frame, "BOTTOM", 0, 0)
Locations:AddChild(frame)



-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB
	local str = ''
	for i=1,#DB.factionrealm.locations do
		str = format("%s%s\n", str, DB.factionrealm.locations[i])
	end
	Locations.list:SetText(str)
end)
