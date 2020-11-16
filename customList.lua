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

local CustomList

local function btnText(frame)
	local text = frame.text
	text:ClearAllPoints()
	text:SetPoint("TOPLEFT", 5, -1)
	text:SetPoint("BOTTOMRIGHT", -5, 1)
end

local w,h = 623, 568
interface.settings.CustomList.content = GUI:Create("SimpleGroup")
CustomList = interface.settings.CustomList.content
CustomList:SetWidth(w-20)
CustomList:SetHeight(h-20)
CustomList.frame:SetParent(interface.settings.CustomList)
CustomList:SetLayout("NIL")
CustomList:SetPoint("TOPLEFT", interface.settings.CustomList, "TOPLEFT", 10, -10)


CustomList.list = GUI:Create("MultiLineEditBox")
local frame = CustomList.list
frame:SetLabel("")
frame:SetHeight(h-60)
frame:SetNumLines(35)
frame:SetWidth(w-10)
frame:DisableButton(true)
frame:SetPoint("TOP", CustomList.frame, "TOP", 0, 0)
CustomList:AddChild(frame)

CustomList.customList = GUI:Create("TCheckBox")
local frame = CustomList.customList
frame:SetWidth(size.customListBtn)
frame:SetLabel(L["Вкл/Выкл"])
frame:SetTooltip(L["Использовать пользовательский список запросов"])
frame:SetPoint("TOPLEFT", CustomList.list.frame, "BOTTOMLEFT", 0, 0)
frame.frame:HookScript("OnClick", function()
	DB.realm.customWho = CustomList.customList:GetValue()
end)
CustomList:AddChild(frame)

CustomList.saveButton = GUI:Create("Button")
local frame = CustomList.saveButton
frame:SetText(L["Сохранить"])
-- fontSize(frame.text)
btnText(frame)
frame:SetWidth(size.saveButton)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	DB.faction.customWhoList = {}
	for k,v in pairs(table.pack(fn:split(CustomList.list:GetText(),"\n"))) do
		if v~="" then
			table.insert(DB.faction.customWhoList, v)
		end
	end
end)
frame:SetPoint("BOTTOM", CustomList.frame, "BOTTOM", 0, 0)
CustomList:AddChild(frame)



-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB
	local str = ''
	for i=1,#DB.faction.customWhoList do
		str = format("%s%s\n", str, DB.faction.customWhoList[i])
		CustomList.list:SetText(str)
	end
	
	CustomList.customList:SetValue(DB.realm.customWho or false)
end)
