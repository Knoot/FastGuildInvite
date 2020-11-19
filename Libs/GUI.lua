--[[-----------------------------------------------------------------------------
FGI Filter Widget
Graphical Button.
-------------------------------------------------------------------------------]]
do
local Type, Version = "FilterButton", 1
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end


local L = FGI:GetLocale()


-- Lua APIs
local pairs = pairs

-- WoW APIs
local _G = _G
local PlaySound, CreateFrame, UIParent = PlaySound, CreateFrame, UIParent

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function Button_OnClick(self, button,...)
	local frame = self.obj.frame
	local shift = IsShiftKeyDown()
	if button == "LeftButton" and not shift then
		--on/off
		self.obj:click()
		FGI.functions:FiltersUpdate()
	elseif button == "LeftButton" and shift then
		--delete
		local DB = FGI.DB
		DB.realm.filtersList[frame.id] = nil
		FGI.functions:FiltersUpdate()
	elseif button == "RightButton" then
		--replace
		FGI.functions:FilterChange(frame.id)
	end
	AceGUI:ClearFocus()
	--PlaySound("igMainMenuOption")
	self.obj:Fire("OnClick", ...)
end

local function Control_OnEnter(frame)
	if frame.obj.tooltip ~= nil and frame.obj.tooltip ~= '' then
		GameTooltip:SetOwner(frame, "ANCHOR_TOP")
		GameTooltip:AddLine(format("%s\n\n%s", L["filter"], frame.obj.tooltip))
		GameTooltip:Show()
	end
	frame.obj:Fire("OnEnter")
end

local function Control_OnLeave(frame)
	GameTooltip:Hide()
	frame.obj:Fire("OnLeave")
end

local function setHighlight(frame, s)
	if s then
		frame:SetColorTexture(0,1,0,0.2);
	else
		frame:SetColorTexture(1,0,0,0.2);
	end
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		-- restore default values
		self:SetHeight(25)
		self:SetWidth(80)
		self:SetDisabled(false)
		self:SetText()
	end,
	
	["click"] = function(self)
		local DB = FGI.DB
		if self.frame.id == '' and not DB.realm.filtersList[self.frame.id] then return  end
		local on = not DB.realm.filtersList[self.frame.id].filterOn
		if on then
			setHighlight(self.highlight, true)
			DB.realm.filtersList[self.frame.id].filterOn = true
		else
			setHighlight(self.highlight, false)
			DB.realm.filtersList[self.frame.id].filterOn = false
		end
	end,

	-- ["OnRelease"] = nil,

	["SetText"] = function(self, text)
		self.text:SetText(text)
	end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		if disabled then
			self.frame:Disable()
		else
			self.frame:Enable()
		end
	end,
	
	["SetTooltip"] = function(self, tooltip)
		self.tooltip = tooltip
	end,
	
	["SetID"] = function(self, id)
		local DB = FGI.DB
		self.frame.id = id
		if DB.realm.filtersList[id] then self.frame:Show() end
		if DB.realm.filtersList[id] and DB.realm.filtersList[id].filterOn then
			setHighlight(self.highlight, true)
		else
			setHighlight(self.highlight, false)
		end
	end,
	
	["Show"] = function(self)
		self.frame:Show()
	end,
	
	["Hide"] = function(self)
		self.frame:Hide()
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
	local name = "AceGUI30Button" .. AceGUI:GetNextWidgetNum(Type)
	local frame = CreateFrame("Button", name, FGI.interface.settings.filters.content.filtersFrame.frame)
	frame:Hide()
	
	frame.tooltip = ''
	frame.id = ''

	frame:EnableMouse(true)
	frame:SetScript("OnClick", Button_OnClick)
	frame:SetScript("OnEnter", Control_OnEnter)
	frame:SetScript("OnLeave", Control_OnLeave)
	frame:RegisterForClicks("LeftButtonUp","RightButtonUp")
	
	

	--local text = frame:GetFontString()
	local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	text:ClearAllPoints()
	text:SetPoint("TOPLEFT", 5, -1)
	text:SetPoint("BOTTOMRIGHT", -5, 1)
	text:SetJustifyV("LEFT")
	
	local highlight = frame:CreateTexture()
	highlight:SetColorTexture(1,0,0,0.2)
	highlight:SetAllPoints()

	local widget = {
		text  = text,
		frame = frame,
		highlight = highlight,
		type  = Type,
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[-----------------------------------------------------------------------------
Frame Container
-------------------------------------------------------------------------------]]
do
local Type, Version = "ClearFrame", 26
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local pairs, assert, type = pairs, assert, type
local wipe = table.wipe

-- WoW APIs
local PlaySound = PlaySound
local CreateFrame, UIParent = CreateFrame, UIParent

-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: CLOSE

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function Button_OnClick(frame)
	PlaySound(799) -- SOUNDKIT.GS_TITLE_OPTION_EXIT
	frame.obj:Hide()
end

local function Frame_OnShow(frame)
	frame.obj:Fire("OnShow")
end

