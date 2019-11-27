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

local gratitudeFrame, scrollBar, mainFrame, inviteTypeGRP, mainCheckBoxGRP, searchRangeGRP, mainButtonsGRP



local function btnText(frame)
	local text = frame.text
	text:ClearAllPoints()
	text:SetPoint("TOPLEFT", 5, -1)
	text:SetPoint("BOTTOMRIGHT", -5, 1)
end


do		--	mainFrame
interface.mainFrame = GUI:Create("ClearFrame")
mainFrame = interface.mainFrame
mainFrame:SetTitle("Fast Guild Invite v."..addon.version)
mainFrame:SetWidth(size.mainFrameW)
mainFrame:SetHeight(size.mainFrameH)
mainFrame:SetLayout("List")

mainFrame.title:SetScript('OnMouseUp', function(mover)
	local frame = mover:GetParent()
	frame:StopMovingOrSizing()
	local self = frame.obj
	local status = self.status or self.localstatus
	status.width = frame:GetWidth()
	status.height = frame:GetHeight()
	status.top = frame:GetTop()
	status.left = frame:GetLeft()
	
	local point, relativeTo,relativePoint, xOfs, yOfs = mainFrame.frame:GetPoint(1)
	DB.global.mainFrame = {}
	DB.global.mainFrame.point=point
	DB.global.mainFrame.relativeTo=relativeTo
	DB.global.mainFrame.relativePoint=relativePoint
	DB.global.mainFrame.xOfs=xOfs
	DB.global.mainFrame.yOfs=yOfs
end)

mainFrame.closeButton = GUI:Create('Button')
local frame = mainFrame.closeButton
frame:SetText('X')
frame:SetWidth(frame.frame:GetHeight())
fn:closeBtn(frame)
frame:SetCallback('OnClick', function()
	interface.mainFrame:Hide()
end)
mainFrame:AddChild(frame)



do		--	inviteTypeGRP
mainFrame.inviteTypeGRP = GUI:Create("GroupFrame")
inviteTypeGRP = mainFrame.inviteTypeGRP
inviteTypeGRP:SetLayout("List")
inviteTypeGRP:SetHeight(50)
inviteTypeGRP:SetWidth(size.inviteTypeGRP)
mainFrame:AddChild(inviteTypeGRP)

inviteTypeGRP.inviteType = GUI:Create("TLabel")
local frame = inviteTypeGRP.inviteType
frame:SetText(L["Режим приглашения"])
fontSize(frame.label)
frame.label:SetJustifyH("CENTER")
frame:SetWidth(size.inviteTypeGRP)
inviteTypeGRP:AddChild(frame)

inviteTypeGRP.drop = GUI:Create("Dropdown")
local frame = inviteTypeGRP.drop
frame:SetWidth(size.inviteTypeGRP)
-- frame:SetList(L.invType)
frame:SetList({L["Только пригласить"], L["Отправить сообщение и пригласить"], L["Только сообщение"], L["Сообщение, если приглашение отклонено"],})
frame:SetValue(1)
frame:SetCallback("OnValueChanged", function(key)
	DB.global.inviteType = inviteTypeGRP.drop:GetValue()
end)
inviteTypeGRP:AddChild(frame)
end


do		--	mainCheckBoxGRP
mainFrame.mainCheckBoxGRP = GUI:Create("GroupFrame")
mainCheckBoxGRP = mainFrame.mainCheckBoxGRP
mainCheckBoxGRP:SetLayout("List")
mainCheckBoxGRP:SetHeight(120)
mainCheckBoxGRP:SetWidth(size.mainCheckBoxGRP)
mainFrame:AddChild(mainCheckBoxGRP)

mainCheckBoxGRP.customList = GUI:Create("TCheckBox")
local frame = mainCheckBoxGRP.customList
frame:SetWidth(size.customListBtn)
frame:SetLabel(L["Пользовательский список"])
frame:SetTooltip(L["Использовать пользовательский список запросов"])
-- fontSize(frame.text)
frame.frame:HookScript("OnClick", function()
	DB.realm.customWho = mainCheckBoxGRP.customList:GetValue()
end)
mainCheckBoxGRP:AddChild(frame)

