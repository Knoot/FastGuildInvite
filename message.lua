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

local CustomizePost

local function previewSet(msg)
	msg = msg or DB.factionrealm.messageList[DB.factionrealm.curMessage] or ''
	if msg then msg = fn:msgMod(msg) end
	local MSG = ''
	for _,v in pairs(fn:messageSplit(msg)) do
		MSG = MSG .. v .. "\n"
	end
	CustomizePost.curMessage:SetText(format(L["Предпросмотр: %s"], MSG or ''))
end

local function defaultValues()
	CustomizePost.message:SetText(DB.factionrealm.messageList[DB.factionrealm.curMessage] or "")
	CustomizePost.drop:SetList(DB.factionrealm.messageList)
	CustomizePost.drop:SetValue(DB.factionrealm.curMessage)
	previewSet()
end

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
interface.settings.CustomizePost.content = GUI:Create("SimpleGroup")
CustomizePost = interface.settings.CustomizePost.content
CustomizePost:SetWidth(w-20)
CustomizePost:SetHeight(h-20-60)
CustomizePost.frame:SetParent(interface.settings.CustomizePost)
CustomizePost:SetLayout("NIL")
CustomizePost:SetPoint("TOPLEFT", interface.settings.CustomizePost, "TOPLEFT", 10, -10)

CustomizePost.intro = GUI:Create("TLabel")
local frame = CustomizePost.intro
frame:SetText(L["Настройка сообщений, подсказка"])
fontSize(frame.label)
frame:SetWidth(CustomizePost.frame:GetWidth()-30)
frame.label:SetJustifyH("CENTER")
frame:SetPoint("TOP", CustomizePost.frame, "TOP", 0, 0)
CustomizePost:AddChild(frame)

CustomizePost.drop = GUI:Create("Dropdown")
local frame = CustomizePost.drop
frame:SetWidth(CustomizePost.frame:GetWidth()-30)
frame:SetCallback("OnValueChanged", function(key)
	CustomizePost.message:SetText(DB.factionrealm.messageList[CustomizePost.drop:GetValue()] or "")
	local msg = DB.factionrealm.messageList[CustomizePost.drop:GetValue()]
	--[[if msg then msg = fn:msgMod(msg) end
	CustomizePost.curMessage:SetText(format(L["Предпросмотр: %s"], msg or ''))]]
	previewSet(msg)
end)
frame:SetPoint("TOP", CustomizePost.intro.frame, "BOTTOM", 0, -10)
CustomizePost:AddChild(frame)

CustomizePost.message = GUI:Create("EditBox")
local frame = CustomizePost.message
frame:SetWidth(CustomizePost.frame:GetWidth()-30)
EditBoxChange(frame)
frame:SetCallback("OnTextChanged", function(_,_,msg)
	--[[if msg then msg = fn:msgMod(msg) end
	CustomizePost.curMessage:SetText(format(L["Предпросмотр: %s"], msg or ''))]]
	previewSet(msg)
end)
frame:SetPoint("TOP", CustomizePost.drop.frame, "BOTTOM", 0, -10)
CustomizePost:AddChild(frame)

CustomizePost.save = GUI:Create("Button")
local frame = CustomizePost.save
frame:SetText(L["Сохранить"])
-- fontSize(frame.text)
frame.text:ClearAllPoints()
frame.text:SetPoint("TOPLEFT", 5, -1)
frame.text:SetPoint("BOTTOMRIGHT", -5, 1)
frame:SetWidth(size.save)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	local msg = CustomizePost.message:GetText()
	if msg == "" then
		BasicMessageDialog:SetFrameStrata("TOOLTIP")
		return message(L["Нельзя сохранить пустое сообщение"])
	else
		
		DB.factionrealm.messageList[CustomizePost.drop:GetValue()] = msg
		DB.factionrealm.curMessage = CustomizePost.drop:GetValue()
		defaultValues()
	end
end)
frame:SetPoint("TOP", CustomizePost.message.frame, "BOTTOM", 0, -10)
CustomizePost:AddChild(frame)

CustomizePost.add = GUI:Create("Button")
local frame = CustomizePost.add
frame:SetText(L["Добавить"])
-- fontSize(frame.text)
frame:SetWidth(size.add)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	local msg = CustomizePost.message:GetText()
	if msg == "" then
		BasicMessageDialog:SetFrameStrata("TOOLTIP")
		return message(L["Нельзя добавить пустое сообщение"])
	else
		table.insert(DB.factionrealm.messageList, msg)
		DB.factionrealm.curMessage = #DB.factionrealm.messageList
		defaultValues()
	end
end)
frame:SetPoint("RIGHT", CustomizePost.save.frame, "LEFT", -5, 0)
CustomizePost:AddChild(frame)

CustomizePost.delete = GUI:Create("Button")
local frame = CustomizePost.delete
frame:SetText(L["Удалить"])
-- fontSize(frame.text)
frame:SetWidth(size.delete)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	local msg = CustomizePost.drop:GetValue()
	if DB.factionrealm.messageList[msg] == nil then
		BasicMessageDialog:SetFrameStrata("TOOLTIP")
		return message(L["Выберите сообщение"])
	else
		if DB.factionrealm.curMessage == msg then
			DB.factionrealm.curMessage = 1
		elseif DB.factionrealm.curMessage > msg then
			DB.factionrealm.curMessage = DB.factionrealm.curMessage - 1
		end
		table.remove(DB.factionrealm.messageList, msg)
		defaultValues()
	end
end)
frame:SetPoint("LEFT", CustomizePost.save.frame, "RIGHT", 5, 0)
CustomizePost:AddChild(frame)

CustomizePost.frame:HookScript("OnShow", defaultValues)

CustomizePost.curMessage = GUI:Create("TLabel")
local frame = CustomizePost.curMessage
-- frame:SetText(format(L["Предпросмотр: %s"], ''))
fontSize(frame.label)
frame:SetWidth(CustomizePost.frame:GetWidth()-30)
frame.label:SetJustifyH("CENTER")
frame:SetPoint("BOTTOM", CustomizePost.frame, "BOTTOM", 0, 15)
CustomizePost:AddChild(frame)


-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB
	
	defaultValues()
end)
