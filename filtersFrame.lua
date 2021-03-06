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

local filtersFrame, addfilterFrame

--[[-------------------------------------------------------------------------------------
								UNIQUE FOR RETAIL VERSION
]]---------------------------------------------------------------------------------------
local function defaultValues()
	local addfilterFrame = interface.addfilterFrame
	
	addfilterFrame.classesCheckBoxDruid:SetValue(false)
	addfilterFrame.classesCheckBoxHunter:SetValue(false)
	addfilterFrame.classesCheckBoxMage:SetValue(false)
	addfilterFrame.classesCheckBoxPaladin:SetValue(false)
	addfilterFrame.classesCheckBoxPriest:SetValue(false)
	addfilterFrame.classesCheckBoxRogue:SetValue(false)
	addfilterFrame.classesCheckBoxShaman:SetValue(false)
	addfilterFrame.classesCheckBoxWarlock:SetValue(false)
	addfilterFrame.classesCheckBoxWarrior:SetValue(false)
	addfilterFrame.classesCheckBoxDeathKnight:SetValue(false)
	addfilterFrame.classesCheckBoxDemonHunter:SetValue(false)
	addfilterFrame.classesCheckBoxMonk:SetValue(false)
	addfilterFrame.classesCheckBoxDeathKnight:Hide()
	addfilterFrame.classesCheckBoxDemonHunter:Hide()
	addfilterFrame.classesCheckBoxMonk:Hide()
	addfilterFrame.classesCheckBoxDruid:Hide()
	addfilterFrame.classesCheckBoxHunter:Hide()
	addfilterFrame.classesCheckBoxMage:Hide()
	addfilterFrame.classesCheckBoxPaladin:Hide()
	addfilterFrame.classesCheckBoxPriest:Hide()
	addfilterFrame.classesCheckBoxRogue:Hide()
	addfilterFrame.classesCheckBoxShaman:Hide()
	addfilterFrame.classesCheckBoxWarlock:Hide()
	addfilterFrame.classesCheckBoxWarrior:Hide()
	addfilterFrame.classesCheckBoxIgnore:SetValue(true)
	
	for i=1,#addfilterFrame.rasesCheckBoxRace do
		addfilterFrame.rasesCheckBoxRace[i]:SetValue(false)
		addfilterFrame.rasesCheckBoxRace[i]:Hide()
	end
	addfilterFrame.rasesCheckBoxIgnore:SetValue(true)
	
	addfilterFrame.filterNameEdit:SetText('')
	addfilterFrame.filterNameEdit:SetDisabled(false)
	addfilterFrame.excludeNameEditBox:SetText('')
	addfilterFrame.lvlRangeEditBox:SetText('')
	addfilterFrame.excludeRepeatEditBox:SetText('')
	
	addfilterFrame.change = false
end

function fn:classIgnoredToggle()
	local value = addfilterFrame.classesCheckBoxIgnore:GetValue()
	if not value then
		addfilterFrame.classesCheckBoxDeathKnight:Show()
		addfilterFrame.classesCheckBoxDemonHunter:Show()
		addfilterFrame.classesCheckBoxMonk:Show()
		addfilterFrame.classesCheckBoxDruid:Show()
		addfilterFrame.classesCheckBoxHunter:Show()
		addfilterFrame.classesCheckBoxMage:Show()
		addfilterFrame.classesCheckBoxPaladin:Show()
		addfilterFrame.classesCheckBoxPriest:Show()
		addfilterFrame.classesCheckBoxRogue:Show()
		addfilterFrame.classesCheckBoxShaman:Show()
		addfilterFrame.classesCheckBoxWarlock:Show()
		addfilterFrame.classesCheckBoxWarrior:Show()
	else
		addfilterFrame.classesCheckBoxDeathKnight:Hide()
		addfilterFrame.classesCheckBoxDemonHunter:Hide()
		addfilterFrame.classesCheckBoxMonk:Hide()
		addfilterFrame.classesCheckBoxDruid:Hide()
		addfilterFrame.classesCheckBoxHunter:Hide()
		addfilterFrame.classesCheckBoxMage:Hide()
		addfilterFrame.classesCheckBoxPaladin:Hide()
		addfilterFrame.classesCheckBoxPriest:Hide()
		addfilterFrame.classesCheckBoxRogue:Hide()
		addfilterFrame.classesCheckBoxShaman:Hide()
		addfilterFrame.classesCheckBoxWarlock:Hide()
		addfilterFrame.classesCheckBoxWarrior:Hide()
	end