--[[mainCheckBoxGRP.backgroundRun = GUI:Create("TCheckBox")
local frame = mainCheckBoxGRP.backgroundRun
frame:SetWidth(size.backgroundRun)
frame:SetLabel(L["Запускать в фоновом режиме"])
frame:SetTooltip(L["Запускать поиск в фоновом режиме"])
-- fontSize(frame.text)
frame.frame:HookScript("OnClick", function()
	DB.backgroundRun = mainCheckBoxGRP.backgroundRun:GetValue()
end)
mainCheckBoxGRP:AddChild(frame)]]

mainCheckBoxGRP.enableFilters = GUI:Create("TCheckBox")
local frame = mainCheckBoxGRP.enableFilters
frame:SetWidth(size.enableFilters)
frame:SetLabel(L["Включить фильтры"])
frame:SetTooltip("")
-- fontSize(frame.text)
frame.frame:HookScript("OnClick", function()
	DB.realm.enableFilters = mainCheckBoxGRP.enableFilters:GetValue()
end)
mainCheckBoxGRP:AddChild(frame)
end


do		--	mainButtonsGRP
mainFrame.mainButtonsGRP = GUI:Create("GroupFrame")
mainButtonsGRP = mainFrame.mainButtonsGRP
mainButtonsGRP:SetLayout("Flow")
mainButtonsGRP:SetHeight(80)
mainButtonsGRP:SetWidth(size.mainFrameW-20)
-- mainButtonsGRP:SetWidth(size.mainButtonsGRP)
mainFrame:AddChild(mainButtonsGRP)

mainButtonsGRP.startScan = GUI:Create("Button")
local frame = mainButtonsGRP.startScan
frame:SetText(L["Начать сканирование"])
-- fontSize(frame.text)
btnText(frame)
frame:SetWidth(size.startScan)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	if not fn:inGuildCanInvite() then return print(L["Вы не состоите в гильдии или у вас нет прав для приглашения."]) end
	interface.scanFrame:Show()
	interface.scanFrame.pausePlay.frame:Click()
end)
mainButtonsGRP:AddChild(frame)

mainButtonsGRP.chooseInvites = GUI:Create("Button")
local frame = mainButtonsGRP.chooseInvites
frame:SetText(L["Выбрать приглашения"])
-- fontSize(frame.text)
btnText(frame)
frame:SetWidth(size.chooseInvites)
frame:SetHeight(mainButtonsGRP.startScan.frame:GetHeight())
frame:SetCallback("OnClick", function() interface.chooseInvites:Show() end)
mainButtonsGRP:AddChild(frame)

mainButtonsGRP.settingsBtn = GUI:Create("Button")
local frame = mainButtonsGRP.settingsBtn
frame:SetText(L["Настройки"])
-- fontSize(frame.text)
btnText(frame)
frame:SetWidth(size.settingsBtn)
frame:SetHeight(mainButtonsGRP.startScan.frame:GetHeight())
frame.frame:SetScript("OnClick", function()
	--interface.settingsFrame:Show()
	InterfaceOptionsFrame_OpenToCategory(interface.settings)
	InterfaceOptionsFrame_OpenToCategory(interface.settings.Blacklist)
	InterfaceOptionsFrame_OpenToCategory(interface.settings)
	interface.mainFrame:Hide()
end)
mainButtonsGRP:AddChild(frame)
end


do		--	searchRangeGRP
mainFrame.searchRangeGRP = GUI:Create("GroupFrame")
searchRangeGRP = mainFrame.searchRangeGRP
searchRangeGRP:SetLayout("List")
searchRangeGRP:SetHeight(50)
searchRangeGRP:SetWidth(size.searchRangeGRP)
mainFrame:AddChild(searchRangeGRP)

