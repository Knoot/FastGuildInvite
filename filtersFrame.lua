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

local filters, filtersFrame, addfilterFrame


local function defaultValues()
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

local function getClassFilter()
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
frame:SetPoint("TOPLEFT", addfilterFrame.classesCheckBoxIgnore.frame, "BOTTOMLEFT", 0, -2)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxDemonHunter = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxDemonHunter
frame:SetWidth(size.DemonHunter)
frame:SetLabel(L.SYSTEM.class.DemonHunter)
fontSize(frame.text)
frame:SetPoint("TOPLEFT", addfilterFrame.classesCheckBoxDeathKnight.frame, "BOTTOMLEFT", 0, 0)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxMonk = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxMonk
frame:SetWidth(size.Monk)
frame:SetLabel(L.SYSTEM.class.Monk)
fontSize(frame.text)
frame:SetPoint("TOPLEFT", addfilterFrame.classesCheckBoxDemonHunter.frame, "BOTTOMLEFT", 0, 0)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxDruid = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxDruid
frame:SetWidth(size.Druid)
frame:SetLabel(L.SYSTEM.class.Druid)
fontSize(frame.text)
frame:SetPoint("TOPLEFT", addfilterFrame.classesCheckBoxMonk.frame, "BOTTOMLEFT", 0, 0)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxHunter = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxHunter
frame:SetWidth(size.Hunter)
frame:SetLabel(L.SYSTEM.class.Hunter)
fontSize(frame.text)
frame:SetPoint("TOPLEFT", addfilterFrame.classesCheckBoxDruid.frame, "BOTTOMLEFT", 0, 0)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxMage = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxMage
frame:SetWidth(size.Mage)
frame:SetLabel(L.SYSTEM.class.Mage)
fontSize(frame.text)
frame:SetPoint("TOPLEFT", addfilterFrame.classesCheckBoxHunter.frame, "BOTTOMLEFT", 0, 0)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxPaladin = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxPaladin
frame:SetWidth(size.Paladin)
frame:SetLabel(L.SYSTEM.class.Paladin)
fontSize(frame.text)
frame:SetPoint("TOPLEFT", addfilterFrame.classesCheckBoxMage.frame, "BOTTOMLEFT", 0, 0)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxPriest = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxPriest
frame:SetWidth(size.Priest)
frame:SetLabel(L.SYSTEM.class.Priest)
fontSize(frame.text)
frame:SetPoint("TOPLEFT", addfilterFrame.classesCheckBoxPaladin.frame, "BOTTOMLEFT", 0, 0)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxRogue = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxRogue
frame:SetWidth(size.Rogue)
frame:SetLabel(L.SYSTEM.class.Rogue)
fontSize(frame.text)
frame:SetPoint("TOPLEFT", addfilterFrame.classesCheckBoxPriest.frame, "BOTTOMLEFT", 0, 0)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxShaman = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxShaman
frame:SetWidth(size.Shaman)
frame:SetLabel(L.SYSTEM.class.Shaman)
fontSize(frame.text)
frame:SetPoint("TOPLEFT", addfilterFrame.classesCheckBoxRogue.frame, "BOTTOMLEFT", 0, 0)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxWarlock = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxWarlock
frame:SetWidth(size.Warlock)
frame:SetLabel(L.SYSTEM.class.Warlock)
fontSize(frame.text)
frame:SetPoint("TOPLEFT", addfilterFrame.classesCheckBoxShaman.frame, "BOTTOMLEFT", 0, 0)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxWarrior = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxWarrior
frame:SetWidth(size.Warrior)
frame:SetLabel(L.SYSTEM.class.Warrior)
fontSize(frame.text)
frame:SetPoint("TOPLEFT", addfilterFrame.classesCheckBoxWarlock.frame, "BOTTOMLEFT", 0, 0)
addfilterFrame:AddChild(frame)
end

