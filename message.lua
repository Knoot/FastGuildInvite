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

local CustomizePost

local function defaultValues()
	CustomizePost.drop:SetList(DB.messageList)
	CustomizePost.drop:SetValue(DB.curMessage)
	CustomizePost.message:SetText(DB.messageList[DB.curMessage] or "")
	local msg = DB.messageList[DB.curMessage]
	if msg then msg = fn:msgMod(msg) end
	CustomizePost.curMessage:SetText(format(L.interface["Предпросмотр: %s"], msg or ''))
end

local function overLen(msg)
	local guildName, guildRankName, guildRankIndex, realm = GetGuildInfo("player")
	msg = msg:gsub("NAME", format("<%s>",guildName or 'GUILD_NAME'))
	if msg:len()>255 then
		BasicMessageDialog:SetFrameStrata("TOOLTIP")
		message(format(L.FAQ.error["Превышен лимит символов. Максимальная длина сообщения 255 символов. Длина сообщения превышена на %d"], msg:len()-255))
		return true
	end
	return false
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
frame:SetText(L.interface["Слово NAME заглавными буквами будет заменено на название вашей гильдии."])
fontSize(frame.label)
frame:SetWidth(CustomizePost.frame:GetWidth()-30)
frame.label:SetJustifyH("CENTER")
frame:SetPoint("TOP", CustomizePost.frame, "TOP", 0, 0)
CustomizePost:AddChild(frame)

CustomizePost.drop = GUI:Create("Dropdown")
local frame = CustomizePost.drop
frame:SetWidth(CustomizePost.frame:GetWidth()-30)
frame:SetCallback("OnValueChanged", function(key)
	CustomizePost.message:SetText(DB.messageList[CustomizePost.drop:GetValue()] or "")
	local msg = DB.messageList[CustomizePost.drop:GetValue()]
	if msg then msg = fn:msgMod(msg) end
	CustomizePost.curMessage:SetText(format(L.interface["Предпросмотр: %s"], msg or ''))
end)
frame:SetPoint("TOP", CustomizePost.intro.frame, "BOTTOM", 0, -10)
CustomizePost:AddChild(frame)

CustomizePost.message = GUI:Create("EditBox")
local frame = CustomizePost.message
frame:SetWidth(CustomizePost.frame:GetWidth()-30)
frame:SetMaxLetters(255)
EditBoxChange(frame)
frame:SetCallback("OnTextChanged", function(_,_,msg)
	if msg then msg = fn:msgMod(msg) end
	CustomizePost.curMessage:SetText(format(L.interface["Предпросмотр: %s"], msg or ''))
end)
frame:SetPoint("TOP", CustomizePost.drop.frame, "BOTTOM", 0, -10)
CustomizePost:AddChild(frame)

CustomizePost.save = GUI:Create("Button")
local frame = CustomizePost.save
frame:SetText(L.interface["Сохранить"])
fontSize(frame.text)
frame.text:ClearAllPoints()
frame.text:SetPoint("TOPLEFT", 5, -1)
frame.text:SetPoint("BOTTOMRIGHT", -5, 1)
frame:SetWidth(size.save)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	local msg = CustomizePost.message:GetText()
	if msg == "" then
		BasicMessageDialog:SetFrameStrata("TOOLTIP")
		return message(L.FAQ.error["Нельзя сохранить пустое сообщение"])
	else
		if overLen(msg) then return end
		
		DB.messageList[CustomizePost.drop:GetValue()] = msg
		DB.curMessage = CustomizePost.drop:GetValue()
		defaultValues()
	end
end)
frame:SetPoint("TOP", CustomizePost.message.frame, "BOTTOM", 0, -10)
CustomizePost:AddChild(frame)

CustomizePost.add = GUI:Create("Button")
local frame = CustomizePost.add
frame:SetText(L.interface["Добавить"])
fontSize(frame.text)
frame:SetWidth(size.add)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	local msg = CustomizePost.message:GetText()
	if msg == "" then
		BasicMessageDialog:SetFrameStrata("TOOLTIP")
		return message(L.FAQ.error["Нельзя добавить пустое сообщение"])
	else
		if overLen(msg) then return end
		
		table.insert(DB.messageList, msg)
		DB.curMessage = #DB.messageList
		defaultValues()
	end
end)
frame:SetPoint("RIGHT", CustomizePost.save.frame, "LEFT", -5, 0)
CustomizePost:AddChild(frame)

CustomizePost.delete = GUI:Create("Button")
local frame = CustomizePost.delete
frame:SetText(L.interface["Удалить"])
fontSize(frame.text)
frame:SetWidth(size.delete)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	local msg = CustomizePost.drop:GetValue()
	if DB.messageList[msg] == nil then
		BasicMessageDialog:SetFrameStrata("TOOLTIP")
		return message(L.FAQ.error["Выберите сообщение"])
	else
		if DB.curMessage == msg then
			DB.curMessage = 1
		elseif DB.curMessage > msg then
			DB.curMessage = DB.curMessage - 1
		end
		table.remove(DB.messageList, msg)
		defaultValues()
	end
end)
frame:SetPoint("LEFT", CustomizePost.save.frame, "RIGHT", 5, 0)
CustomizePost:AddChild(frame)

CustomizePost.frame:HookScript("OnShow", defaultValues)

CustomizePost.curMessage = GUI:Create("TLabel")
local frame = CustomizePost.curMessage
-- frame:SetText(format(L.interface["Предпросмотр: %s"], ''))
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