end

local function classFilter()
	arr = {
		[L.SYSTEM.class.DeathKnight] = addfilterFrame.classesCheckBoxDeathKnight:GetValue() or nil,
		[L.SYSTEM.class.DemonHunter] = addfilterFrame.classesCheckBoxDemonHunter:GetValue() or nil,
		[L.SYSTEM.class.Monk] = addfilterFrame.classesCheckBoxMonk:GetValue() or nil,
		[L.SYSTEM.class.Druid] = addfilterFrame.classesCheckBoxDruid:GetValue() or nil,
		[L.SYSTEM.class.Hunter] = addfilterFrame.classesCheckBoxHunter:GetValue() or nil,
		[L.SYSTEM.class.Mage] = addfilterFrame.classesCheckBoxMage:GetValue() or nil,
		[L.SYSTEM.class.Paladin] = addfilterFrame.classesCheckBoxPaladin:GetValue() or nil,
		[L.SYSTEM.class.Priest] = addfilterFrame.classesCheckBoxPriest:GetValue() or nil,
		[L.SYSTEM.class.Rogue] = addfilterFrame.classesCheckBoxRogue:GetValue() or nil,
		[L.SYSTEM.class.Shaman] = addfilterFrame.classesCheckBoxShaman:GetValue() or nil,
		[L.SYSTEM.class.Warlock] = addfilterFrame.classesCheckBoxWarlock:GetValue() or nil,
		[L.SYSTEM.class.Warrior] = addfilterFrame.classesCheckBoxWarrior:GetValue() or nil
	}
	return arr
end

local function createClassBoxes()
addfilterFrame.classesCheckBoxDeathKnight = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxDeathKnight
frame:SetWidth(size.DeathKnight)
frame:SetLabel(L.SYSTEM.class.DeathKnight)
fontSize(frame.text)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxDemonHunter = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxDemonHunter
frame:SetWidth(size.DemonHunter)
frame:SetLabel(L.SYSTEM.class.DemonHunter)
fontSize(frame.text)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxMonk = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxMonk
frame:SetWidth(size.Monk)
frame:SetLabel(L.SYSTEM.class.Monk)
fontSize(frame.text)
addfilterFrame:AddChild(frame)



addfilterFrame.classesCheckBoxDruid = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxDruid
frame:SetWidth(size.Druid)
frame:SetLabel(L.SYSTEM.class.Druid)
fontSize(frame.text)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxHunter = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxHunter
frame:SetWidth(size.Hunter)
frame:SetLabel(L.SYSTEM.class.Hunter)
fontSize(frame.text)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxMage = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxMage
frame:SetWidth(size.Mage)
frame:SetLabel(L.SYSTEM.class.Mage)
fontSize(frame.text)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxPaladin = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxPaladin
frame:SetWidth(size.Paladin)
frame:SetLabel(L.SYSTEM.class.Paladin)
fontSize(frame.text)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxPriest = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxPriest
frame:SetWidth(size.Priest)
frame:SetLabel(L.SYSTEM.class.Priest)
fontSize(frame.text)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxRogue = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxRogue
frame:SetWidth(size.Rogue)
frame:SetLabel(L.SYSTEM.class.Rogue)
fontSize(frame.text)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxShaman = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxShaman
frame:SetWidth(size.Shaman)
frame:SetLabel(L.SYSTEM.class.Shaman)
fontSize(frame.text)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxWarlock = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxWarlock
frame:SetWidth(size.Warlock)
frame:SetLabel(L.SYSTEM.class.Warlock)
fontSize(frame.text)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxWarrior = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxWarrior
frame:SetWidth(size.Warrior)
frame:SetLabel(L.SYSTEM.class.Warrior)
fontSize(frame.text)
addfilterFrame:AddChild(frame)
end
--[[-------------------------------------------------------------------------------------
							/	UNIQUE FOR RETAIL VERSION
]]---------------------------------------------------------------------------------------

