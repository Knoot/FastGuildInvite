local addon = FGI
local fn = addon.functions
local L = FGI:GetLocale()
local settings = L.settings
local size = settings.size
local interface = addon.interface
local GUI = LibStub("AceGUI-3.0")
local DB

local CustomList

local function btnText(frame)
	local text = frame.text
	text:ClearAllPoints()
	text:SetPoint("TOPLEFT", 5, -1)
	text:SetPoint("BOTTOMRIGHT", -5, 1)
end

local w,h = 623, 568
interface.settings.CustomList = GUI:Create("GroupFrame")
CustomList = interface.settings.CustomList
CustomList:SetLayout("NIL")
interface.settings:AddChild(CustomList)
interface.settings.AddContent('CustomList', L["Пользовательский список"], CustomList, w-20, h-20)


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

CustomList.strict = GUI:Create("TCheckBox")
local frame = CustomList.strict
frame:SetWidth(size.customListBtn)
frame:SetLabel(L["Строго"])
frame:SetTooltip(L["Не углублять поиск если вернулось 50 игроков"])
frame:SetPoint("TOPRIGHT", CustomList.list.frame, "BOTTOMRIGHT", 0, 0)
frame.frame:HookScript("OnClick", function()
	DB.realm.strictCustom = CustomList.strict:GetValue()
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
	CustomList.strict:SetValue(DB.realm.strictCustom or false)
end)
