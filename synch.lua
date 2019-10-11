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

local synch, leftColumn, rightColumn

local function btnText(frame)
	local text = frame.text
	text:ClearAllPoints()
	text:SetPoint("TOPLEFT", 5, -1)
	text:SetPoint("BOTTOMRIGHT", -5, 1)
end

local w,h = 623, 568
interface.settings.Synchronization.content = GUI:Create("SimpleGroup")
synch = interface.settings.Synchronization.content
synch:SetWidth(w-20)
synch:SetHeight(h-20)
synch.frame:SetParent(interface.settings.Synchronization)
synch:SetLayout("NIL")
synch:SetPoint("TOPLEFT", interface.settings.Synchronization, "TOPLEFT", 10, -10)

do		-- left col
synch.leftColumn = GUI:Create("SimpleGroup")
leftColumn = synch.leftColumn
leftColumn:SetWidth((size.synchFrameW-20)/2)
leftColumn:SetHeight(100)
leftColumn:SetLayout("NIL")
leftColumn:SetPoint("TOPLEFT", synch.frame, "TOPLEFT", 0, 0)
synch:AddChild(leftColumn)

leftColumn.synchTypeLabel = GUI:Create("TLabel")
local frame = leftColumn.synchTypeLabel
frame:SetText(L["Данные для синхронизации"])
fontSize(frame.label)
frame.label:SetJustifyH("CENTER")
frame:SetWidth(leftColumn.frame:GetWidth()-20)
frame:SetPoint("TOPLEFT", leftColumn.frame, "TOPLEFT", 0, 0)
leftColumn:AddChild(frame)

leftColumn.synchTypeDrop = GUI:Create("Dropdown")
local frame = leftColumn.synchTypeDrop
frame:SetWidth(leftColumn.frame:GetWidth()-20)
frame:SetList({L.synchType[1], L.synchType[2],})
frame:SetValue(1)
frame:SetPoint("TOPLEFT", leftColumn.synchTypeLabel.frame, "BOTTOMLEFT", 0, 0)
leftColumn:AddChild(frame)
end

do		--right col
synch.rightColumn = GUI:Create("SimpleGroup")
rightColumn = synch.rightColumn
rightColumn:SetWidth((size.synchFrameW-20)/2)
rightColumn:SetHeight(100)
rightColumn:SetLayout("NIL")
rightColumn:SetPoint("TOPRIGHT", synch.frame, "TOPRIGHT", 0, 0)
synch:AddChild(rightColumn)

rightColumn.synchPlayerReadyLabel = GUI:Create("TLabel")
local frame = rightColumn.synchPlayerReadyLabel
frame:SetText(L["Игрок для синхронизации"])
fontSize(frame.label)
frame.label:SetJustifyH("CENTER")
frame:SetWidth(rightColumn.frame:GetWidth()-20)
frame:SetPoint("TOPLEFT", rightColumn.frame, "TOPLEFT", 0, 0)
rightColumn:AddChild(frame)

rightColumn.synchPlayerReadyDrop = GUI:Create("Dropdown")
local frame = rightColumn.synchPlayerReadyDrop
frame:SetWidth(rightColumn.frame:GetWidth()-20)
frame:SetList({L["Все"]})
frame:SetValue(1)
frame:SetPoint("TOPLEFT", rightColumn.synchPlayerReadyLabel.frame, "BOTTOMLEFT", 0, 0)
rightColumn:AddChild(frame)
end


