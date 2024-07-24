local addon = FGI
local fn = addon.functions
local L = FGI:GetLocale()
local settings = L.settings
local size = settings.size
local interface = addon.interface
local GUI = LibStub("AceGUI-3.0")
local fontSize = fn.fontSize



interface.settings.KeyBind = GUI:Create("GroupFrame")
local KeyBind = interface.settings.KeyBind
KeyBind:SetLayout("NIL")
interface.settings:AddChild(KeyBind)
interface.settings.AddContent('KeyBind', L["KeyBind"], KeyBind)

KeyBind.inviteLabel = GUI:Create("TLabel")
local frame = KeyBind.inviteLabel
frame:SetText(L["Назначить клавишу для приглашения"])
fontSize(frame.label)
frame.label:SetJustifyH("CENTER")
frame:SetWidth(size.keyBind)
frame:SetPoint("TOPLEFT", KeyBind.frame, "TOPLEFT", 0, 0)
KeyBind:AddChild(frame)

KeyBind.invite = GUI:Create("TKeybinding")
local frame = KeyBind.invite
fontSize(frame.label)
frame:SetWidth(size.keyBind)
frame:SetHeight(40)
frame:SetCallback("OnKeyChanged", function(self) fn:SetKeybind(self:GetKey(), "invite") end)
frame:SetPoint("TOP", KeyBind.inviteLabel.frame, "BOTTOM", 0, -40)
KeyBind:AddChild(frame)


KeyBind.nextSearchLabel = GUI:Create("TLabel")
local frame = KeyBind.nextSearchLabel
frame:SetText(L["Назначить клавишу следующего поиска"])
fontSize(frame.label)
frame.label:SetJustifyH("CENTER")
frame:SetWidth(size.keyBind)
frame:SetPoint("LEFT", KeyBind.inviteLabel.frame, "RIGHT", 50, 0)
KeyBind:AddChild(frame)

KeyBind.nextSearch = GUI:Create("TKeybinding")
local frame = KeyBind.nextSearch
fontSize(frame.label)
frame:SetWidth(size.keyBind)
frame:SetHeight(40)
frame:SetCallback("OnKeyChanged", function(self) fn:SetKeybind(self:GetKey(), "nextSearch") end)
frame:SetPoint("TOP", KeyBind.nextSearchLabel.frame, "BOTTOM", 0, -40)
KeyBind:AddChild(frame)