searchRangeGRP.lvlRange = GUI:Create("TLabel")
local frame = searchRangeGRP.lvlRange
frame:SetText(L["Диапазон уровней"])
fontSize(frame.label)
frame:SetWidth(size.lvlRange)
frame.label:SetJustifyH("CENTER")
searchRangeGRP:AddChild(frame)

searchRangeGRP.lvlRangeMin = GUI:Create("TLabel")
local frame = searchRangeGRP.lvlRangeMin
frame:SetText(FGI_MINLVL)
fontSize(frame.label)
frame.label:SetJustifyH("RIGHT")
frame:SetWidth(30)
frame.frame:SetScript("OnMouseWheel",function(self,delta)
	local mod = IsShiftKeyDown() and 5 or 1
	if delta > 0 then
		DB.global.lowLimit = math.min(DB.global.highLimit, DB.global.lowLimit + mod)
	else
		DB.global.lowLimit = math.max(FGI_MINLVL, DB.global.lowLimit - mod)
	end
	searchRangeGRP.lvlRangeMin:SetText(DB.global.lowLimit)
end)
searchRangeGRP:AddChild(frame)

searchRangeGRP.lvlRangeLine = GUI:Create("TLabel")
local frame = searchRangeGRP.lvlRangeLine
frame:SetText('-')
frame.label:SetJustifyH("CENTER")
fontSize(frame.label)
frame:SetWidth(15)
searchRangeGRP:AddChild(frame)

searchRangeGRP.lvlRangeMax = GUI:Create("TLabel")
local frame = searchRangeGRP.lvlRangeMax
frame:SetText(FGI_MAXLVL)
frame.label:SetJustifyH("LEFT")
frame:SetWidth(searchRangeGRP.lvlRangeMin.frame:GetWidth())
fontSize(frame.label)
frame.frame:SetScript("OnMouseWheel",function(self,delta)
	local mod = IsShiftKeyDown() and 5 or 1
	if delta > 0 then
		DB.global.highLimit = math.min(FGI_MAXLVL, DB.global.highLimit + mod)
	else
		DB.global.highLimit = math.max(DB.global.lowLimit, DB.global.highLimit - mod)
	end
	searchRangeGRP.lvlRangeMax:SetText(DB.global.highLimit)
end)
searchRangeGRP:AddChild(frame)


mainFrame.searchInfo = GUI:Create("TLabel")
local frame = mainFrame.searchInfo
frame:SetWidth(350)
frame.label:SetJustifyH("LEFT")
fontSize(frame.label, nil, 12)
frame.placeholder = [[Statistics.
Total unique players found: %d
Invitations sent: %d
Invitations accepted: %d
Players Filtered by Custom Filters: %d
]]
frame.update = function(t)
	local unique, sended , invited, filtered = unpack(t)
	frame:SetText(format(frame.placeholder, unique, sended , invited, filtered))
end
mainFrame:AddChild(frame)
end


mainFrame.wheelHint = GUI:Create("TLabel")
local frame = mainFrame.wheelHint
frame:SetText(L["Для изменения значений используйте колесо мыши"])
fontSize(frame.label)
frame:SetWidth(size.wheelHint)
frame.label:SetJustifyH("CENTER")
mainFrame:AddChild(frame)
end