local function btnText(frame)
	local text = frame.text
	text:ClearAllPoints()
	text:SetPoint("TOPLEFT", 5, -1)
	text:SetPoint("BOTTOMRIGHT", -5, 1)
end


do		--filtersFrame
interface.filtersFrame = GUI:Create("ClearFrame")
filtersFrame = interface.filtersFrame
filtersFrame:SetTitle("FGI Filters")
filtersFrame:SetWidth(size.filtersFrameW)
filtersFrame:SetHeight(size.filtersFrameH)
filtersFrame:SetLayout("Flow")

filtersFrame.title:SetScript('OnMouseUp', function(mover)
	local frame = mover:GetParent()
	frame:StopMovingOrSizing()
	local self = frame.obj
	local status = self.status or self.localstatus
	status.width = frame:GetWidth()
	status.height = frame:GetHeight()
	status.top = frame:GetTop()
	status.left = frame:GetLeft()
	
	local point, relativeTo,relativePoint, xOfs, yOfs = filtersFrame.frame:GetPoint(1)
	DB.filtersFrame = {}
	DB.filtersFrame.point=point
	DB.filtersFrame.relativeTo=relativeTo
	DB.filtersFrame.relativePoint=relativePoint
	DB.filtersFrame.xOfs=xOfs
	DB.filtersFrame.yOfs=yOfs
end)

filtersFrame.closeButton = GUI:Create('Button')
local frame = filtersFrame.closeButton
frame:SetText('X')
frame:SetWidth(frame.frame:GetHeight())
fn:closeBtn(frame)
frame:SetCallback('OnClick', function()
	interface.filtersFrame:Hide()
	interface.settingsFrame:Show()
end)
filtersFrame:AddChild(frame)




filtersFrame.head = GUI:Create("TLabel")
local frame = filtersFrame.head
frame:SetText(L.interface["?????????????? ???? ???????????? ?????? ?????????????????? ??????????????????"])
fontSize(frame.label)
frame:SetWidth(filtersFrame.frame:GetWidth())
frame.label:SetJustifyH("CENTER")
filtersFrame:AddChild(frame)



filtersFrame.filterList = {}



filtersFrame.addFilter = GUI:Create("Button")
local frame = filtersFrame.addFilter
frame:SetText(L.interface["???????????????? ????????????"])
fontSize(frame.text)
btnText(frame)
frame:SetWidth(size.addFilter)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	local filters = 0
	for k,v in pairs(DB.filtersList) do
		filters = filters + 1
	end
	if filters >= FGI_FILTERSLIMIT then
		BasicMessageDialog:SetFrameStrata("TOOLTIP")
		return message(format(L.FAQ.error["???????????????????????? ???????????????????? ???????????????? %s. ???????????????????? ???????????????? ?????? ?????????????? ?????????????????? ????????????."], FGI_FILTERSLIMIT))
	end
	interface.addfilterFrame:Show()
	interface.filtersFrame:Hide()
end)
filtersFrame:AddChild(frame)
end



do		--addfilterFrame
interface.addfilterFrame = GUI:Create("ClearFrame")
addfilterFrame = interface.addfilterFrame
addfilterFrame:SetTitle("FGI add new filter")
addfilterFrame:SetWidth(size.addfilterFrameW)
addfilterFrame:SetHeight(size.addfilterFrameH)