local function Frame_OnClose(frame)
	frame.obj:Fire("OnClose")
end

local function Frame_OnMouseDown(frame)
	AceGUI:ClearFocus()
end

local function Title_OnMouseDown(frame)
	frame:GetParent():StartMoving()
	AceGUI:ClearFocus()
end

local function MoverSizer_OnMouseUp(mover)
	local frame = mover:GetParent()
	frame:StopMovingOrSizing()
	local self = frame.obj
	local status = self.status or self.localstatus
	status.width = frame:GetWidth()
	status.height = frame:GetHeight()
	status.top = frame:GetTop()
	status.left = frame:GetLeft()
end

local function SizerSE_OnMouseDown(frame)
	frame:GetParent():StartSizing("BOTTOMRIGHT")
	AceGUI:ClearFocus()
end

local function SizerS_OnMouseDown(frame)
	frame:GetParent():StartSizing("BOTTOM")
	AceGUI:ClearFocus()
end

local function SizerE_OnMouseDown(frame)
	frame:GetParent():StartSizing("RIGHT")
	AceGUI:ClearFocus()
end

local function StatusBar_OnEnter(frame)
	frame.obj:Fire("OnEnterStatusBar")
end

local function StatusBar_OnLeave(frame)
	frame.obj:Fire("OnLeaveStatusBar")
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		self.frame:SetParent(UIParent)
		self.frame:SetFrameStrata("FULLSCREEN_DIALOG")
		self:SetTitle()
		self:Show()
	end,

	["OnRelease"] = function(self)
		self.status = nil
	end,

	["OnWidthSet"] = function(self, width)
		local content = self.content
		local contentwidth = width - 34
		if contentwidth < 0 then
			contentwidth = 0
		end
		content:SetWidth(contentwidth)
		content.width = contentwidth
	end,

	["OnHeightSet"] = function(self, height)
		local content = self.content
		local contentheight = height - 57
		if contentheight < 0 then
			contentheight = 0
		end
		content:SetHeight(contentheight)
		content.height = contentheight
	end,

	["SetTitle"] = function(self, title)
		self.titletext:SetText(title)
		self.titlebg:SetWidth((self.titletext:GetWidth() or 0) + 10)
	end,

	["Hide"] = function(self)
		self.frame:Hide()
	end,

	["Show"] = function(self)
		self.frame:Show()
	end,
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local FrameBackdrop = {
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 8, right = 8, top = 8, bottom = 8 }
}

local PaneBackdrop  = {
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true, tileSize = 16, edgeSize = 16,
	insets = { left = 3, right = 3, top = 5, bottom = 3 }
}

