--[[-----------------------------------------------------------------------------
Progress Bar Widget
-------------------------------------------------------------------------------]]
local Type, Version = "ProgressBar", 1
local AceKGUI = LibStub and LibStub("AceKGUI-3.0", true)
if not AceKGUI or (AceKGUI:GetWidgetVersion(Type) or 0) >= Version then return end

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
	local frame = CreateFrame("Frame", nil, UIParent)
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

	return AceKGUI:RegisterAsWidget(widget)
end

AceKGUI:RegisterWidgetType(Type, Constructor, Version)
