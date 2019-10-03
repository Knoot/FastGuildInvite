local addon = FGI
local fn = addon.functions
local L = addon.L
local settings = L.settings
local size = settings.size
local color = addon.color
local interface = addon.interface
-- local GUI = LibStub("AceKGUI-3.0")
local GUI = LibStub("AceGUI-3.0")
local FastGuildInvite = addon.lib
local DB
local fontSize = fn.fontSize

local settings


interface.settings = CreateFrame("Frame", UIParent)
local settings = interface.settings
settings.name = "Fast Guild Invite"
InterfaceOptions_AddCategory(settings)

settings.profile = CreateFrame("Frame", settings)
settings.profile.name = "Profile"
-- settings.profile.refresh  = function(self)print(self:GetHeight())end
settings.profile.parent = settings.name
InterfaceOptions_AddCategory(settings.profile)

settings.filters = CreateFrame("Frame", settings)
settings.filters.name = L.interface["Фильтры"]
settings.filters.parent = settings.name
settings.filters.refresh  = function(self)
	
end
InterfaceOptions_AddCategory(settings.filters)

settings.KeyBind = CreateFrame("Frame", settings)
settings.KeyBind.name = "KeyBind"
-- settings.KeyBind.refresh  = function(self)print(self,InterfaceOptionsFramePanelContainer.displayedPanel:GetHeight())end
settings.KeyBind.parent = settings.name
InterfaceOptions_AddCategory(settings.KeyBind)

settings.CustomizePost = CreateFrame("Frame", settings)
settings.CustomizePost.name = L.interface["Настроить сообщения"]
settings.CustomizePost.parent = settings.name
InterfaceOptions_AddCategory(settings.CustomizePost)

settings.Blacklist = CreateFrame("Frame", settings)
settings.Blacklist.name = L.interface["Черный список"]
settings.Blacklist.parent = settings.name
InterfaceOptions_AddCategory(settings.Blacklist)

settings.Synchronization = CreateFrame("Frame", settings)
settings.Synchronization.name = L.interface["Синхронизация"]
settings.Synchronization.parent = settings.name
InterfaceOptions_AddCategory(settings.Synchronization)

settings.CustomList = CreateFrame("Frame", settings)
settings.CustomList.name = L.interface["Пользовательский список"]
settings.CustomList.parent = settings.name
InterfaceOptions_AddCategory(settings.CustomList)

settings.credits = CreateFrame("Frame", settings)
settings.credits.name = L.interface["Благодарности"]
settings.credits.parent = settings.name
InterfaceOptions_AddCategory(settings.credits)

settings.db = CreateFrame("Frame", settings)
settings.db.name = "DB"
settings.db.parent = settings.name
InterfaceOptions_AddCategory(settings.db)

-- InterfaceOptionsFrame_OpenToCategory(settings)
-- InterfaceOptionsFrame_OpenToCategory(settings)
-- InterfaceOptionsFrame_OpenToCategory(settings.Synchronization)
-- InterfaceOptionsFrame_OpenToCategory(settings.Synchronization)


local w,h = 623, 568
interface.settings.content = GUI:Create("SimpleGroup")
settings = interface.settings.content
settings:SetWidth(w-20)
settings:SetHeight(h-20)
settings.frame:SetParent(interface.settings)
settings:SetLayout("NIL")
settings:SetPoint("TOPLEFT", interface.settings, "TOPLEFT", 10, -10)


settings.settingsCheckBoxGRP = GUI:Create("GroupFrame")
local settingsCheckBoxGRP = settings.settingsCheckBoxGRP
settingsCheckBoxGRP:SetLayout("NIL")
settingsCheckBoxGRP:SetHeight(120)
settingsCheckBoxGRP:SetWidth(size.settingsCheckBoxGRP)
settingsCheckBoxGRP:SetPoint("TOPLEFT", settings.frame, "TOPLEFT", 0, 0)
settings:AddChild(settingsCheckBoxGRP)

