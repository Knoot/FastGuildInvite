local addon = FGI
local L = FGI:GetLocale()
local interface = addon.interface
local GUI = LibStub("AceGUI-3.0")
local DB

local Logs

local w,h = 623-20, 568-20
interface.settings.Logs = GUI:Create("GroupFrame")
Logs = interface.settings.Logs
Logs:SetLayout("NIL")
interface.settings:AddChild(Logs)
interface.settings.AddContent('Logs', L["Логи"], Logs, w, h)



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