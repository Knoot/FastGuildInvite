local addon = FGI
local fn = addon.functions
local L = FGI:GetLocale()
local settings = L.settings
local size = settings.size
local interface = addon.interface
local GUI = LibStub("AceGUI-3.0")
local DB

local Guild

local noteHelp = "\n\n"..
'%c - ' .. L['date and time'] .. ' (' .. date('%c') .. ")\n"..
'%Y - ' .. L['year'] .. ' (' .. date('%Y') .. ")\n"..
'%y - ' .. L['year'] .. ' (' .. date('%y') .. ")\n"..
'%m - ' .. L['month'] .. ' (' .. date('%m') .. ")\n"..
'%d - ' .. L['day'] .. ' (' .. date('%d') .. ")\n"..
'%H - ' .. L['hour, using a 24-hour clock'] .. ' (' .. date('%H') .. ")\n"..
'%M - ' .. L['minute'] .. ' (' .. date('%M') .. ")\n"..
'%S - ' .. L['second'] .. ' (' .. date('%S') .. ")\n"..
'%B - ' .. L['month'] .. ' (' .. date('%B') .. ")\n"..
'%b - ' .. L['month'] .. ' (' .. date('%b') .. ")\n"..
'%A - ' .. L['weekday'] .. ' (' .. date('%A') .. ")\n"..
'%a - ' .. L['weekday'] .. ' (' .. date('%a') .. ")\n"..
'%w - ' .. L['weekday'] .. ' (' .. date('%w') .. ")\n"..
'%I - ' .. L['hour, using a 12-hour clock'] .. ' (' .. date('%I') .. ")\n"..
'%p - ' .. L['"AM" or "PM"'] .. ' (' .. date('%p') .. ")\n"..
'%x - ' .. L['date'] .. ' (' .. date('%x') .. ")\n"..
'%X - ' .. L['time'] .. ' (' .. date('%X') .. ")\n"..
'%% - ' .. L['the character'] .. ' (' .. date('%%') .. ")\n"..
'NAME - ' .. L['the character name'] .. ' (' .. UnitName('player') .. ")\n"..
"\n\n ' .. 'Joined: %m/%d/%Y = "..date('Joined: %m/%d/%Y')

local function EditBoxChange(frame)
	frame.editbox:SetScript("OnEnterPressed", function(self)
		self:ClearFocus()
		self.lasttext = self:GetText()
	end)
	frame.editbox:SetScript("OnEnter", function(self)
		self.lasttext = self:GetText()
	end)
	frame.editbox:SetScript("OnEscapePressed", function(self)
		self:SetText(self.lasttext or "")
		self:ClearFocus()
	end)
end

local w,h = 623, 568
interface.settings.Guild = GUI:Create("GroupFrame")
Guild = interface.settings.Guild
Guild:SetLayout("NIL")
interface.settings:AddChild(Guild)
interface.settings.AddContent('Guild', L["Гильдия"], Guild, w, h)

Guild.blacklistOfficer = GUI:Create("TCheckBox")
local frame = Guild.blacklistOfficer
frame:SetWidth(size.blacklistOfficer)
frame:SetLabel(L["Сообщать о добавлении в черный список в офицерский канал."])
frame.frame:HookScript("OnClick", function()
	DB.global.blacklistOfficer = Guild.blacklistOfficer:GetValue()
end)
frame:SetPoint("TOPLEFT", Guild.frame, "TOPLEFT", 0, 0)
Guild:AddChild(frame)

Guild.setNote = GUI:Create("TCheckBox")
local frame = Guild.setNote
frame:SetWidth(size.setNote)
frame:SetLabel(L["Заметка для новых игроков"])
frame:SetTooltip(L["Установить заметку для новых членов гильдии"]..noteHelp)
frame.frame:HookScript("OnClick", function()
	DB.global.setNote = Guild.setNote:GetValue()
end)
frame:SetPoint("TOPLEFT", Guild.blacklistOfficer.frame, "BOTTOMLEFT", 0, 0)
Guild:AddChild(frame)

Guild.noteText = GUI:Create("EditBox")
local frame = Guild.noteText
frame:SetWidth(Guild.frame:GetWidth()-30)
frame:DisableButton(true)
EditBoxChange(frame)
frame:SetCallback("OnTextChanged", function(self,_,msg)
	DB.global.noteText = msg
	if fn:getCharLen(msg) > FGI_NOTEMAXLENGTH then
		self:SetText(self.temptext or "")
		return
	end
	self.temptext = msg
end)
frame.editbox:SetScript("OnEscapePressed", function(self)
	DB.global.noteText = self.lasttext
	self:SetText(self.lasttext or "")
	self:ClearFocus()
end)
frame:SetPoint("TOPLEFT", Guild.setNote.frame, "BOTTOMLEFT", 0, 0)
Guild:AddChild(frame)

Guild.setOfficerNote = GUI:Create("TCheckBox")
local frame = Guild.setOfficerNote
frame:SetWidth(size.setOfficerNote)
frame:SetLabel(L["Заметка для офицеров для новых игроков"])
frame:SetTooltip(L["Установить заметку для офицеров для новых членов гильдии"]..noteHelp)
frame.frame:HookScript("OnClick", function()
	DB.global.setOfficerNote = Guild.setOfficerNote:GetValue()
end)
frame:SetPoint("TOPLEFT", Guild.noteText.frame, "BOTTOMLEFT", 0, 0)
Guild:AddChild(frame)

Guild.officerNoteText = GUI:Create("EditBox")
local frame = Guild.officerNoteText
frame:SetWidth(Guild.frame:GetWidth()-30)
frame:DisableButton(true)
EditBoxChange(frame)
frame:SetCallback("OnTextChanged", function(self,_,msg)
	if fn:getCharLen(msg) > FGI_NOTEMAXLENGTH then
		self:SetText(self.temptext or "")
		return
	end
	self.temptext = msg
	DB.global.officerNoteText = msg
end)
frame.editbox:SetScript("OnEscapePressed", function(self)
	DB.global.officerNoteText = self.lasttext
	self:SetText(self.lasttext or "")
	self:ClearFocus()
end)
frame:SetPoint("TOPLEFT", Guild.setOfficerNote.frame, "BOTTOMLEFT", 0, 0)
Guild:AddChild(frame)




local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB

	Guild.setNote:SetValue(DB.global.setNote or false)
	Guild.noteText:SetText(DB.global.noteText or ""); Guild.noteText.temptext = Guild.noteText:GetText()
	Guild.setOfficerNote:SetValue(DB.global.setOfficerNote or false)
	Guild.officerNoteText:SetText(DB.global.officerNoteText or ""); Guild.officerNoteText.temptext = Guild.officerNoteText:GetText()

end)
