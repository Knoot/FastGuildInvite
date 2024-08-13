local addon = FGI
local fn = addon.functions
local L = FGI:GetLocale()
local settings = L.settings
local size = settings.size
local interface = addon.interface
local GUI = LibStub("AceGUI-3.0")
local DB


local function btnText(frame)
	local text = frame.text
	text:ClearAllPoints()
	text:SetPoint("TOPLEFT", 5, -1)
	text:SetPoint("BOTTOMRIGHT", -5, 1)
end

local dumpWindow, buttonGroup

do		--	dump
interface.dumpWindow = GUI:Create("ClearFrame")
dumpWindow = interface.dumpWindow
dumpWindow:SetTitle("Fast Guild Invite Dump")
dumpWindow:SetWidth(size.dumpWindowW)
dumpWindow:SetHeight(size.dumpWindowH)
dumpWindow:SetLayout("NIL")

dumpWindow.title:SetScript('OnMouseUp', function(mover)
	local frame = mover:GetParent()
	frame:StopMovingOrSizing()
	local self = frame.obj
	local status = self.status or self.localstatus
	status.width = frame:GetWidth()
	status.height = frame:GetHeight()
	status.top = frame:GetTop()
	status.left = frame:GetLeft()
	
	local point, relativeTo,relativePoint, xOfs, yOfs = dumpWindow.frame:GetPoint(1)
	DB.global.dumpWindow = {}
	DB.global.dumpWindow.point=point
	DB.global.dumpWindow.relativeTo=relativeTo
	DB.global.dumpWindow.relativePoint=relativePoint
	DB.global.dumpWindow.xOfs=xOfs
	DB.global.dumpWindow.yOfs=yOfs
end)

dumpWindow.closeButton = GUI:Create('Button')
local frame = dumpWindow.closeButton
frame:SetText('X')
frame:SetWidth(frame.frame:GetHeight())
fn:closeBtn(frame)
frame:SetCallback('OnClick', function()
	interface.dumpWindow:Hide()
end)
frame:SetPoint("TOPRIGHT", dumpWindow.frame, "TOPRIGHT", 8, 8)
dumpWindow:AddChild(frame)


dumpWindow.list = GUI:Create("MultiLineEditBox")
local frame = dumpWindow.list
frame:SetLabel("")
frame:SetNumLines(39)
frame:SetWidth(size.dumpWindowW-200)
frame:DisableButton(true)
frame:SetPoint("TOPRIGHT", dumpWindow.frame, "TOPRIGHT", -20, -20)
dumpWindow:AddChild(frame)


dumpWindow.buttonGroup = GUI:Create("GroupFrame")
buttonGroup = dumpWindow.buttonGroup
buttonGroup:SetLayout("NIL")
buttonGroup:SetHeight(size.buttonGroupH)
buttonGroup:SetWidth(size.buttonGroupW)
buttonGroup:SetPoint("TOPLEFT", dumpWindow.frame, "TOPLEFT", 20, -20)
dumpWindow:AddChild(buttonGroup)

buttonGroup.baseInfo = GUI:Create("Button")
local frame = buttonGroup.baseInfo
frame:SetText(L["Общее"])
btnText(frame)
frame:SetWidth(size.buttonGroupW)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	local str = "";
	local filters = 0;
	if DB.realm.enableFilters then
		for k, v in pairs(DB.realm.filtersList) do
			if v.filterOn then
				filters = filters + 1
			end
		end
	end
	str = format("%sAddon version: **%s**\n", str, addon.version)							-- Addon version
	str = format("%sAddon game version: **%s**\n", str, addon.gversion)						-- Addon game version
	str = format("%sGame version: **%s**\n", str, GetBuildInfo())							-- Game version
	str = format("%sRealm: **%s**\n", str, GetRealmName())									-- Realm
	str = format("%sLevel range: %d-%d\n", str, DB.global.lowLimit, DB.global.highLimit)	-- Level range
	str = format("%sFilters: %s\n", str, filters == 0 and "Off" or filters)					-- Filters
	str = format("%sCustom list: %s\n", str, DB.realm.customWho and "True" or "False")		-- Custom list
	str = format("%sInvite mode: %s\n", str, DB.global.inviteType)							-- Invite mode
	-- str = format("%s%s\n", str, )	-- 
	dumpWindow.list:SetText(str)