--[===[@non-retail@
local function defaultValues()
	addfilterFrame.classesCheckBoxDruid:SetValue(false)
	addfilterFrame.classesCheckBoxHunter:SetValue(false)
	addfilterFrame.classesCheckBoxMage:SetValue(false)
	addfilterFrame.classesCheckBoxPaladin:SetValue(false)
	addfilterFrame.classesCheckBoxPriest:SetValue(false)
	addfilterFrame.classesCheckBoxRogue:SetValue(false)
	addfilterFrame.classesCheckBoxShaman:SetValue(false)
	addfilterFrame.classesCheckBoxWarlock:SetValue(false)
	addfilterFrame.classesCheckBoxWarrior:SetValue(false)
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

local function getClassFilter()
	local arr = {
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
addfilterFrame.classesCheckBoxDruid = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxDruid
frame:SetWidth(size.Druid)
frame:SetLabel(L.SYSTEM.class.Druid)
fontSize(frame.text)
frame:SetPoint("TOPLEFT", addfilterFrame.classesCheckBoxIgnore.frame, "BOTTOMLEFT", 0, -2)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxHunter = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxHunter
frame:SetWidth(size.Hunter)
frame:SetLabel(L.SYSTEM.class.Hunter)
fontSize(frame.text)
frame:SetPoint("TOPLEFT", addfilterFrame.classesCheckBoxDruid.frame, "BOTTOMLEFT", 0, 0)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxMage = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxMage
frame:SetWidth(size.Mage)
frame:SetLabel(L.SYSTEM.class.Mage)
fontSize(frame.text)
frame:SetPoint("TOPLEFT", addfilterFrame.classesCheckBoxHunter.frame, "BOTTOMLEFT", 0, 0)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxPaladin = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxPaladin
frame:SetWidth(size.Paladin)
frame:SetLabel(L.SYSTEM.class.Paladin)
fontSize(frame.text)
frame:SetPoint("TOPLEFT", addfilterFrame.classesCheckBoxMage.frame, "BOTTOMLEFT", 0, 0)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxPriest = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxPriest
frame:SetWidth(size.Priest)
frame:SetLabel(L.SYSTEM.class.Priest)
fontSize(frame.text)
frame:SetPoint("TOPLEFT", addfilterFrame.classesCheckBoxPaladin.frame, "BOTTOMLEFT", 0, 0)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxRogue = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxRogue
frame:SetWidth(size.Rogue)
frame:SetLabel(L.SYSTEM.class.Rogue)
fontSize(frame.text)
frame:SetPoint("TOPLEFT", addfilterFrame.classesCheckBoxPriest.frame, "BOTTOMLEFT", 0, 0)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxShaman = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxShaman
frame:SetWidth(size.Shaman)
frame:SetLabel(L.SYSTEM.class.Shaman)
fontSize(frame.text)
frame:SetPoint("TOPLEFT", addfilterFrame.classesCheckBoxRogue.frame, "BOTTOMLEFT", 0, 0)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxWarlock = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxWarlock
frame:SetWidth(size.Warlock)
frame:SetLabel(L.SYSTEM.class.Warlock)
fontSize(frame.text)
frame:SetPoint("TOPLEFT", addfilterFrame.classesCheckBoxShaman.frame, "BOTTOMLEFT", 0, 0)
addfilterFrame:AddChild(frame)

addfilterFrame.classesCheckBoxWarrior = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxWarrior
frame:SetWidth(size.Warrior)
frame:SetLabel(L.SYSTEM.class.Warrior)
fontSize(frame.text)
frame:SetPoint("TOPLEFT", addfilterFrame.classesCheckBoxWarlock.frame, "BOTTOMLEFT", 0, 0)
addfilterFrame:AddChild(frame)
end
--@end-non-retail@]===]

local w,h = 623, 568

interface.settings.filters.content = GUI:Create("SimpleGroup")
filters = interface.settings.filters.content
filters:SetWidth(w-20)
filters:SetHeight(h-20-60)
filters.frame:SetParent(interface.settings.filters)
filters:SetLayout("NIL")
filters:SetPoint("TOPLEFT", interface.settings.filters, "TOPLEFT", 10, -70)

filters.setBtn = GUI:Create("Button")
local frame = filters.setBtn
frame:SetHeight(40)
frame:SetText(L.interface["Список фильтров"])
frame:SetCallback("OnClick", function()
	filters.filtersFrame.frame:Show()
	filters.addfilterFrame.frame:Hide()
end)
filters:AddChild(frame)

filters.listBtn = GUI:Create("Button")
local frame = filters.listBtn
frame:SetHeight(40)
frame:SetText(L.interface["Добавить фильтр"])
frame:SetCallback("OnClick", function()
	filters.filtersFrame.frame:Hide()
	filters.addfilterFrame.frame:Show()
end)
filters:AddChild(frame)


filters.filtersFrame = GUI:Create("SimpleGroup")
filtersFrame = filters.filtersFrame
filtersFrame.frame:SetParent(interface.settings.filters)
filtersFrame:SetWidth(filters.frame:GetWidth())
filtersFrame:SetHeight(h-20-60)
filtersFrame:SetLayout("NIL")
filtersFrame.filterList = {}

filtersFrame.head = GUI:Create("TLabel")
local frame = filtersFrame.head
frame:SetText(L.interface["Нажмите на фильтр для изменения состояния"])
fontSize(frame.label)
frame:SetWidth(filtersFrame.frame:GetWidth())
frame.label:SetJustifyH("CENTER")
frame:SetPoint("TOP", filtersFrame.frame, "TOP", 0, -5)
filtersFrame:AddChild(frame)




filters.addfilterFrame = GUI:Create("SimpleGroup")
addfilterFrame = filters.addfilterFrame
addfilterFrame.frame:SetParent(interface.settings.filters)
addfilterFrame:SetWidth(filters.frame:GetWidth())
addfilterFrame:SetHeight(h-20-60)
addfilterFrame:SetLayout("NIL")

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


addfilterFrame.topHint = GUI:Create("TLabel")
local frame = addfilterFrame.topHint
frame:SetText(L.interface["Обязательное поле \"Имя фильтра\", пустые текстовые поля не используются при фильтрации."])
fontSize(frame.label)
frame:SetWidth(addfilterFrame.frame:GetWidth())
frame.label:SetJustifyH("CENTER")
addfilterFrame:AddChild(frame)



do		--class
addfilterFrame.classLabel = GUI:Create("TLabel")
local frame = addfilterFrame.classLabel
frame:SetText(L.interface["Классы:"])
fontSize(frame.label)
frame:SetWidth(size.classLabel)
frame.label:SetJustifyH("CENTER")
frame:SetPoint("TOPLEFT", addfilterFrame.topHint.frame, "BOTTOMLEFT", 10, -30)
addfilterFrame:AddChild(frame)


addfilterFrame.classesCheckBoxIgnore = GUI:Create("TCheckBox")
local frame = addfilterFrame.classesCheckBoxIgnore
frame:SetWidth(size.Ignore)
frame:SetLabel(L.interface["Игнорировать"])
fontSize(frame.text)
frame:SetCallback("OnValueChanged", function() fn:classIgnoredToggle() end)
frame:SetPoint("TOPLEFT", addfilterFrame.classLabel.frame, "BOTTOMLEFT", 0, -2)
addfilterFrame:AddChild(frame)


createClassBoxes()
end



do		--race
addfilterFrame.raceLabel = GUI:Create("TLabel")
local frame = addfilterFrame.raceLabel
frame:SetText(L.interface["Расы:"])
fontSize(frame.label)
frame:SetWidth(size.raceLabel)
frame.label:SetJustifyH("CENTER")
addfilterFrame:AddChild(frame)



addfilterFrame.rasesCheckBoxIgnore = GUI:Create("TCheckBox")
local frame = addfilterFrame.rasesCheckBoxIgnore
frame:SetWidth(size.Ignore)
frame:SetLabel(L.interface["Игнорировать"])
fontSize(frame.text)
frame:SetCallback("OnValueChanged", function() fn:racesIgnoredToggle() end)
frame:SetPoint("TOPLEFT", addfilterFrame.raceLabel.frame, "BOTTOMLEFT", 0, -2)
addfilterFrame:AddChild(frame)


addfilterFrame.rasesCheckBoxRace = {}
for k,v in pairs(L.SYSTEM.race) do
	local i = #addfilterFrame.rasesCheckBoxRace+1
	addfilterFrame.rasesCheckBoxRace[i] = GUI:Create("TCheckBox")
	local frame = addfilterFrame.rasesCheckBoxRace[i]
	fontSize(frame.text)
	frame:SetPoint("TOPLEFT", (i==1 and addfilterFrame.rasesCheckBoxIgnore.frame or addfilterFrame.rasesCheckBoxRace[i-1].frame), "BOTTOMLEFT", 0, 0)
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
frame:SetText(L.interface["Имя фильтра"])
fontSize(frame.label)
frame:SetWidth(size.filterNameLabel)
frame.label:SetJustifyH("CENTER")
frame:SetPoint("TOPRIGHT", addfilterFrame.topHint.frame, "BOTTOMRIGHT", 0, -30)
addfilterFrame:AddChild(frame)

addfilterFrame.filterNameEdit = GUI:Create("EditBox")
local frame = addfilterFrame.filterNameEdit
frame:SetWidth(size.filtersEdit)
EditBoxChange(frame)
frame:SetPoint("TOP", addfilterFrame.filterNameLabel.frame, "BOTTOM", 0, 0)
addfilterFrame:AddChild(frame)

addfilterFrame.excludeNameLabel = GUI:Create("TLabel")
local frame = addfilterFrame.excludeNameLabel
frame:SetText(L.interface["Фильтр по имени"])
frame:SetTooltip(L.interface.tooltip["Если имя игрока содержит введенную\nфразу, он не будет добавлен в очередь"])
fontSize(frame.label)
frame:SetWidth(size.excludeNameLabel)
frame.label:SetJustifyH("CENTER")
frame:SetPoint("TOP", addfilterFrame.filterNameEdit.frame, "BOTTOM", 0, -30)
addfilterFrame:AddChild(frame)

addfilterFrame.excludeNameEditBox = GUI:Create("EditBox")
local frame = addfilterFrame.excludeNameEditBox
frame:SetWidth(size.filtersEdit)
EditBoxChange(frame)
frame:SetPoint("TOP", addfilterFrame.excludeNameLabel.frame, "BOTTOM", 0, 0)
addfilterFrame:AddChild(frame)

addfilterFrame.lvlRangeLabel = GUI:Create("TLabel")
local frame = addfilterFrame.lvlRangeLabel
frame:SetText(L.interface["Диапазон уровней (Мин:Макс)"])
frame:SetTooltip(format(L.interface.tooltip["Введите диапазон уровней для фильтра.\nНапример: %s55%s:%s58%s\nбудут подходить только те игроки, уровень\nкоторых варьируется от %s55%s до %s58%s (включительно)"], "|cff00ff00", "|r", "|cff00A2FF", "|r", "|cff00ff00", "|r", "|cff00A2FF", "|r"))
fontSize(frame.label)
frame:SetWidth(size.lvlRangeLabel)
frame.label:SetJustifyH("CENTER")
frame:SetPoint("TOP", addfilterFrame.excludeNameEditBox.frame, "BOTTOM", 0, -30)
addfilterFrame:AddChild(frame)

addfilterFrame.lvlRangeEditBox = GUI:Create("EditBox")
local frame = addfilterFrame.lvlRangeEditBox
frame:SetWidth(size.filtersEdit)
EditBoxChange(frame)
frame:SetPoint("TOP", addfilterFrame.lvlRangeLabel.frame, "BOTTOM", 0, 0)
addfilterFrame:AddChild(frame)

addfilterFrame.excludeRepeatLabel = GUI:Create("TLabel")
local frame = addfilterFrame.excludeRepeatLabel
frame:SetText(L.interface["Фильтр повторений в имени"])
frame:SetTooltip(format(L.interface.tooltip["Введите максимальное количество последовательных\nгласных и согласных, которое может содержать имя игрока.\nНапример: %s3%s:%s5%s\nБудет означать, что игроки с более чем %s3%s гласными подряд\nили более %s5%s согласными подряд не будут добавлены в очередь."], "|cff00ff00", "|r", "|cff00A2FF", "|r", "|cff00ff00", "|r", "|cff00A2FF", "|r"))
fontSize(frame.label)
frame:SetWidth(size.excludeRepeatLabel)
frame.label:SetJustifyH("CENTER")
frame:SetPoint("TOP", addfilterFrame.lvlRangeEditBox.frame, "BOTTOM", 0, -30)
addfilterFrame:AddChild(frame)

addfilterFrame.excludeRepeatEditBox = GUI:Create("EditBox")
local frame = addfilterFrame.excludeRepeatEditBox
frame:SetWidth(size.filtersEdit)
EditBoxChange(frame)
frame:SetPoint("TOP", addfilterFrame.excludeRepeatLabel.frame, "BOTTOM", 0, 0)
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
		table.insert(errors, format("%s \n %s", L.interface["Имя фильтра"], L.interface["Имя фильтра не может быть пустым"]))
	elseif DB.filtersList[filterName] ~= nil and not addfilterFrame.change then
		table.insert(errors, format("%s \n %s", L.interface["Имя фильтра"], L.interface["Имя фильтра занято"]))
	end
	
	if filterByName and not filterByName:find("^"..addon.ruReg.."+$") then
		table.insert(errors, format("%s \n %s", L.interface["Фильтр по имени"], L.interface["Поле может содержать только буквы"]))
	end
	if lvlRange then
		if lvlRange:find(("[\-]?%d+:[\-]?%d+")) then
			min, max = fn:split(lvlRange, ":", -1)
			if min <= 0 or max <= 0 or min > max then
				table.insert(errors, format("%s \n %s", L.interface["Диапазон уровней (Мин:Макс)"], L.interface["Числа не могут быть меньше или равны 0. Минимальный уровень не может быть больше максимального"]))
			end
		else
			table.insert(errors, format("%s \n %s", L.interface["Диапазон уровней (Мин:Макс)"], L.interface["Неправильный шаблон"]))
		end
	end
	if letterFilter then
		if letterFilter:find("[\-]?%d+:[\-]?%d+") then
			min, max = fn:split(letterFilter, ":")
			if min < 0 or max < 0 then
				table.insert(errors, format("%s \n %s", L.interface["Фильтр повторений в имени"], L.interface["Числа должны быть больше 0"]))
			end
		else
			table.insert(errors, format("%s \n %s", L.interface["Фильтр повторений в имени"], L.interface["Неправильный шаблон"]))
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
		filters.filtersFrame.frame:Show()
		filters.addfilterFrame.frame:Hide()
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
			table.insert(errors, 1, format(L.interface["Количество ошибок: %d"],#errors))
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
frame:SetText(L.interface["Сохранить"])
-- fontSize(frame.text)
frame.text:ClearAllPoints()
frame.text:SetPoint("TOPLEFT", 5, -1)
frame.text:SetPoint("BOTTOMRIGHT", -5, 1)
frame:SetWidth(size.saveButton)
frame:SetHeight(40)
frame:SetCallback('OnClick', saveFilter)
frame:SetPoint("BOTTOM", addfilterFrame.frame, "BOTTOM", 0, 0)
addfilterFrame:AddChild(frame)




addfilterFrame.bottomHint = GUI:Create("TLabel")
local frame = addfilterFrame.bottomHint
frame:SetText(L.interface["Чтобы быть отфильтрованным, игрок должен соответствовать критериям ВСЕХ фильтров"])
fontSize(frame.label)
frame:SetWidth(addfilterFrame.frame:GetWidth()-20)
frame.label:SetJustifyH("CENTER")
frame:SetPoint("BOTTOM", addfilterFrame.saveButton.frame, "TOP", 0, 30)
addfilterFrame:AddChild(frame)




addfilterFrame.frame:HookScript("OnShow", defaultValues)



-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB
	
	
	-- defaultValues()
	local i = 1
	for k,v in pairs(L.SYSTEM.race) do
		local frame = addfilterFrame.rasesCheckBoxRace[i]
		frame:SetWidth(size[k])
		frame:SetLabel(v)
		i = i + 1
	end
	C_Timer.After(0.1, function()
	filters.filtersFrame:ClearAllPoints()
	filters.filtersFrame:SetPoint("TOPLEFT", filters.frame, "TOPLEFT", 0, 0)
	
	filters.listBtn:ClearAllPoints()
	filters.listBtn:SetPoint("BOTTOMRIGHT", filters.frame, "TOPRIGHT", 0, 10)
	
	filters.setBtn:ClearAllPoints()
	filters.setBtn:SetPoint("BOTTOMLEFT", filters.frame, "TOPLEFT", 0, 10)
	
	
	
	addfilterFrame:ClearAllPoints()
	addfilterFrame:SetPoint("TOPLEFT", filters.frame, "TOPLEFT", 0, 0)
	
	addfilterFrame.topHint:ClearAllPoints()
	addfilterFrame.topHint:SetPoint("TOP", addfilterFrame.frame, "TOP", 0, 0)
	
	
	
	
	
	
	
	addfilterFrame.raceLabel:ClearAllPoints()
	addfilterFrame.raceLabel:SetPoint("LEFT", addfilterFrame.classLabel.frame, "RIGHT", size.raceShift, 0)
	
	
	
	
	-- filtersFrame.frame:Hide()
	addfilterFrame.frame:Hide()
	
	end)
end)
