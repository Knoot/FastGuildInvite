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

local Logs

local w,h = 623-20, 568-20
interface.settings.Logs.content = GUI:Create("SimpleGroup")
Logs = interface.settings.Logs.content
Logs:SetWidth(w)
Logs:SetHeight(h)
Logs.frame:SetParent(interface.settings.Logs)
Logs:SetLayout("NIL")
Logs:SetPoint("TOPLEFT", interface.settings.Logs, "TOPLEFT", 10, -10)



Logs.state = GUI:Create("TCheckBox")
local frame = Logs.state
frame:SetWidth(w)
frame:SetLabel(L["Показывать в чате текущий запрос"])
frame.frame:HookScript("OnClick", function()
	DB.global.logs.on = Logs.state:GetValue()
end)
frame:SetPoint("TOPLEFT", Logs.frame, "TOPLEFT", 0, 0)
Logs:AddChild(frame)

local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB
	Logs.state:SetValue(DB.global.logs.on)
end)