addfilterFrame.title:SetScript('OnMouseUp', function(mover)
	local frame = mover:GetParent()
	frame:StopMovingOrSizing()
	local self = frame.obj
	local status = self.status or self.localstatus
	status.width = frame:GetWidth()
	status.height = frame:GetHeight()
	status.top = frame:GetTop()
	status.left = frame:GetLeft()
	
	local point, relativeTo,relativePoint, xOfs, yOfs = addfilterFrame.frame:GetPoint(1)
	DB.addfilterFrame = {}
	DB.addfilterFrame.point=point
	DB.addfilterFrame.relativeTo=relativeTo
	DB.addfilterFrame.relativePoint=relativePoint
	DB.addfilterFrame.xOfs=xOfs
	DB.addfilterFrame.yOfs=yOfs
end)

addfilterFrame.closeButton = GUI:Create('Button')
local frame = addfilterFrame.closeButton
frame:SetText('X')
frame:SetWidth(frame.frame:GetHeight())
fn:closeBtn(frame)
frame:SetCallback('OnClick', function()
	interface.addfilterFrame:Hide()
	interface.filtersFrame:Show()
end)
addfilterFrame:AddChild(frame)




addfilterFrame.topHint = GUI:Create("TLabel")
local frame = addfilterFrame.topHint
frame:SetText(L.interface["???????????????????????? ???????? \"?????? ??????????????\", ???????????? ?????????????????? ???????? ???? ???????????????????????? ?????? ????????????????????."])
fontSize(frame.label)
frame:SetWidth(addfilterFrame.frame:GetWidth()-20)
frame.label:SetJustifyH("CENTER")
addfilterFrame:AddChild(frame)



do		--class
addfilterFrame.classLabel = GUI:Create("TLabel")
local frame = addfilterFrame.classLabel
frame:SetText(L.interface["????????????:"])
fontSize(frame.label)
frame:SetWidth(size.classLabel)
frame.label:SetJustifyH("CENTER")
addfilterFrame:AddChild(frame)


addfilterFrame.classesCheckBoxIgnore = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxIgnore
frame:SetWidth(size.Ignore)
frame:SetLabel(L.interface["????????????????????????"])
fontSize(frame.text)
frame:SetCallback("OnValueChanged", function() fn:classIgnoredToggle() end)
addfilterFrame:AddChild(frame)


createClassBoxes()
end



do		--race
addfilterFrame.raceLabel = GUI:Create("TLabel")
local frame = addfilterFrame.raceLabel
frame:SetText(L.interface["????????:"])
fontSize(frame.label)
frame:SetWidth(size.raceLabel)
frame.label:SetJustifyH("CENTER")
addfilterFrame:AddChild(frame)

function fn:racesIgnoredToggle()
	local value = addfilterFrame.rasesCheckBoxIgnore:GetValue()
	for i=1,#addfilterFrame.rasesCheckBoxRace do
		if not value then
			addfilterFrame.rasesCheckBoxRace[i]:Show()
		else
			addfilterFrame.rasesCheckBoxRace[i]:Hide()
		end
	end
end

addfilterFrame.rasesCheckBoxIgnore = GUI:Create("TCheckBox")
local frame = addfilterFrame.rasesCheckBoxIgnore
frame:SetWidth(size.Ignore)
frame:SetLabel(L.interface["????????????????????????"])
fontSize(frame.text)
frame:SetCallback("OnValueChanged", function() fn:racesIgnoredToggle() end)
addfilterFrame:AddChild(frame)


addfilterFrame.rasesCheckBoxRace = {}
for k,v in pairs(L.SYSTEM.race) do
	local i = #addfilterFrame.rasesCheckBoxRace+1
	addfilterFrame.rasesCheckBoxRace[i] = GUI:Create("TCheckBox")
	local frame = addfilterFrame.rasesCheckBoxRace[i]
	fontSize(frame.text)
	addfilterFrame:AddChild(frame)
end
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

addfilterFrame.filterNameLabel = GUI:Create("TLabel")
local frame = addfilterFrame.filterNameLabel
frame:SetText(L.interface["?????? ??????????????"])
fontSize(frame.label)
frame:SetWidth(size.filterNameLabel)
frame.label:SetJustifyH("CENTER")
addfilterFrame:AddChild(frame)