settingsCheckBoxGRP.addonMSG = GUI:Create("TCheckBox")
local frame = settingsCheckBoxGRP.addonMSG
frame:SetWidth(size.addonMSG)
frame:SetLabel(L.interface["Выключить сообщения аддона"])
frame:SetTooltip(L.interface.tooltip["Не отображать в чате сообщения аддона"])
frame:SetDisabled(true)
-- fontSize(frame.text)
frame.frame:HookScript("OnClick", function()
	DB.addonMSG = settingsCheckBoxGRP.addonMSG:GetValue()
end)
frame:SetPoint("TOPLEFT", settings.settingsCheckBoxGRP.frame, "TOPLEFT", 0, 0)
settingsCheckBoxGRP:AddChild(frame)

settingsCheckBoxGRP.systemMSG = GUI:Create("TCheckBox")
local frame = settingsCheckBoxGRP.systemMSG
frame:SetWidth(size.systemMSG)
frame:SetLabel(L.interface["Выключить системные сообщения"])
frame:SetTooltip(L.interface.tooltip["Не отображать в чате системные сообщения"])
-- fontSize(frame.text)
frame.frame:HookScript("OnClick", function()
	DB.systemMSG = settingsCheckBoxGRP.systemMSG:GetValue()
end)
frame:SetPoint("TOPLEFT", settings.settingsCheckBoxGRP.addonMSG.frame, "BOTTOMLEFT", 0, 0)
settingsCheckBoxGRP:AddChild(frame)

settingsCheckBoxGRP.sendMSG = GUI:Create("TCheckBox")
local frame = settingsCheckBoxGRP.sendMSG
frame:SetWidth(size.sendMSG)
frame:SetLabel(L.interface["Выключить отправляемые сообщения"])
frame:SetTooltip(L.interface.tooltip["Не отображать в чате отправляемые сообщения"])
-- fontSize(frame.text)
frame.frame:HookScript("OnClick", function()
	DB.sendMSG = settingsCheckBoxGRP.sendMSG:GetValue()
end)
frame:SetPoint("TOPLEFT", settings.settingsCheckBoxGRP.systemMSG.frame, "BOTTOMLEFT", 0, 0)
settingsCheckBoxGRP:AddChild(frame)

settingsCheckBoxGRP.minimapButton = GUI:Create("TCheckBox")
local frame = settingsCheckBoxGRP.minimapButton
frame:SetWidth(size.minimapButton)
frame:SetLabel(L.interface["Не отображать значок у миникарты"])
frame:SetTooltip("")
-- fontSize(frame.text)
frame.frame:HookScript("OnClick", function()
	DB.minimap.hide = settingsCheckBoxGRP.minimapButton:GetValue()
	if DB.minimap.hide then
		addon.icon:Hide("FGI")
	else
		addon.icon:Show("FGI")
	end
end)
frame:SetPoint("TOPLEFT", settings.settingsCheckBoxGRP.sendMSG.frame, "BOTTOMLEFT", 0, 0)
settingsCheckBoxGRP:AddChild(frame)

settingsCheckBoxGRP.rememberAll = GUI:Create("TCheckBox")
local frame = settingsCheckBoxGRP.rememberAll
frame:SetWidth(size.rememberAll)
frame:SetLabel(L.interface["Запоминать всех игроков"])
frame:SetTooltip(L.interface.tooltip["Записывать игрока в базу данных даже если приглашение не было отправлено"])
-- fontSize(frame.text)
frame.frame:HookScript("OnClick", function()
	DB.rememberAll = settingsCheckBoxGRP.rememberAll:GetValue()
end)
frame:SetPoint("TOPLEFT", settings.settingsCheckBoxGRP.minimapButton.frame, "BOTTOMLEFT", 0, 0)
settingsCheckBoxGRP:AddChild(frame)




