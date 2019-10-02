--[[-----------------------------------------------------------------------------
Icon Widget
-------------------------------------------------------------------------------]]
local Type, Version = "Icon", 21
local AceKGUI = LibStub and LibStub("AceKGUI-3.0", true)
if not AceKGUI or (AceKGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local select, pairs, print = select, pairs, print

-- WoW APIs
local CreateFrame, UIParent, GetBuildInfo = CreateFrame, UIParent, GetBuildInfo

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

local function Button_OnClick(frame, button)
	frame.obj:Fire("OnClick", button)
	AceKGUI:ClearFocus()
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		self:SetHeight(110)
		self:SetWidth(110)
		self:SetLabel()
		self:SetImage(nil)
		self:SetImageSize(64, 64)
		self:SetDisabled(false)
	end,

	-- ["OnRelease"] = nil,

	["SetLabel"] = function(self, text)
		if text and text ~= "" then
			self.label:Show()
			self.label:SetText(text)
			self:SetHeight(self.image:GetHeight() + 25)
		else
			self.label:Hide()
			self:SetHeight(self.image:GetHeight() + 10)
		end
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
	end,

	["SetTex"] = function(self, normal, highlight, pushed, disabled)
		local frame = self.frame
		
		disabled = disabled and disabled or normal
		
		self.ntex:ClearAllPoints()
		self.htex:ClearAllPoints()
		self.ptex:ClearAllPoints()
		self.dtex:ClearAllPoints()
		
		frame:SetNormalTexture(normal)
		frame:SetHighlightTexture(highlight)
		frame:SetPushedTexture(pushed)
		frame:SetDisabledTexture(disabled)
		
		self.ntex:SetAllPoints()
		self.htex:SetAllPoints()
		self.ptex:SetAllPoints()
		self.dtex:SetAllPoints()
	end,

	["SetImageSize"] = function(self, width, height)
		self.image:SetWidth(width)
		self.image:SetHeight(height)
		--self.frame:SetWidth(width + 30)
		if self.label:IsShown() then
			self:SetHeight(height + 25)
		else
			self:SetHeight(height + 10)
		end
	end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		if disabled then
			self.frame:Disable()
			self.label:SetTextColor(0.5, 0.5, 0.5)
			self.image:SetVertexColor(0.5, 0.5, 0.5, 0.5)
		else
			self.frame:Enable()
			self.label:SetTextColor(1, 1, 1)
			self.image:SetVertexColor(1, 1, 1, 1)
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
	local frame = CreateFrame("Button", nil, UIParent)
	frame:Hide()

	frame:EnableMouse(true)
	frame:SetScript("OnEnter", Control_OnEnter)
	frame:SetScript("OnLeave", Control_OnLeave)
	frame:SetScript("OnClick", Button_OnClick)

	local label = frame:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
	label:SetPoint("BOTTOMLEFT")
	label:SetPoint("BOTTOMRIGHT")
	label:SetJustifyH("CENTER")
	label:SetJustifyV("TOP")
	label:SetHeight(18)

	local image = frame:CreateTexture(nil, "BACKGROUND")
	image:SetWidth(64)
	image:SetHeight(64)
	image:SetPoint("TOP", 0, -5)
	
	local ntex = frame:CreateTexture()
	--[[ntex:SetTexture("Interface\\AddOns\\RaidRollHelper\\Textures\\inv_alchemy_potion_Up")
	ntex:SetTexCoord(0, 0.625, 0, 0.6875)
	ntex:SetAllPoints()]]
	frame:SetNormalTexture(ntex)

	local htex = frame:CreateTexture()
	--[[htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
	htex:SetTexCoord(0, 0.625, 0, 0.6875)
	htex:SetAllPoints()]]
	frame:SetHighlightTexture(htex)

	local ptex = frame:CreateTexture()
	--[[ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
	ptex:SetTexCoord(0, 0.625, 0, 0.6875)
	ptex:SetAllPoints()]]
	frame:SetPushedTexture(ptex)

	local dtex = frame:CreateTexture()
	--[[ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
	ptex:SetTexCoord(0, 0.625, 0, 0.6875)
	ptex:SetAllPoints()]]
	frame:SetDisabledTexture(dtex)

	local widget = {
		label = label,
		image = image,
		frame = frame,
		ntex = ntex,
		htex = htex,
		ptex = ptex,
		dtex = dtex,
		type  = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end
	-- SetText is deprecated, but keep it around for a while. (say, to WoW 4.0)
	if (select(4, GetBuildInfo()) < 40000) then
		widget.SetText = widget.SetLabel
	else
		widget.SetText = function(self, ...) print("AceKGUI-3.0-Icon: SetText is deprecated! Use SetLabel instead!"); self:SetLabel(...) end
	end

	return AceKGUI:RegisterAsWidget(widget)
end

AceKGUI:RegisterWidgetType(Type, Constructor, Version)