addfilterFrame.filterNameEdit = GUI:Create("EditBox")
local frame = addfilterFrame.filterNameEdit
frame:SetWidth(size.filtersEdit)
EditBoxChange(frame)
addfilterFrame:AddChild(frame)

addfilterFrame.excludeNameLabel = GUI:Create("TLabel")
local frame = addfilterFrame.excludeNameLabel
frame:SetText(L.interface["???????????? ???? ??????????"])
frame:SetTooltip(L.interface.tooltip["???????? ?????? ???????????? ???????????????? ??????????????????\n??????????, ???? ???? ?????????? ???????????????? ?? ??????????????"])
fontSize(frame.label)
frame:SetWidth(size.excludeNameLabel)
frame.label:SetJustifyH("CENTER")
addfilterFrame:AddChild(frame)

addfilterFrame.excludeNameEditBox = GUI:Create("EditBox")
local frame = addfilterFrame.excludeNameEditBox
frame:SetWidth(size.filtersEdit)
EditBoxChange(frame)
addfilterFrame:AddChild(frame)

addfilterFrame.lvlRangeLabel = GUI:Create("TLabel")
local frame = addfilterFrame.lvlRangeLabel
frame:SetText(L.interface["???????????????? ?????????????? (??????:????????)"])
frame:SetTooltip(format(L.interface.tooltip["?????????????? ???????????????? ?????????????? ?????? ??????????????.\n????????????????: %s55%s:%s58%s\n?????????? ?????????????????? ???????????? ???? ????????????, ??????????????\n?????????????? ?????????????????????? ???? %s55%s ???? %s58%s (????????????????????????)"], "|cff00ff00", "|r", "|cff00A2FF", "|r", "|cff00ff00", "|r", "|cff00A2FF", "|r"))
fontSize(frame.label)
frame:SetWidth(size.lvlRangeLabel)
frame.label:SetJustifyH("CENTER")
addfilterFrame:AddChild(frame)

addfilterFrame.lvlRangeEditBox = GUI:Create("EditBox")
local frame = addfilterFrame.lvlRangeEditBox
frame:SetWidth(size.filtersEdit)
EditBoxChange(frame)
addfilterFrame:AddChild(frame)

addfilterFrame.excludeRepeatLabel = GUI:Create("TLabel")
local frame = addfilterFrame.excludeRepeatLabel
frame:SetText(L.interface["???????????? ???????????????????? ?? ??????????"])
frame:SetTooltip(format(L.interface.tooltip["?????????????? ???????????????????????? ???????????????????? ????????????????????????????????\n?????????????? ?? ??????????????????, ?????????????? ?????????? ?????????????????? ?????? ????????????.\n????????????????: %s3%s:%s5%s\n?????????? ????????????????, ?????? ???????????? ?? ?????????? ?????? %s3%s ???????????????? ????????????\n?????? ?????????? %s5%s ???????????????????? ???????????? ???? ?????????? ?????????????????? ?? ??????????????."], "|cff00ff00", "|r", "|cff00A2FF", "|r", "|cff00ff00", "|r", "|cff00A2FF", "|r"))
fontSize(frame.label)
frame:SetWidth(size.excludeRepeatLabel)
frame.label:SetJustifyH("CENTER")
addfilterFrame:AddChild(frame)

addfilterFrame.excludeRepeatEditBox = GUI:Create("EditBox")
local frame = addfilterFrame.excludeRepeatEditBox
frame:SetWidth(size.filtersEdit)
EditBoxChange(frame)
addfilterFrame:AddChild(frame)




