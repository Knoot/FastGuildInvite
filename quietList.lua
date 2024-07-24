local addon = FGI
local fn = addon.functions
local L = addon:GetLocale()
local settings = L.settings
local size = settings.size
local interface = addon.interface
local GUI = LibStub("AceGUI-3.0")
local DB

local QuietList

local function btnText(frame)
	local text = frame.text
	text:ClearAllPoints()
	text:SetPoint("TOPLEFT", 5, -1)
	text:SetPoint("BOTTOMRIGHT", -5, 1)
end

local w,h = 623, 568
interface.settings.QuietList = GUI:Create("GroupFrame")
QuietList = interface.settings.QuietList
QuietList:SetLayout("NIL")
interface.settings:AddChild(QuietList)
interface.settings.AddContent('QuietList', L["Тихие зоны"], QuietList, w-20, h-20)


QuietList.list = GUI:Create("MultiLineEditBox")
local frame = QuietList.list
frame:SetLabel("")
frame:SetHeight(h-60)
frame:SetNumLines(35)
frame:SetWidth(w-10)
frame:DisableButton(true)
frame:SetPoint("TOP", QuietList.frame, "TOP", 0, 0)
QuietList:AddChild(frame)

QuietList.saveButton = GUI:Create("Button")
local frame = QuietList.saveButton
frame:SetText(L["Сохранить"])
btnText(frame)
frame:SetWidth(size.saveButton)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	DB.global.customQuietList = {}
	for k,v in pairs(table.pack(fn:split(QuietList.list:GetText(),"\n"))) do
		print(1,v, fn.getStaticAreas()[v])
		if v~="" and not fn.getStaticAreas()[v] then
			table.insert(DB.global.customQuietList, v)
			print(2,v)
		end
		for k,v in pairs(DB.global.customQuietList) do 
			print(v)
		end
	end
	-- force cache update
	fn.getAreas(true);
end)
frame:SetPoint("BOTTOM", QuietList.frame, "BOTTOM", 0, 0)
QuietList:AddChild(frame)



-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB
	local str = ''
	for i=1,#DB.global.customQuietList do
		str = format("%s%s\n", str, DB.global.customQuietList[i])
	end
	QuietList.list:SetText(str)
end)
