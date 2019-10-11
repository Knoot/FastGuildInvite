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

local Security

local w,h = 623-20, 568-20
interface.settings.Security.content = GUI:Create("SimpleGroup")
Security = interface.settings.Security.content
Security:SetWidth(w)
Security:SetHeight(h)
Security.frame:SetParent(interface.settings.Security)
Security:SetLayout("NIL")
Security:SetPoint("TOPLEFT", interface.settings.Security, "TOPLEFT", 10, -10)


Security.intro = GUI:Create("TLabel")
local frame = Security.intro
frame:SetWidth(w)
frame:SetText(L["Подтверждение отправки данных синхронизации"])
fontSize(frame.label)
frame:SetPoint("TOPLEFT", Security.frame, "TOPLEFT", 0, 0)
Security:AddChild(frame)

Security.sended = GUI:Create("TCheckBox")
local frame = Security.sended
frame:SetWidth(w)
frame:SetLabel(L["Список отправленных приглашений"])
frame.frame:HookScript("OnClick", function()
	DB.global.security.sended = Security.sended:GetValue()
end)
frame:SetPoint("TOPLEFT", Security.intro.frame, "BOTTOMLEFT", 0, 0)
Security:AddChild(frame)

Security.blacklist = GUI:Create("TCheckBox")
local frame = Security.blacklist
frame:SetLabel(L["Черный список"])
frame.frame:HookScript("OnClick", function()
	DB.global.security.blacklist = Security.blacklist:GetValue()
end)
frame:SetPoint("TOPLEFT", Security.sended.frame, "BOTTOMLEFT", 0, 0)
Security:AddChild(frame)


local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB
	Security.sended:SetValue(DB.global.security.sended)
	Security.blacklist:SetValue(DB.global.security.blacklist)
end)