settings.clearDBtimes = GUI:Create("Dropdown")
local frame = settings.clearDBtimes
frame:SetWidth(size.clearDBtimes)
frame:SetLabel(L.interface.clearDBtimes["Время запоминания игрока"])
frame:SetList({L.interface.clearDBtimes["Отключить"], L.interface.clearDBtimes["1 день"], L.interface.clearDBtimes["1 неделя"], L.interface.clearDBtimes["1 месяц"], L.interface.clearDBtimes["6 месяцев"],})
frame:SetCallback("OnValueChanged", function(key)
	DB.clearDBtimes = settings.clearDBtimes:GetValue()
end)
frame:SetPoint("TOPLEFT", settings.settingsCheckBoxGRP.frame, "BOTTOMLEFT", 0, 0)
settings:AddChild(frame)







-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB
	
	settingsCheckBoxGRP.addonMSG:SetValue(DB.addonMSG or false)
	settingsCheckBoxGRP.systemMSG:SetValue(DB.systemMSG or false)
	settingsCheckBoxGRP.sendMSG:SetValue(DB.sendMSG or false)
	settingsCheckBoxGRP.minimapButton:SetValue(DB.minimap.hide or false)
	settingsCheckBoxGRP.rememberAll:SetValue(DB.rememberAll or false)
	settings.clearDBtimes:SetValue(DB.clearDBtimes)
	-- settingsCheckBoxGRP.addonMSG:SetValue(true)
	
	
	--[[if DB.settingsFrame then
		interface.settingsFrame:ClearAllPoints()
		interface.settingsFrame:SetPoint(DB.settingsFrame.point, UIParent, DB.settingsFrame.relativePoint, DB.settingsFrame.xOfs, DB.settingsFrame.yOfs)
	else
		interface.settingsFrame:SetPoint("CENTER", UIParent)
	end
	
	C_Timer.After(0.1, function()
	settingsFrame.closeButton:ClearAllPoints()
	settingsFrame.closeButton:SetPoint("CENTER", settingsFrame.frame, "TOPRIGHT", -8, -8)
	
	settingsCheckBoxGRP:ClearAllPoints()
	settingsCheckBoxGRP:SetPoint("TOPLEFT", settingsFrame.frame, "TOPLEFT", 20, -25)
	
	settingsCheckBoxGRP.addonMSG:ClearAllPoints()
	settingsCheckBoxGRP.addonMSG:SetPoint("TOPLEFT", settingsCheckBoxGRP.frame, "TOPLEFT", 0, 0)
	
	settingsFrame.clearDBtimes:ClearAllPoints()
	settingsFrame.clearDBtimes:SetPoint("TOPLEFT", settingsCheckBoxGRP.frame, "BOTTOMLEFT", 2, 0)
	
	settingsButtonsGRP:ClearAllPoints()
	settingsButtonsGRP:SetPoint("TOPLEFT", settingsFrame.clearDBtimes.frame, "BOTTOMLEFT", 0, -10)
	
	settingsButtonsGRP.filters:ClearAllPoints()
	settingsButtonsGRP.filters:SetPoint("TOPLEFT", settingsButtonsGRP.frame, "TOPLEFT", 0, 0)
	
	settingsButtonsGRP.keyBind:ClearAllPoints()
	settingsButtonsGRP.keyBind:SetPoint("LEFT", settingsButtonsGRP.filters.frame, "RIGHT", 2, 0)
	
	settingsButtonsGRP.setMSG:ClearAllPoints()
	settingsButtonsGRP.setMSG:SetPoint("LEFT", settingsButtonsGRP.keyBind.frame, "RIGHT", 2, 0)
	
	settingsButtonsGRP.blackList:ClearAllPoints()
	settingsButtonsGRP.blackList:SetPoint("TOPRIGHT", settingsFrame.frame, "TOPRIGHT", -20, -30)
	
	settingsButtonsGRP.customListBtn:ClearAllPoints()
	settingsButtonsGRP.customListBtn:SetPoint("TOPRIGHT", settingsFrame.settingsButtonsGRP.blackList.frame, "BOTTOMRIGHT", 0, 2)
	
	settingsFrame:Hide()
	end)]]
end)
