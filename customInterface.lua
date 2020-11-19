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

local CustomInterface

local w,h = 623-20, 568-20
interface.settings.CustomInterface.content = GUI:Create("SimpleGroup")
CustomInterface = interface.settings.CustomInterface.content
CustomInterface:SetWidth(w)
CustomInterface:SetHeight(h)
CustomInterface.frame:SetParent(interface.settings.CustomInterface)
CustomInterface:SetLayout("NIL")
CustomInterface:SetPoint("TOPLEFT", interface.settings.CustomInterface, "TOPLEFT", 10, -10)


local scanFrame = GUI:Create("SimpleGroup")
scanFrame:SetWidth(w)
scanFrame:SetHeight(300)
scanFrame.frame:SetParent(CustomInterface.frame)
scanFrame:SetLayout("NIL")
scanFrame:SetPoint("TOPLEFT", CustomInterface.frame, "TOPLEFT", 0, 0)


scanFrame.title = GUI:Create("Label")
local frame = scanFrame.title
frame:SetText("Scan Frame")
fontSize(frame.label)
frame:SetWidth(w)
frame:SetPoint("TOPLEFT", scanFrame.frame, "TOPLEFT", 0, 0)
scanFrame:AddChild(frame)

scanFrame.windowTitle = GUI:Create("TCheckBox")
local frame = scanFrame.windowTitle
frame:SetWidth(w)
frame:SetLabel(format("%s(%s)", L["Заголовок окна"],L["вкл/выкл"]))
frame:SetTooltip(L["Вы можете перемещать окно за его фон и закрыть его двойным кликом."])
frame.frame:HookScript("OnClick", function()
	DB.global.scanFrameChilds.title = scanFrame.windowTitle:GetValue()
	interface.scanFrame.update()
end)
frame:SetPoint("TOPLEFT", scanFrame.title.frame, "BOTTOMLEFT", 0, -10)
scanFrame:AddChild(frame)

scanFrame.player = GUI:Create("TCheckBox")
local frame = scanFrame.player
frame:SetWidth(w)
frame:SetLabel(format("%s(%s)", L["Данные игрока"],L["вкл/выкл"]))
frame.frame:HookScript("OnClick", function()
	DB.global.scanFrameChilds.player = scanFrame.player:GetValue()
	interface.scanFrame.update()
end)
frame:SetPoint("TOPLEFT", scanFrame.windowTitle.frame, "BOTTOMLEFT", 0, 0)
scanFrame:AddChild(frame)

scanFrame.progress = GUI:Create("TCheckBox")
local frame = scanFrame.progress
frame:SetWidth(w)
frame:SetLabel(format("%s(%s)", L["Полоса прогресса"],L["вкл/выкл"]))
frame.frame:HookScript("OnClick", function()
	DB.global.scanFrameChilds.progress = scanFrame.progress:GetValue()
	interface.scanFrame.update()
end)
frame:SetPoint("TOPLEFT", scanFrame.player.frame, "BOTTOMLEFT", 0, 0)
scanFrame:AddChild(frame)

scanFrame.buttons = GUI:Create("TCheckBox")
local frame = scanFrame.buttons
frame:SetWidth(w)
frame:SetLabel(format("%s(%s)", L["Панель кнопок"],L["вкл/выкл"]))
frame.frame:HookScript("OnClick", function()
	DB.global.scanFrameChilds.buttons = scanFrame.buttons:GetValue()
	interface.scanFrame.update()
end)
frame:SetPoint("TOPLEFT", scanFrame.progress.frame, "BOTTOMLEFT", 0, 0)
scanFrame:AddChild(frame)

local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB
	
	scanFrame.windowTitle:SetValue(DB.global.scanFrameChilds.title or false)
	scanFrame.player:SetValue(DB.global.scanFrameChilds.player or false)
	scanFrame.progress:SetValue(DB.global.scanFrameChilds.progress or false)
	scanFrame.buttons:SetValue(DB.global.scanFrameChilds.buttons or false)
end)