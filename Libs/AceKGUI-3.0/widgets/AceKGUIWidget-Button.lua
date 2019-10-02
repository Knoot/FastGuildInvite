--[[-----------------------------------------------------------------------------
Button Widget
Graphical Button.
-------------------------------------------------------------------------------]]
local Type, Version = "Button", 21
local AceKGUI = LibStub and LibStub("AceKGUI-3.0", true)
if not AceKGUI or (AceKGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local pairs = pairs

-- WoW APIs
local _G = _G
local PlaySound, CreateFrame, UIParent = PlaySound, CreateFrame, UIParent

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function Button_OnClick(frame, ...)
	AceKGUI:ClearFocus()
	--PlaySound("igMainMenuOption")
	frame.obj:Fire("OnClick", ...)
end

local function Control_OnEnter(frame)
	if frame.obj.tooltip ~= nil and frame.obj.tooltip ~= '' then
		GameTooltip:SetOwner(frame, "ANCHOR_TOP")
		GameTooltip:AddLine(frame.obj.tooltip)
		GameTooltip:Show()
	end
	frame.obj:Fire("OnEnter")
end

local function Control_OnLeave(frame)
	GameTooltip:Hide()
	frame.obj:Fire("OnLeave")
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
		self:SetText()
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
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
	local name = "AceKGUI30Button" .. AceKGUI:GetNextWidgetNum(Type)
	local frame = CreateFrame("Button", name, UIParent, "UIPanelButtonTemplate")
	frame:Hide()
	
	frame.tooltip = ''

	frame:EnableMouse(true)
	frame:SetScript("OnClick", Button_OnClick)
	frame:SetScript("OnEnter", Control_OnEnter)
	frame:SetScript("OnLeave", Control_OnLeave)

	local text = frame:GetFontString()
	text:ClearAllPoints()
	text:SetPoint("TOPLEFT", 5, -1)
	text:SetPoint("BOTTOMRIGHT", -5, 1)
	text:SetJustifyV("MIDDLE")

	local widget = {
		text  = text,
		frame = frame,
		type  = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceKGUI:RegisterAsWidget(widget)
end

AceKGUI:RegisterWidgetType(Type, Constructor, Version)