end)
frame:SetPoint("TOPLEFT", buttonGroup.frame, "TOPLEFT", 0, 0)
buttonGroup:AddChild(frame)

buttonGroup.filters = GUI:Create("Button")
local frame = buttonGroup.filters
frame:SetText(L["Фильтры"])
btnText(frame)
frame:SetWidth(size.buttonGroupW)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	local str = "Filters list:\n";
	if DB.realm.enableFilters then
		for fName, v in pairs(DB.realm.filtersList) do
			if v.filterOn then
				-- v.rioRaid = v.rioRaid or {}
				local rioRaid = (v.rioRaid and v.rioRaid.name) and format("name: %s; %d|%d|%d", tostring(v.rioRaid.name) or '', v.rioRaid[0], v.rioRaid[1], v.rioRaid[2]) or "false"
				local classFilter = ""
				local raceFilter = ""
				if v.classFilter then
					for className,v in pairs(v.classFilter) do
						classFilter = classFilter..className..", "
					end
				end
				if v.raceFilter then
					for raceName,v in pairs(v.raceFilter) do
						raceFilter = raceFilter..raceName..", "
					end
				end
				str = format([=[%s**%s**:
filterByName: %s
lvlRange: %s
rioMPlus: %s
rioRaid: %s
classFilter: %s
raceFilter: %s

]=], str, fName, tostring(v.filterByName), tostring(v.lvlRange), tostring(v.rioMPlus), rioRaid, classFilter, raceFilter)	-- Filters
				
			end
		end
	end
	
	dumpWindow.list:SetText(str)
end)
frame:SetPoint("TOPLEFT", buttonGroup.baseInfo.frame, "BOTTOMLEFT", 0, -10)
buttonGroup:AddChild(frame)

buttonGroup.includedAddons = GUI:Create("Button")
local frame = buttonGroup.includedAddons
frame:SetText(L["Аддоны"])
btnText(frame)
frame:SetWidth(size.buttonGroupW)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	local str = "Included addons\n";
	for i=1,GetNumAddOns() do
		local name, title, notes, loadable, reason, security, newVersion = GetAddOnInfo(i);
		local version = C_AddOns.GetAddOnMetadata(i, 'Version')
		if reason ~= "DISABLED" then
			str = format("%s%s (%s) - %s\n", str, name, version or 'unknown', reason or 'ENABLED')	-- addon
		end
	end
	
	dumpWindow.list:SetText(str)
end)
frame:SetPoint("TOPLEFT", buttonGroup.filters.frame, "BOTTOMLEFT", 0, -10)
buttonGroup:AddChild(frame)

buttonGroup.areas = GUI:Create("Button")
local frame = buttonGroup.areas
frame:SetText(L["Зоны"])
btnText(frame)
frame:SetWidth(size.buttonGroupW)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	local str = "";
	for k,_ in pairs(fn.getAreas()) do
		str = format("%s\n%s", str, k)	-- areas
	end
	
	dumpWindow.list:SetText(str)
end)
frame:SetPoint("TOPLEFT", buttonGroup.includedAddons.frame, "BOTTOMLEFT", 0, -10)
buttonGroup:AddChild(frame)



end




-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB
	
	if DB.global.dumpWindow then
		interface.dumpWindow:ClearAllPoints()
		interface.dumpWindow:SetPoint(DB.global.dumpWindow.point, UIParent, DB.global.dumpWindow.relativePoint, DB.global.dumpWindow.xOfs, DB.global.dumpWindow.yOfs)
	else
		interface.dumpWindow:SetPoint("CENTER", UIParent)
	end
	
	interface.dumpWindow:Hide()
end)
