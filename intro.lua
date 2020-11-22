local addon = FGI
local fn = addon.functions
local color = addon.color
local interface = addon.interface
local GUI = LibStub("AceGUI-3.0")
local DB
local fontSize = fn.fontSize
local L = {
	ruRU = {
		head = "Спасибо, что помогаете делать аддон лучше.",
		support = "Ниже вы можете найти ссылки если вы хотите материально поддержать автора.",
		laterButton = "Напомнить при обновлении аддона",
		neverButton = "Больше не показывать",
		
		
		updates = {
			"В окно сканирования возвращена кнопка сброс. Она находится в правом нижнем углу, обозначена значком \"R\".",
			"Добавлена дополнительная линия информации об игроке, длинные имя и реалм отображались не полностью.",
			"Добавлена поддержка Raider.IO. При наведении мыши на информацию об игроке в подсказке отображается информация Raider.IO, если это возможно.",
		},
		
		
	},
	enUS = {
		head = "Thanks for helping make the addon better.",
		support = "Below you can find links if you want to financially support the author.",
		laterButton = "Remind me when updating addon",
		neverButton = "Do not show again",
		
		
		updates = {
			"Reset button returned to scan window. It is located in the lower right corner, indicated by an \"R\".",
			"Added additional line of information about the player, long name and realm were not fully displayed.",
			"Added support for Raider.IO. When you hover the mouse over the player information, the tooltip displays the Raider.IO information, if possible.",
		},
	}
}
L = GetLocale() == "ruRU" and L.ruRU or L.enUS

local function btnText(frame)
	local text = frame.text
	text:ClearAllPoints()
	text:SetPoint("TOPLEFT", 5, -1)
	text:SetPoint("BOTTOMRIGHT", -5, 1)
end

local function EditBoxChange(frame)
	frame.editbox:SetScript("OnEnterPressed", function(self)
		self:ClearFocus()
	end)
	frame.editbox:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
end


do		--	intro
interface.intro = GUI:Create("ClearFrame")
intro = interface.intro
intro:SetTitle("Fast Guild Invite v."..addon.version)
intro:SetWidth(600)
intro:SetHeight(640)
intro:SetLayout("NIL")
intro:SetPoint("CENTER", UIParent)

intro.head = GUI:Create("TLabel")
local frame = intro.head
frame:SetText(L.head)
fontSize(frame.label, false, 24)
-- fontSize(frame.label)
frame.label:SetJustifyH("CENTER")
frame:SetWidth(intro.frame:GetWidth() - 40)
frame:SetPoint("TOP", intro.frame, "TOP", 0, -40)
intro:AddChild(frame)

intro.updates = GUI:Create("TLabel")
local frame = intro.updates
fontSize(frame.label)
frame.label:SetJustifyH("LEFT")
frame:SetWidth(intro.frame:GetWidth() - 40)
frame:SetPoint("TOP", intro.head.frame, "BOTTOM", 0, -20)
intro:AddChild(frame)

intro.body = GUI:Create("TLabel")
local frame = intro.body
frame:SetText(L.support)
fontSize(frame.label)
frame.label:SetJustifyH("CENTER")
frame:SetWidth(intro.frame:GetWidth() - 40)
frame:SetPoint("TOP", intro.updates.frame, "BOTTOM", 0, -20)
intro:AddChild(frame)






intro.showLater = GUI:Create("Button")
local frame = intro.showLater
frame:SetText(L.laterButton)
fontSize(frame.text)
btnText(frame)
frame:SetWidth(360)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	intro:Hide()
	DB.global.introShow = addon.version
end)
frame:SetPoint("BOTTOMLEFT", intro.frame, "BOTTOMLEFT", 20, 20)
intro:AddChild(frame)

intro.showNever = GUI:Create("Button")
local frame = intro.showNever
frame:SetText(L.neverButton)
fontSize(frame.text)
btnText(frame)
frame:SetWidth(200)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	intro:Hide()
	DB.global.introShow = false
end)
frame:SetPoint("LEFT", intro.showLater.frame, "RIGHT", 0, 0)
intro:AddChild(frame)

intro.discordE = GUI:Create("EditBox")
local frame = intro.discordE
frame:SetWidth(250)
frame:DisableButton(true)
EditBoxChange(frame)
frame:SetPoint("BOTTOMLEFT", intro.showLater.frame, "TOPLEFT", 0, 20)
frame:SetText("https://discord.gg/4mU5att")
intro:AddChild(frame)

intro.discordL = GUI:Create("TLabel")
local frame = intro.discordL
frame:SetText("Discord")
fontSize(frame.label)
frame.label:SetJustifyH("LEFT")
frame:SetWidth(intro.frame:GetWidth() - 40)
frame:SetPoint("BOTTOMLEFT", intro.discordE.frame, "TOPLEFT", 0, 0)
intro:AddChild(frame)

intro.patreonE = GUI:Create("EditBox")
local frame = intro.patreonE
frame:SetWidth(250)
frame:DisableButton(true)
EditBoxChange(frame)
frame:SetPoint("BOTTOMLEFT", intro.discordL.frame, "TOPLEFT", 0, 20)
frame:SetText(color.orange.."https://www.patreon.com/FastGuildInvite")
intro:AddChild(frame)

intro.patreonL = GUI:Create("TLabel")
local frame = intro.patreonL
frame:SetText(color.orange.."Patreon")
fontSize(frame.label)
frame.label:SetJustifyH("LEFT")
frame:SetWidth(intro.frame:GetWidth() - 40)
frame:SetPoint("BOTTOMLEFT", intro.patreonE.frame, "TOPLEFT", 0, 0)
intro:AddChild(frame)

intro.paypalE = GUI:Create("EditBox")
local frame = intro.paypalE
frame:SetWidth(250)
frame:DisableButton(true)
EditBoxChange(frame)
frame:SetPoint("BOTTOMLEFT", intro.patreonL.frame, "TOPLEFT", 0, 20)
frame:SetText(color.blue.."https://www.paypal.me/Knoot")
intro:AddChild(frame)

intro.paypalL = GUI:Create("TLabel")
local frame = intro.paypalL
frame:SetText(color.blue.."PayPal")
fontSize(frame.label)
frame.label:SetJustifyH("LEFT")
frame:SetWidth(intro.frame:GetWidth() - 40)
frame:SetPoint("BOTTOMLEFT", intro.paypalE.frame, "TOPLEFT", 0, 0)
intro:AddChild(frame)

end




-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB
	
	
	if not DB.global.introShow or DB.global.introShow == addon.version or tonumber(FGI.version) == nil then
		intro:Hide()
	else
		local str = ""
		for i=1, #L.updates do
			str = format("%s\n    %d. %s", str, i, L.updates[i])
		end
		intro.updates:SetText(str)
	end
end)