local function saveFilter()
	local errors = {}
	local min, max
	
	local classIgnore, raceIgnore, filterName, filterByName, lvlRange, letterFilter =
	not addfilterFrame.classesCheckBoxIgnore:GetValue() and {} or false,
	not addfilterFrame.rasesCheckBoxIgnore:GetValue() and {} or false,
	addfilterFrame.filterNameEdit:GetText() ~= "" and addfilterFrame.filterNameEdit:GetText() or false,
	addfilterFrame.excludeNameEditBox:GetText() ~= "" and addfilterFrame.excludeNameEditBox:GetText() or false,
	addfilterFrame.lvlRangeEditBox:GetText() ~= "" and addfilterFrame.lvlRangeEditBox:GetText() or false,
	addfilterFrame.excludeRepeatEditBox:GetText() ~= "" and addfilterFrame.excludeRepeatEditBox:GetText() or false
	
	if not filterName then
		table.insert(errors, format("%s \n %s", L.interface["?????? ??????????????"], L.interface["?????? ?????????????? ???? ?????????? ???????? ????????????"]))
	elseif DB.filtersList[filterName] ~= nil and not addfilterFrame.change then
		table.insert(errors, format("%s \n %s", L.interface["?????? ??????????????"], L.interface["?????? ?????????????? ????????????"]))
	end
	
	if filterByName and not filterByName:find("^"..addon.ruReg.."+$") then
		table.insert(errors, format("%s \n %s", L.interface["???????????? ???? ??????????"], L.interface["???????? ?????????? ?????????????????? ???????????? ??????????"]))
	end
	if lvlRange then
		if lvlRange:find(("[\-]?%d+:[\-]?%d+")) then
			min, max = fn:split(lvlRange, ":", -1)
			if min <= 0 or max <= 0 or min > max then
				table.insert(errors, format("%s \n %s", L.interface["???????????????? ?????????????? (??????:????????)"], L.interface["?????????? ???? ?????????? ???????? ???????????? ?????? ?????????? 0. ?????????????????????? ?????????????? ???? ?????????? ???????? ???????????? ??????????????????????????"]))
			end
		else
			table.insert(errors, format("%s \n %s", L.interface["???????????????? ?????????????? (??????:????????)"], L.interface["???????????????????????? ????????????"]))
		end
	end
	if letterFilter then
		if letterFilter:find("[\-]?%d+:[\-]?%d+") then
			min, max = fn:split(letterFilter, ":")
			if min < 0 or max < 0 then
				table.insert(errors, format("%s \n %s", L.interface["???????????? ???????????????????? ?? ??????????"], L.interface["?????????? ???????????? ???????? ???????????? 0"]))
			end
		else
			table.insert(errors, format("%s \n %s", L.interface["???????????? ???????????????????? ?? ??????????"], L.interface["???????????????????????? ????????????"]))
		end
	end
	
	local classFilter = classIgnore
	if classFilter then
		classFilter = getClassFilter()
		classFilter = next(classFilter) ~= nil and classFilter or false
	end
	
	
	local raceFilter = raceIgnore
	if raceFilter then
		for i=1,#addfilterFrame.rasesCheckBoxRace do
			if addfilterFrame.rasesCheckBoxRace[i]:GetValue() then
				raceFilter[addfilterFrame.rasesCheckBoxRace[i]:GetLabel()] = true
			end
		end
		raceFilter = next(raceFilter) ~= nil and raceFilter or false
	end
		
	
	if #errors == 0 then
		interface.addfilterFrame:Hide()
		interface.filtersFrame:Show()
		DB.filtersList[filterName] = {
			filterByName = filterByName,
			lvlRange = lvlRange,
			letterFilter = letterFilter,
			classFilter = classFilter,
			raceFilter = raceFilter,
			filterOn = false,
			filteredCount = 0,
		}
		fn:FiltersUpdate()
	else
		BasicMessageDialog:SetFrameStrata("TOOLTIP")
		BasicMessageDialog.errorsList = errors
		if #errors > 1 then
			table.insert(errors, 1, format(L.interface["???????????????????? ????????????: %d"],#errors))
		end
		message(errors[1])
	end
end
BasicMessageDialogButton:HookScript("OnClick", function()
	if BasicMessageDialog.errorsList then
		table.remove(BasicMessageDialog.errorsList, 1)
		if #BasicMessageDialog.errorsList > 0 then
			message(BasicMessageDialog.errorsList[1])
		end
	end
end)




addfilterFrame.saveButton = GUI:Create('Button')
local frame = addfilterFrame.saveButton
frame:SetText(L.interface["??????????????????"])
fontSize(frame.text)
btnText(frame)
frame:SetWidth(size.saveButton)
frame:SetHeight(40)
frame:SetCallback('OnClick', saveFilter)
addfilterFrame:AddChild(frame)




addfilterFrame.bottomHint = GUI:Create("TLabel")
local frame = addfilterFrame.bottomHint
frame:SetText(L.interface["?????????? ???????? ??????????????????????????????, ?????????? ???????????? ?????????????????????????????? ?????????????????? ???????? ????????????????"])
fontSize(frame.label)
frame:SetWidth(addfilterFrame.frame:GetWidth()-20)
frame.label:SetJustifyH("CENTER")
addfilterFrame:AddChild(frame)




addfilterFrame.frame:HookScript("OnShow", defaultValues)


end

-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB
	if DB.filtersFrame then
		interface.filtersFrame:ClearAllPoints()
		interface.filtersFrame:SetPoint(DB.filtersFrame.point, UIParent, DB.filtersFrame.relativePoint, DB.filtersFrame.xOfs, DB.filtersFrame.yOfs)
	else
		interface.filtersFrame:SetPoint("CENTER", UIParent)
	end
	if DB.addfilterFrame then
		interface.addfilterFrame:ClearAllPoints()
		interface.addfilterFrame:SetPoint(DB.addfilterFrame.point, UIParent, DB.addfilterFrame.relativePoint, DB.addfilterFrame.xOfs, DB.addfilterFrame.yOfs)
	else
		interface.addfilterFrame:SetPoint("CENTER", UIParent)
	end
	
	
	local i = 1
	for k,v in pairs(L.SYSTEM.race) do
		local frame = addfilterFrame.rasesCheckBoxRace[i]
		frame:SetWidth(size[k])
		frame:SetLabel(v)
		i = i + 1
	end
	
	defaultValues()
	C_Timer.After(0.1, function()
	filtersFrame.closeButton:ClearAllPoints()
	filtersFrame.closeButton:SetPoint("CENTER", filtersFrame.frame, "TOPRIGHT", -8, -8)
	
	filtersFrame.head:ClearAllPoints()
	filtersFrame.head:SetPoint("TOP", filtersFrame.frame, "TOP", 0, -30)
	
	filtersFrame.addFilter:ClearAllPoints()
	filtersFrame.addFilter:SetPoint("BOTTOM", filtersFrame.frame, "BOTTOM", 0, 20)
	
	
	
	
	addfilterFrame.closeButton:ClearAllPoints()
	addfilterFrame.closeButton:SetPoint("CENTER", addfilterFrame.frame, "TOPRIGHT", -8, -8)
	
	addfilterFrame.topHint:ClearAllPoints()
	addfilterFrame.topHint:SetPoint("TOP", addfilterFrame.frame, "TOP", 0, -30)
	
	addfilterFrame.classLabel:ClearAllPoints()
	addfilterFrame.classLabel:SetPoint("TOPLEFT", addfilterFrame.topHint.frame, "BOTTOMLEFT", 10, -30)
	
	addfilterFrame.raceLabel:ClearAllPoints()
	addfilterFrame.raceLabel:SetPoint("LEFT", addfilterFrame.classLabel.frame, "RIGHT", size.raceShift, 0)
	
	addfilterFrame.filterNameLabel:ClearAllPoints()
	addfilterFrame.filterNameLabel:SetPoint("RIGHT", addfilterFrame.frame, "RIGHT", -15, 150)
	
	addfilterFrame.saveButton:ClearAllPoints()
	addfilterFrame.saveButton:SetPoint("BOTTOM", addfilterFrame.frame, "BOTTOM", 0, 20)
	
	addfilterFrame.bottomHint:ClearAllPoints()
	addfilterFrame.bottomHint:SetPoint("BOTTOM", addfilterFrame.saveButton.frame, "TOP", 0, 40)
	
	
	filtersFrame:Hide()
	addfilterFrame:Hide()
	end)
end)