synch.sendRequest = GUI:Create("Button")
local frame = synch.sendRequest
frame:SetText(L["Отправить запрос"])
-- fontSize(frame.text)
btnText(frame)
frame:SetWidth(size.sendRequest)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	synch.infoLabel:SetText('')
	-- local type = leftColumn.synchTypeDrop.list[leftColumn.synchTypeDrop:GetValue()]
	local type = leftColumn.synchTypeDrop:GetValue()
	local player = rightColumn.synchPlayerReadyDrop--:GetValue()==1 and (not true) or rightColumn.synchPlayerReadyDrop.list[rightColumn.synchPlayerReadyDrop:GetValue()]
	local playerName = player.list[player:GetValue()]
	if type == nil or L.synchType[type] == nil then
		synch.infoLabel:Error(L["Данные для синхронизации не выбраны"])
		return
	end
	if player == nil then
		synch.infoLabel:Error(L["Игрок для синхронизации не выбран"])
		return
	end
	synch.infoLabel:During(format(L["Запрос синхронизации у: %s. %d"], playerName, FGI_MAXSYNCHWAIT))
	
	fn:sendSynchRequest(playerName, type)
end)
frame:SetPoint("TOP", synch.frame, "TOP", 0, -(rightColumn.frame:GetHeight()+20))
synch:AddChild(frame)


synch.infoLabel = GUI:Create("TLabel")
local frame = synch.infoLabel
-- frame:SetText(L["Отправить запрос"])
fontSize(frame.label)
frame.label:SetJustifyH("CENTER")
frame:SetWidth(synch.frame:GetWidth()-20)
frame:SetPoint("TOP", synch.sendRequest.frame, "BOTTOM", 0, -5)
synch:AddChild(frame)

function frame.Error(self, text)
	self:SetText(format("%s%s|r",color.red, text))
end
function frame.During(self, text)
	self:SetText(format("%s%s|r",color.yellow, text))
end
function frame.Success(self, text)
	self:SetText(format("%s%s|r",color.green, text))
end



interface.confirmSending = GUI:Create("ClearFrame")
confirmSending = interface.confirmSending
confirmSending:SetTitle("Sync confirmation")
confirmSending:SetLayout("NIL")
confirmSending:SetWidth(250)
confirmSending:SetHeight(140)
confirmSending:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
confirmSending.NewConfirm = function(_, fn, name, sType)
	if type(fn) ~= 'function' or type(name) ~= 'string' or type(sType) ~= 'string' then return print("Use NewConfirm(function, playerName, dataStr)") end
	confirmSending.callback = fn
	confirmSending.infoLabel:SetText(format(confirmSending.infoLabel.placeholder, name, sType))
	confirmSending:Show()
end

confirmSending.infoLabel = GUI:Create("TLabel")
local frame = confirmSending.infoLabel
confirmSending:Hide()
frame.placeholder = L[ [=[Игрок %s хочет синхронизировать %s.
Разрешить?]=] ]
fontSize(frame.label)
frame.label:SetJustifyH("CENTER")
frame:SetWidth(confirmSending.frame:GetWidth()-20)
frame:SetPoint("TOP", confirmSending.frame, "TOP", 0, -25)
confirmSending:AddChild(frame)

confirmSending.YES = GUI:Create("Button")
local frame = confirmSending.YES
frame:SetText(L["Да"])
btnText(frame)
frame:SetWidth(size.sendRequest)
frame:SetHeight(40)
frame:SetWidth(60)
frame:SetCallback("OnClick", function()
	if type(confirmSending.callback) == 'function' then
		confirmSending.callback()
	end
	confirmSending:Hide()
	confirmSending.callback = nil
end)
frame:SetPoint("BOTTOMLEFT", confirmSending.frame, "BOTTOMLEFT", 10, 10)
confirmSending:AddChild(frame)

confirmSending.NO = GUI:Create("Button")
local frame = confirmSending.NO
frame:SetText(L["Нет"])
btnText(frame)
frame:SetWidth(size.sendRequest)
frame:SetHeight(40)
frame:SetWidth(70)
frame:SetCallback("OnClick", function()
	confirmSending:Hide()
	confirmSending.callback = nil
end)
frame:SetPoint("BOTTOMRIGHT", confirmSending.frame, "BOTTOMRIGHT", -10, 10)
confirmSending:AddChild(frame)



-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB
end)