local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	frame:Hide()

	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetResizable(true)
	frame:SetFrameStrata("FULLSCREEN_DIALOG")
	frame:SetBackdrop(FrameBackdrop)
	frame:SetBackdropColor(0, 0, 0, 1)
	frame:SetMinResize(400, 200)
	frame:SetToplevel(true)
	frame:SetScript("OnShow", Frame_OnShow)
	frame:SetScript("OnHide", Frame_OnClose)
	frame:SetScript("OnMouseDown", Frame_OnMouseDown)

	local titlebg = frame:CreateTexture(nil, "OVERLAY")
	titlebg:SetTexture(131080) -- Interface\\DialogFrame\\UI-DialogBox-Header
	titlebg:SetTexCoord(0.31, 0.67, 0, 0.63)
	titlebg:SetPoint("TOP", 0, 12)
	titlebg:SetWidth(100)
	titlebg:SetHeight(40)

	local title = CreateFrame("Frame", nil, frame)
	title:EnableMouse(true)
	title:SetScript("OnMouseDown", Title_OnMouseDown)
	title:SetScript("OnMouseUp", MoverSizer_OnMouseUp)
	title:SetAllPoints(titlebg)

	local titletext = title:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	titletext:SetPoint("TOP", titlebg, "TOP", 0, -14)

	local titlebg_l = frame:CreateTexture(nil, "OVERLAY")
	titlebg_l:SetParent(title)
	titlebg_l:SetTexture(131080) -- Interface\\DialogFrame\\UI-DialogBox-Header
	titlebg_l:SetTexCoord(0.21, 0.31, 0, 0.63)
	titlebg_l:SetPoint("RIGHT", titlebg, "LEFT")
	titlebg_l:SetWidth(30)
	titlebg_l:SetHeight(40)

	local titlebg_r = frame:CreateTexture(nil, "OVERLAY")
	titlebg_r:SetParent(title)
	titlebg_r:SetTexture(131080) -- Interface\\DialogFrame\\UI-DialogBox-Header
	titlebg_r:SetTexCoord(0.67, 0.77, 0, 0.63)
	titlebg_r:SetPoint("LEFT", titlebg, "RIGHT")
	titlebg_r:SetWidth(30)
	titlebg_r:SetHeight(40)

	--Container Support
	local content = CreateFrame("Frame", nil, frame)
	content:SetPoint("TOPLEFT", 17, -27)
	content:SetPoint("BOTTOMRIGHT", -17, 40)

	local widget = {
		localstatus = {},
		title		= title,
		titletext   = titletext,
		titlebg     = titlebg,
		content     = content,
		frame       = frame,
		type        = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsContainer(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
end

--[[-----------------------------------------------------------------------------
Frame Container
-------------------------------------------------------------------------------]]
do
local Type, Version = "GroupFrame", 26
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local pairs, assert, type = pairs, assert, type
local wipe = table.wipe

-- WoW APIs
local PlaySound = PlaySound
local CreateFrame, UIParent = CreateFrame, UIParent

-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: CLOSE

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function Button_OnClick(frame)
	PlaySound(799) -- SOUNDKIT.GS_TITLE_OPTION_EXIT
	frame.obj:Hide()
end

local function Frame_OnShow(frame)
	frame.obj:Fire("OnShow")
end

local function Frame_OnClose(frame)
	frame.obj:Fire("OnClose")
end

local function Frame_OnMouseDown(frame)
	AceGUI:ClearFocus()
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		self.frame:SetParent(UIParent)
		self.frame:SetFrameStrata("FULLSCREEN_DIALOG")
		self:Show()
	end,

	["OnRelease"] = function(self)end,

	["OnWidthSet"] = function(self, width)
		local content = self.content
		local contentwidth = width - 34
		if contentwidth < 0 then
			contentwidth = 0
		end
		content:SetWidth(contentwidth)
		content.width = contentwidth
	end,

	["OnHeightSet"] = function(self, height)
		local content = self.content
		local contentheight = height - 57
		if contentheight < 0 then
			contentheight = 0
		end
		content:SetHeight(contentheight)
		content.height = contentheight
	end,

	["Hide"] = function(self)
		self.frame:Hide()
	end,

	["Show"] = function(self)
		self.frame:Show()
	end,
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]

local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	frame:Hide()

	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetResizable(true)
	frame:SetFrameStrata("FULLSCREEN_DIALOG")
	frame:SetBackdropColor(0, 0, 0, 1)
	frame:SetMinResize(400, 200)
	frame:SetToplevel(true)
	frame:SetScript("OnShow", Frame_OnShow)
	frame:SetScript("OnHide", Frame_OnClose)
	frame:SetScript("OnMouseDown", Frame_OnMouseDown)

	--Container Support
	local content = CreateFrame("Frame", nil, frame)
	content:SetPoint("TOPLEFT", 17, -27)
	content:SetPoint("BOTTOMRIGHT", -17, 40)

	local widget = {
		content     = content,
		frame       = frame,
		type        = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsContainer(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
end


--[[-----------------------------------------------------------------------------
Checkbox Widget
-------------------------------------------------------------------------------]]
do
local Type, Version = "TCheckBox", 26
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local select, pairs = select, pairs

-- WoW APIs
local PlaySound = PlaySound
local CreateFrame, UIParent = CreateFrame, UIParent

-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: SetDesaturation, GameFontHighlight

--[[-----------------------------------------------------------------------------
Support functions
-------------------------------------------------------------------------------]]
local function AlignImage(self)
	local img = self.image:GetTexture()
	self.text:ClearAllPoints()
	if not img then
		self.text:SetPoint("LEFT", self.checkbg, "RIGHT")
		self.text:SetPoint("RIGHT")
	else
		self.text:SetPoint("LEFT", self.image, "RIGHT", 1, 0)
		self.text:SetPoint("RIGHT")
	end
end

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function Control_OnEnter(frame)
	frame.obj:Fire("OnEnter")
	if frame.obj.tooltip ~= nil and frame.obj.tooltip ~= '' then
		GameTooltip:SetOwner(frame, "ANCHOR_TOP")
		GameTooltip:AddLine(frame.obj.tooltip)
		GameTooltip:Show()
	end
end

local function Control_OnLeave(frame)
	frame.obj:Fire("OnLeave")
	GameTooltip:Hide()
end

local function CheckBox_OnMouseDown(frame)
	local self = frame.obj
	if not self.disabled then
		if self.image:GetTexture() then
			self.text:SetPoint("LEFT", self.image,"RIGHT", 2, -1)
		else
			self.text:SetPoint("LEFT", self.checkbg, "RIGHT", 1, -1)
		end
	end
	AceGUI:ClearFocus()
end

local function CheckBox_OnMouseUp(frame)
	local self = frame.obj
	if not self.disabled then
		self:ToggleChecked()

		if self.checked then
			PlaySound(856) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
		else -- for both nil and false (tristate)
			PlaySound(857) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
		end

		self:Fire("OnValueChanged", self.checked)
		AlignImage(self)
	end
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		self:SetType()
		self:SetValue(false)
		self:SetTriState(nil)
		-- height is calculated from the width and required space for the description
		self:SetWidth(200)
		self:SetImage()
		self:SetDisabled(nil)
		self:SetDescription(nil)
	end,

	-- ["OnRelease"] = nil,

	["OnWidthSet"] = function(self, width)
		if self.desc then
			self.desc:SetWidth(width - 30)
			if self.desc:GetText() and self.desc:GetText() ~= "" then
				self:SetHeight(28 + self.desc:GetStringHeight())
			end
		end
	end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		if disabled then
			self.frame:Disable()
			self.text:SetTextColor(0.5, 0.5, 0.5)
			SetDesaturation(self.check, true)
			if self.desc then
				self.desc:SetTextColor(0.5, 0.5, 0.5)
			end
		else
			self.frame:Enable()
			self.text:SetTextColor(1, 1, 1)
			if self.tristate and self.checked == nil then
				SetDesaturation(self.check, true)
			else
				SetDesaturation(self.check, false)
			end
			if self.desc then
				self.desc:SetTextColor(1, 1, 1)
			end
		end
	end,

	["SetValue"] = function(self, value)
		local check = self.check
		self.checked = value
		if value then
			SetDesaturation(check, false)
			check:Show()
		else
			--Nil is the unknown tristate value
			if self.tristate and value == nil then
				SetDesaturation(check, true)
				check:Show()
			else
				SetDesaturation(check, false)
				check:Hide()
			end
		end
		self:SetDisabled(self.disabled)
	end,

	["GetValue"] = function(self)
		return self.checked
	end,

	["SetTriState"] = function(self, enabled)
		self.tristate = enabled
		self:SetValue(self:GetValue())
	end,

	["SetType"] = function(self, type)
		local checkbg = self.checkbg
		local check = self.check
		local highlight = self.highlight

		local size
		if type == "radio" then
			size = 16
			checkbg:SetTexture(130843) -- Interface\\Buttons\\UI-RadioButton
			checkbg:SetTexCoord(0, 0.25, 0, 1)
			check:SetTexture(130843) -- Interface\\Buttons\\UI-RadioButton
			check:SetTexCoord(0.25, 0.5, 0, 1)
			check:SetBlendMode("ADD")
			highlight:SetTexture(130843) -- Interface\\Buttons\\UI-RadioButton
			highlight:SetTexCoord(0.5, 0.75, 0, 1)
		else
			size = 24
			checkbg:SetTexture(130755) -- Interface\\Buttons\\UI-CheckBox-Up
			checkbg:SetTexCoord(0, 1, 0, 1)
			check:SetTexture(130751) -- Interface\\Buttons\\UI-CheckBox-Check
			check:SetTexCoord(0, 1, 0, 1)
			check:SetBlendMode("BLEND")
			highlight:SetTexture(130753) -- Interface\\Buttons\\UI-CheckBox-Highlight
			highlight:SetTexCoord(0, 1, 0, 1)
		end
		checkbg:SetHeight(size)
		checkbg:SetWidth(size)
	end,

	["ToggleChecked"] = function(self)
		local value = self:GetValue()
		if self.tristate then
			--cycle in true, nil, false order
			if value then
				self:SetValue(nil)
			elseif value == nil then
				self:SetValue(false)
			else
				self:SetValue(true)
			end
		else
			self:SetValue(not self:GetValue())
		end
	end,

	["SetLabel"] = function(self, label)
		self.text:SetText(label)
	end,

	["GetLabel"] = function(self)
		return self.text:GetText()
	end,

	["SetDescription"] = function(self, desc)
		if desc then
			if not self.desc then
				local desc = self.frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
				desc:ClearAllPoints()
				desc:SetPoint("TOPLEFT", self.checkbg, "TOPRIGHT", 5, -21)
				desc:SetWidth(self.frame.width - 30)
				desc:SetPoint("RIGHT", self.frame, "RIGHT", -30, 0)
				desc:SetJustifyH("LEFT")
				desc:SetJustifyV("TOP")
				self.desc = desc
			end
			self.desc:Show()
			--self.text:SetFontObject(GameFontNormal)
			self.desc:SetText(desc)
			self:SetHeight(28 + self.desc:GetStringHeight())
		else
			if self.desc then
				self.desc:SetText("")
				self.desc:Hide()
			end
			--self.text:SetFontObject(GameFontHighlight)
			self:SetHeight(24)
		end
	end,
	
	["SetTooltip"] = function(self, tooltip)
		self.tooltip = tooltip
	end,

	["SetImage"] = function(self, path, ...)
		local image = self.image
		image:SetTexture(path)

		if image:GetTexture() then
			local n = select("#", ...)
			if n == 4 or n == 8 then
				image:SetTexCoord(...)
			else
				image:SetTexCoord(0, 1, 0, 1)
			end
		end
		AlignImage(self)
	end,
	
	["Hide"] = function(self)
		self.frame:Hide()
	end,
	
	["Show"] = function(self)
		self.frame:Show()
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
	local frame = CreateFrame("Button", nil, UIParent)
	frame:Hide()

	frame:EnableMouse(true)
	frame:SetScript("OnEnter", Control_OnEnter)
	frame:SetScript("OnLeave", Control_OnLeave)
	frame:SetScript("OnMouseDown", CheckBox_OnMouseDown)
	frame:SetScript("OnMouseUp", CheckBox_OnMouseUp)
	
	frame.tooltip = ''

	local checkbg = frame:CreateTexture(nil, "ARTWORK")
	checkbg:SetWidth(24)
	checkbg:SetHeight(24)
	checkbg:SetPoint("TOPLEFT")
	checkbg:SetTexture(130755) -- Interface\\Buttons\\UI-CheckBox-Up

	local check = frame:CreateTexture(nil, "OVERLAY")
	check:SetAllPoints(checkbg)
	check:SetTexture(130751) -- Interface\\Buttons\\UI-CheckBox-Check

	local text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	text:SetJustifyH("LEFT")
	text:SetHeight(18)
	text:SetPoint("LEFT", checkbg, "RIGHT")
	text:SetPoint("RIGHT")

	local highlight = frame:CreateTexture(nil, "HIGHLIGHT")
	highlight:SetTexture(130753) -- Interface\\Buttons\\UI-CheckBox-Highlight
	highlight:SetBlendMode("ADD")
	highlight:SetAllPoints(checkbg)

	local image = frame:CreateTexture(nil, "OVERLAY")
	image:SetHeight(16)
	image:SetWidth(16)
	image:SetPoint("LEFT", checkbg, "RIGHT", 1, 0)

	local widget = {
		checkbg   = checkbg,
		check     = check,
		text      = text,
		highlight = highlight,
		image     = image,
		frame     = frame,
		type      = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
end


--[[-----------------------------------------------------------------------------
Label Widget
Displays text and optionally an icon.
-------------------------------------------------------------------------------]]
do
local Type, Version = "TLabel", 26
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local max, select, pairs = math.max, select, pairs

-- WoW APIs
local CreateFrame, UIParent = CreateFrame, UIParent

-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: GameFontHighlightSmall

--[[-----------------------------------------------------------------------------
Support functions
-------------------------------------------------------------------------------]]

local function UpdateImageAnchor(self)
	if self.resizing then return end
	local frame = self.frame
	local width = frame.width or frame:GetWidth() or 0
	local image = self.image
	local label = self.label
	local height

	label:ClearAllPoints()
	image:ClearAllPoints()

	if self.imageshown then
		local imagewidth = image:GetWidth()
		if (width - imagewidth) < 200 or (label:GetText() or "") == "" then
			-- image goes on top centered when less than 200 width for the text, or if there is no text
			image:SetPoint("TOP")
			label:SetPoint("TOP", image, "BOTTOM")
			label:SetPoint("LEFT")
			label:SetWidth(width)
			height = image:GetHeight() + label:GetStringHeight()
		else
			-- image on the left
			image:SetPoint("TOPLEFT")
			if image:GetHeight() > label:GetStringHeight() then
				label:SetPoint("LEFT", image, "RIGHT", 4, 0)
			else
				label:SetPoint("TOPLEFT", image, "TOPRIGHT", 4, 0)
			end
			label:SetWidth(width - imagewidth - 4)
			height = max(image:GetHeight(), label:GetStringHeight())
		end
	else
		-- no image shown
		label:SetPoint("TOPLEFT")
		label:SetWidth(width)
		height = label:GetStringHeight()
	end

	-- avoid zero-height labels, since they can used as spacers
	if not height or height == 0 then
		height = 1
	end

	self.resizing = true
	frame:SetHeight(height)
	frame.height = height
	self.resizing = nil
end

local function Control_OnEnter(frame)
	if frame.obj.tooltip ~= nil and frame.obj.tooltip ~= '' then
		GameTooltip:SetOwner(frame, "ANCHOR_TOP")
		GameTooltip:AddLine(frame.obj.tooltip)
		GameTooltip:Show()
	end
end

local function Control_OnLeave(frame)
	GameTooltip:Hide()
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		-- set the flag to stop constant size updates
		self.resizing = true
		-- height is set dynamically by the text and image size
		self:SetWidth(200)
		self:SetText()
		self:SetImage(nil)
		self:SetImageSize(16, 16)
		self:SetColor()
		self:SetFontObject()
		self:SetJustifyH("LEFT")
		self:SetJustifyV("TOP")

		-- reset the flag
		self.resizing = nil
		-- run the update explicitly
		UpdateImageAnchor(self)
	end,

	-- ["OnRelease"] = nil,

	["OnWidthSet"] = function(self, width)
		UpdateImageAnchor(self)
	end,

	["SetText"] = function(self, text)
		self.label:SetText(text)
		UpdateImageAnchor(self)
	end,

	["SetColor"] = function(self, r, g, b)
		if not (r and g and b) then
			r, g, b = 1, 1, 1
		end
		self.label:SetVertexColor(r, g, b)
	end,

	["SetImage"] = function(self, path, ...)
		local image = self.image
		image:SetTexture(path)

		if image:GetTexture() then
			self.imageshown = true
			local n = select("#", ...)
			if n == 4 or n == 8 then
				image:SetTexCoord(...)
			else
				image:SetTexCoord(0, 1, 0, 1)
			end
		else
			self.imageshown = nil
		end
		UpdateImageAnchor(self)
	end,

	["SetFont"] = function(self, font, height, flags)
		self.label:SetFont(font, height, flags)
	end,

	["SetFontObject"] = function(self, font)
		self:SetFont((font or GameFontHighlightSmall):GetFont())
	end,

	["SetImageSize"] = function(self, width, height)
		self.image:SetWidth(width)
		self.image:SetHeight(height)
		UpdateImageAnchor(self)
	end,

	["SetJustifyH"] = function(self, justifyH)
		self.label:SetJustifyH(justifyH)
	end,

	["SetJustifyV"] = function(self, justifyV)
		self.label:SetJustifyV(justifyV)
	end,
	
	["SetTooltip"] = function(self, tooltip)
		self.tooltip = tooltip
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Hide()
	frame:SetScript("OnEnter", Control_OnEnter)
	frame:SetScript("OnLeave", Control_OnLeave)
	
	frame.tooltip = ''

	local label = frame:CreateFontString(nil, "BACKGROUND", "GameFontHighlightSmall")
	local image = frame:CreateTexture(nil, "BACKGROUND")

	-- create widget
	local widget = {
		label = label,
		image = image,
		frame = frame,
		type  = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
end



--[[-----------------------------------------------------------------------------
Keybinding Widget
Set Keybindings in the Config UI.
-------------------------------------------------------------------------------]]
do
local Type, Version = "TKeybinding", 25
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local pairs = pairs

-- WoW APIs
local IsShiftKeyDown, IsControlKeyDown, IsAltKeyDown = IsShiftKeyDown, IsControlKeyDown, IsAltKeyDown
local CreateFrame, UIParent = CreateFrame, UIParent

-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: NOT_BOUND

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]

local function Control_OnEnter(frame)
	frame.obj:Fire("OnEnter")
	if frame.tooltip ~= nil and frame.tooltip ~= '' then
		GameTooltip:SetOwner(frame, "ANCHOR_TOP")
		GameTooltip:AddLine(frame.tooltip)
		GameTooltip:Show()
	end
end

local function Control_OnLeave(frame)
	frame.obj:Fire("OnLeave")
	GameTooltip:Hide()
end

local function Keybinding_OnClick(frame, button)
	if button == "LeftButton" or button == "RightButton" then
		local self = frame.obj
		if self.waitingForKey then
			frame:EnableKeyboard(false)
			frame:EnableMouseWheel(false)
			self.msgframe:Hide()
			frame:UnlockHighlight()
			self.waitingForKey = nil
		else
			frame:EnableKeyboard(true)
			frame:EnableMouseWheel(true)
			self.msgframe:Show()
			frame:LockHighlight()
			self.waitingForKey = true
		end
	end
	AceGUI:ClearFocus()
end

local ignoreKeys = {
	["BUTTON1"] = true, ["BUTTON2"] = true,
	["UNKNOWN"] = true,
	["LSHIFT"] = true, ["LCTRL"] = true, ["LALT"] = true,
	["RSHIFT"] = true, ["RCTRL"] = true, ["RALT"] = true,
}
local function Keybinding_OnKeyDown(frame, key)
	local self = frame.obj
	if self.waitingForKey then
		local keyPressed = key
		if keyPressed == "ESCAPE" then
			keyPressed = ""
		else
			if ignoreKeys[keyPressed] then return end
			if IsShiftKeyDown() then
				keyPressed = "SHIFT-"..keyPressed
			end
			if IsControlKeyDown() then
				keyPressed = "CTRL-"..keyPressed
			end
			if IsAltKeyDown() then
				keyPressed = "ALT-"..keyPressed
			end
		end

		frame:EnableKeyboard(false)
		frame:EnableMouseWheel(false)
		self.msgframe:Hide()
		frame:UnlockHighlight()
		self.waitingForKey = nil

		if not self.disabled then
			self:SetKey(keyPressed)
			self:Fire("OnKeyChanged", keyPressed)
		end
	end
end

local function Keybinding_OnMouseDown(frame, button)
	if button == "LeftButton" or button == "RightButton" then
		return
	elseif button == "MiddleButton" then
		button = "BUTTON3"
	elseif button == "Button4" then
		button = "BUTTON4"
	elseif button == "Button5" then
		button = "BUTTON5"
	end
	Keybinding_OnKeyDown(frame, button)
end

local function Keybinding_OnMouseWheel(frame, direction)
	local button
	if direction >= 0 then
		button = "MOUSEWHEELUP"
	else
		button = "MOUSEWHEELDOWN"
	end
	Keybinding_OnKeyDown(frame, button)
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		self:SetWidth(200)
		self:SetLabel("")
		self:SetKey("")
		self.waitingForKey = nil
		self.msgframe:Hide()
		self:SetDisabled(false)
		self.button:EnableKeyboard(false)
		self.button:EnableMouseWheel(false)
	end,

	-- ["OnRelease"] = nil,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		if disabled then
			self.button:Disable()
			self.label:SetTextColor(0.5,0.5,0.5)
		else
			self.button:Enable()
			self.label:SetTextColor(1,1,1)
		end
	end,

	["SetKey"] = function(self, key)
		if (key or "") == "" then
			self.button:SetText(NOT_BOUND)
			self.button:SetNormalFontObject("GameFontNormal")
		else
			self.button:SetText(key)
			self.button:SetNormalFontObject("GameFontHighlight")
		end
	end,

	["GetKey"] = function(self)
		local key = self.button:GetText()
		if key == NOT_BOUND then
			key = nil
		end
		return key
	end,

	["SetLabel"] = function(self, label)
		self.label:SetText(label or "")
		if (label or "") == "" then
			self.alignoffset = nil
			self:SetHeight(24)
		else
			self.alignoffset = 30
			self:SetHeight(44)
		end
	end,
	
	["SetTooltip"] = function(self, tooltip)
		self.button.tooltip = tooltip
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]

local ControlBackdrop  = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true, tileSize = 16, edgeSize = 16,
	insets = { left = 3, right = 3, top = 3, bottom = 3 }
}

local function keybindingMsgFixWidth(frame)
	frame:SetWidth(frame.msg:GetWidth() + 10)
	frame:SetScript("OnUpdate", nil)
end

local function Constructor()
	local name = "AceGUI30KeybindingButton" .. AceGUI:GetNextWidgetNum(Type)

	local frame = CreateFrame("Frame", nil, UIParent)
	local button = CreateFrame("Button", name, frame, "UIPanelButtonTemplate")

	button:EnableMouse(true)
	button:EnableMouseWheel(false)
	button:RegisterForClicks("AnyDown")
	button:SetScript("OnEnter", Control_OnEnter)
	button:SetScript("OnLeave", Control_OnLeave)
	button:SetScript("OnClick", Keybinding_OnClick)
	button:SetScript("OnKeyDown", Keybinding_OnKeyDown)
	button:SetScript("OnMouseDown", Keybinding_OnMouseDown)
	button:SetScript("OnMouseWheel", Keybinding_OnMouseWheel)
	button:SetPoint("BOTTOMLEFT")
	button:SetPoint("BOTTOMRIGHT")
	button:SetHeight(24)
	button:EnableKeyboard(false)
	
	button.tooltip = ''

	local text = button:GetFontString()
	text:SetPoint("LEFT", 7, 0)
	text:SetPoint("RIGHT", -7, 0)

	local label = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	label:SetPoint("TOPLEFT")
	label:SetPoint("TOPRIGHT")
	label:SetJustifyH("CENTER")
	label:SetHeight(18)

	local msgframe = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	msgframe:SetHeight(30)
	msgframe:SetBackdrop(ControlBackdrop)
	msgframe:SetBackdropColor(0,0,0)
	msgframe:SetFrameStrata("FULLSCREEN_DIALOG")
	msgframe:SetFrameLevel(1000)
	msgframe:SetToplevel(true)

	local msg = msgframe:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	msg:SetText("Press a key to bind, ESC to clear the binding or click the button again to cancel.")
	msgframe.msg = msg
	msg:SetPoint("TOPLEFT", 5, -5)
	msgframe:SetScript("OnUpdate", keybindingMsgFixWidth)
	msgframe:SetPoint("BOTTOM", button, "TOP")
	msgframe:Hide()

	local widget = {
		button      = button,
		label       = label,
		msgframe    = msgframe,
		frame       = frame,
		alignoffset = 30,
		type        = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end
	button.obj = widget

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
end



--[[-----------------------------------------------------------------------------
Progress Bar Widget
-------------------------------------------------------------------------------]]
do
local Type, Version = "ProgressBar", 1
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local pairs, assert, type = pairs, assert, type
local wipe = table.wipe

-- WoW APIs
local PlaySound = PlaySound
local CreateFrame, UIParent = CreateFrame, UIParent

-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: CLOSE

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local progress = function(End, cur)
  local percentageDone = cur*100/End
  return percentageDone>100 and 100 or percentageDone
end
local round = function (val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		self.frame:SetParent(UIParent)
		self.frame:SetFrameStrata("FULLSCREEN_DIALOG")
		self:SetProgress(70)
		self:Show()
	end,

	["OnWidthSet"] = function(self, width)
		self.progressTexture:SetWidth(width-10)
		self:SetProgress()
		--[[local content = self.content
		local contentwidth = width - 34
		if contentwidth < 0 then
			contentwidth = 0
		end
		content:SetWidth(contentwidth)
		content.width = contentwidth]]
	end,

	["OnHeightSet"] = function(self, height)
		self.progressTexture:SetHeight(height-10)
		--[[local content = self.content
		local contentheight = height - 57
		if contentheight < 0 then
			contentheight = 0
		end
		content:SetHeight(contentheight)
		content.height = contentheight]]
	end,

	["SetStatusText"] = function(self, text)
		self.statustext:SetText(text)
	end,

	["SetPlaceholder"] = function(self, placeholder)
		self.statustext.placeholder = placeholder
	end,

	["Hide"] = function(self)
		self.frame:Hide()
	end,

	["Show"] = function(self)
		self.frame:Show()
	end,

	["SetProgress"] = function(self, cur)
		cur = (cur or 70) - self.progressTexture.min
		local max = self.progressTexture.max - self.progressTexture.min -- 1
		local percent = round(progress(max, cur))/100
		self.progressTexture:SetWidth((self.frame:GetWidth()-10)*percent)
		if self.statustext.type == 'time' then
			local time = max - cur
			self.statustext:SetText(self.statustext.placeholder:format(time>max and 0 or time))
		else
			self.statustext:SetText(self.statustext.placeholder:format(math.floor(percent*100)))
		end
	end,

	["GetProgress"] = function(self)
		return self.statustext:GetText()
	end,

	["SetType"] = function(self, type)
		self.statustext.type = type=="time" and "time" or "percent"
	end,

	["SetFont"] = function(self, font, height, flags)
		self.statustext:SetFont(font, height, flags)
	end,

	["SetMinMax"] = function(self, min, max)
		if min then 
			self.progressTexture.min = min
		end
		if max then
			self.progressTexture.max = max
		end
	end,

	["GetMinMax"] = function(self)
		return self.progressTexture.min, self.progressTexture.max
	end,
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local FrameBackdrop = {
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true, tileSize = 16, edgeSize = 16,
	insets = { left = 2, right = 2, top = 2, bottom = 2 }
}

local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	frame:Hide()

	frame:SetFrameStrata("FULLSCREEN_DIALOG")
	frame:SetBackdrop(FrameBackdrop)
	frame:SetBackdropColor(0, 0, 0, 1)
	frame:SetToplevel(true)
	frame:SetWidth(100)
	frame:SetHeight(24)

	local statustext = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	statustext:SetPoint("CENTER", 0, 0)
	statustext:SetHeight(frame:GetHeight())
	statustext:SetJustifyH("CENTER")
	statustext:SetText("123 test абв")
	statustext.type = 'percent'
	statustext.placeholder = '%u%%'
	
	local progressTexture = frame:CreateTexture()
	progressTexture:SetPoint("LEFT", 5, 0)
	progressTexture:SetHeight(frame:GetHeight())
	progressTexture:SetWidth(frame:GetWidth())
	progressTexture:SetColorTexture(1,0.5,0,0.4)
	progressTexture.max = 100
	progressTexture.min = 0

	local widget = {
		localstatus = {},
		statustext  = statustext,
		frame       = frame,
		progressTexture = progressTexture,
		type        = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
end


--[[-----------------------------------------------------------------------------
Button Widget
Graphical Button.
-------------------------------------------------------------------------------]]
local Type, Version = "TButton", 1
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local pairs = pairs

-- WoW APIs
local _G = _G
local PlaySound, CreateFrame, UIParent = PlaySound, CreateFrame, UIParent

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function Button_OnClick(frame, ...)
	AceGUI:ClearFocus()
	PlaySound(852) -- SOUNDKIT.IG_MAINMENU_OPTION
	frame.obj:Fire("OnClick", ...)
end

local function Control_OnEnter(frame)
	frame.obj:Fire("OnEnter")
	if frame.obj.tooltip ~= nil and frame.obj.tooltip ~= '' then
		GameTooltip:SetOwner(frame, "ANCHOR_TOP")
		GameTooltip:AddLine(frame.obj.tooltip)
		GameTooltip:Show()
	end
end

local function Control_OnLeave(frame)
	frame.obj:Fire("OnLeave")
	GameTooltip:Hide()
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		-- restore default values
		self:SetHeight(24)
		self:SetWidth(200)
		self:SetDisabled(false)
		self:SetAutoWidth(false)
		self:SetText()
	end,

	-- ["OnRelease"] = nil,

	["SetText"] = function(self, text)
		self.text:SetText(text)
		if self.autoWidth then
			self:SetWidth(self.text:GetStringWidth() + 30)
		end
	end,

	["SetAutoWidth"] = function(self, autoWidth)
		self.autoWidth = autoWidth
		if self.autoWidth then
			self:SetWidth(self.text:GetStringWidth() + 30)
		end
	end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		if disabled then
			self.frame:Disable()
		else
			self.frame:Enable()
		end
	end,
	
	["SetTooltip"] = function(self, tooltip)
		self.tooltip = tooltip
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
	local name = "AceGUI30Button" .. AceGUI:GetNextWidgetNum(Type)
	local frame = CreateFrame("Button", name, UIParent, "UIPanelButtonTemplate")
	frame:Hide()

	frame:EnableMouse(true)
	frame:SetScript("OnClick", Button_OnClick)
	frame:SetScript("OnEnter", Control_OnEnter)
	frame:SetScript("OnLeave", Control_OnLeave)
	
	frame.tooltip = ''

	local text = frame:GetFontString()
	text:ClearAllPoints()
	text:SetPoint("TOPLEFT", 15, -1)
	text:SetPoint("BOTTOMRIGHT", -15, 1)
	text:SetJustifyV("MIDDLE")

	local widget = {
		text  = text,
		frame = frame,
		type  = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
