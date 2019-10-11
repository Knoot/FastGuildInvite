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

local credits, scrollBar
local w,h = 623, 568
do		--	credits
interface.settings.credits.content = GUI:Create("SimpleGroup")
credits = interface.settings.credits.content
credits:SetWidth(w-20)
credits:SetHeight(h-20)
credits.frame:SetParent(interface.settings.credits)
credits:SetPoint("TOPLEFT", interface.settings.credits, "TOPLEFT", 10, -10)
credits:SetLayout("NIL")

credits.scrollBar = GUI:Create("ScrollFrame")
scrollBar = credits.scrollBar
scrollBar:SetWidth(credits.frame:GetWidth())
scrollBar:SetHeight(credits.frame:GetHeight())
scrollBar:SetPoint("TOPLEFT", credits.frame, "TOPLEFT", 0, 0)
credits:AddChild(scrollBar)
scrollBar:SetLayout("Flow")




local function labelWidth(p)
	p = p or 10
	local w = credits.frame:GetWidth()
	return w/105*p
end
credits.Category = GUI:Create("TLabel")
local frame = credits.Category
fontSize(frame.label, nil, 14)
frame:SetWidth(labelWidth(18))
frame:SetPoint("TOPLEFT", scrollBar.frame, "TOPLEFT", 0, 0)
scrollBar:AddChild(frame)

credits.Name = GUI:Create("TLabel")
local frame = credits.Name
fontSize(frame.label, nil, 14)
frame:SetWidth(labelWidth(38))
frame:SetPoint("TOPLEFT", credits.Category.frame, "TOPRIGHT", 0, 0)
scrollBar:AddChild(frame)

credits.Contact = GUI:Create("TLabel")
local frame = credits.Contact
fontSize(frame.label, nil, 14)
frame:SetWidth(labelWidth(23))
frame:SetPoint("TOPLEFT", credits.Name.frame, "TOPRIGHT", 0, 0)
scrollBar:AddChild(frame)

credits.Donate = GUI:Create("TLabel")
local frame = credits.Donate
fontSize(frame.label, nil, 14)
frame:SetWidth(labelWidth(21))
frame:SetPoint("TOPLEFT", credits.Contact.frame, "TOPRIGHT", 0, 0)
scrollBar:AddChild(frame)
end

local cat,name,contact,donate = '','','',''
for i=1,#L.credits do
	local u = L.credits[i]
	local _, lines = u[2]:gsub("\n", '')
	lines = ("\n"):rep(lines)
	local Ctype = u[1]:find(L["Автор"]) and color.green or u[1]:find(L["Перевод"]) and color.blue or u[1]:find("Donate") and color.yellow or u[1]:find(L["Тестирование"]) and color.orange or ''
	cat,name,contact,donate = format("%s\n%s%s|r", cat, Ctype, u[1]..lines),format("%s\n%s%s|r", name, Ctype, u[2]),format("%s\n%s%s|r", contact, Ctype, u[3]..lines),format("%s\n%s%s|r", donate, Ctype, u[4]..lines)
end
	credits.Category:SetText(cat)
	credits.Name:SetText(name)
	credits.Contact:SetText(contact)
	credits.Donate:SetText(donate)
	
	
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	scrollBar.content:SetHeight(credits.Category.frame:GetHeight())
end)