-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB
	if DB.global.mainFrame then
		interface.mainFrame:ClearAllPoints()
		interface.mainFrame:SetPoint(DB.global.mainFrame.point, UIParent, DB.global.mainFrame.relativePoint, DB.global.mainFrame.xOfs, DB.global.mainFrame.yOfs)
	else
		interface.mainFrame:SetPoint("CENTER", UIParent)
	end
	
	C_Timer.After(0.1, function()
	inviteTypeGRP.drop:SetValue(DB.global.inviteType)
	
	mainCheckBoxGRP.customList:SetValue(DB.realm.customWho or false)
	-- mainCheckBoxGRP.backgroundRun:SetValue(DB.backgroundRun or false)
	mainCheckBoxGRP.enableFilters:SetValue(DB.realm.enableFilters or false)
	
	searchRangeGRP.lvlRangeMin:SetText(DB.global.lowLimit)
	searchRangeGRP.lvlRangeMax:SetText(DB.global.highLimit)
	
	
	
	
	
	mainFrame.closeButton:ClearAllPoints()
	mainFrame.closeButton:SetPoint("CENTER", mainFrame.frame, "TOPRIGHT", -8, -8)
	
	inviteTypeGRP:ClearAllPoints()
	inviteTypeGRP:SetPoint("TOPLEFT", mainFrame.frame, "TOPLEFT", 20, -40)
	
	inviteTypeGRP.inviteType:ClearAllPoints()
	inviteTypeGRP.inviteType:SetPoint("TOPLEFT", inviteTypeGRP.frame, "TOPLEFT", 0, 0)
	
	mainCheckBoxGRP:ClearAllPoints()
	mainCheckBoxGRP:SetPoint("TOPLEFT", inviteTypeGRP.frame, "BOTTOMLEFT", 0, -20)
	
	mainCheckBoxGRP.customList:ClearAllPoints()
	mainCheckBoxGRP.customList:SetPoint("TOPLEFT", mainCheckBoxGRP.frame, "TOPLEFT", 0, 0)
	
	mainFrame.wheelHint:ClearAllPoints()
	mainFrame.wheelHint:SetPoint("TOPLEFT", inviteTypeGRP.frame, "TOPRIGHT", 15, 0)
	
	searchRangeGRP:ClearAllPoints()
	searchRangeGRP:SetPoint("TOPLEFT", mainFrame.wheelHint.frame, "BOTTOMLEFT", 0, -10)
	
	searchRangeGRP.lvlRange:ClearAllPoints()
	searchRangeGRP.lvlRange:SetPoint("TOPLEFT", searchRangeGRP.frame, "TOPLEFT", 0, 0)
	
	searchRangeGRP.lvlRangeLine:ClearAllPoints()
	searchRangeGRP.lvlRangeLine:SetPoint("TOP", searchRangeGRP.lvlRange.frame, "BOTTOM", 0, -10)
	
	searchRangeGRP.lvlRangeMin:ClearAllPoints()
	searchRangeGRP.lvlRangeMin:SetPoint("RIGHT", searchRangeGRP.lvlRangeLine.frame, "LEFT", 0, 0)
	
	searchRangeGRP.lvlRangeMax:ClearAllPoints()
	searchRangeGRP.lvlRangeMax:SetPoint("LEFT", searchRangeGRP.lvlRangeLine.frame, "RIGHT", 0, 0)
	
	mainFrame.searchInfo:ClearAllPoints()
	mainFrame.searchInfo:SetPoint("BOTTOMRIGHT", mainButtonsGRP.frame, "TOPRIGHT", 0, 0)
	
	mainButtonsGRP:ClearAllPoints()
	mainButtonsGRP:SetPoint("TOPLEFT", mainCheckBoxGRP.frame, "BOTTOMLEFT", 0, -10)
	
	mainButtonsGRP.startScan:ClearAllPoints()
	mainButtonsGRP.startScan:SetPoint("TOPLEFT", mainButtonsGRP.frame, "TOPLEFT", 0, 0)
	
	mainButtonsGRP.chooseInvites:ClearAllPoints()
	mainButtonsGRP.chooseInvites:SetPoint("LEFT", mainButtonsGRP.startScan.frame, "RIGHT", 2, 0)
	
	mainButtonsGRP.settingsBtn:ClearAllPoints()
	mainButtonsGRP.settingsBtn:SetPoint("LEFT", mainButtonsGRP.chooseInvites.frame, "RIGHT", 2, 0)
	
	
	
	mainFrame:Hide()
	-- gratitudeFrame:Hide()
	end)
end)
