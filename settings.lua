local addon = FGI
local fn = addon.functions
local L = FGI:GetLocale()
local size = L.settings.size
local interface = addon.interface
local GUI = LibStub("AceGUI-3.0")
local DB

local settings

local function updateMsgFilters()
	if DB.realm.systemMSG then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", fn.hideSysMsg)
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", fn.hideSysMsg)
	end
	if DB.realm.sendMSG then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", fn.hideWhisper)
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER_INFORM", fn.hideWhisper)
	end
end

interface.settings = CreateFrame("Frame", UIParent)
settings = interface.settings
settings.name = "Fast Guild Invite"
InterfaceOptions_AddCategory(settings)

--[[settings.profile = CreateFrame("Frame", settings)
settings.profile.name = "Profile"
-- settings.profile.refresh  = function(self)print(self:GetHeight())end
settings.profile.parent = settings.name
InterfaceOptions_AddCategory(settings.profile)]]

settings.Security = CreateFrame("Frame", settings)
settings.Security.name = L["Безопасность"]
settings.Security.parent = settings.name
InterfaceOptions_AddCategory(settings.Security)

settings.Guild = CreateFrame("Frame", settings)
settings.Guild.name = L["Гильдия"]
settings.Guild.parent = settings.name
InterfaceOptions_AddCategory(settings.Guild)

settings.filters = CreateFrame("Frame", settings)
settings.filters.name = L["Фильтры"]
settings.filters.parent = settings.name
InterfaceOptions_AddCategory(settings.filters)

settings.locations = CreateFrame("Frame", settings)
settings.locations.name = L["Поиск по локациям"]
settings.locations.parent = settings.name
InterfaceOptions_AddCategory(settings.locations)

settings.KeyBind = CreateFrame("Frame", settings)
settings.KeyBind.name = L["KeyBind"]
-- settings.KeyBind.refresh  = function(self)print(self,InterfaceOptionsFramePanelContainer.displayedPanel:GetHeight())end
settings.KeyBind.parent = settings.name
InterfaceOptions_AddCategory(settings.KeyBind)

settings.CustomizePost = CreateFrame("Frame", settings)
settings.CustomizePost.name = L["Настроить сообщения"]
settings.CustomizePost.parent = settings.name
InterfaceOptions_AddCategory(settings.CustomizePost)

settings.Blacklist = CreateFrame("Frame", settings)
settings.Blacklist.name = L["Черный список"]
settings.Blacklist.parent = settings.name
InterfaceOptions_AddCategory(settings.Blacklist)

settings.Synchronization = CreateFrame("Frame", settings)
settings.Synchronization.name = L["Синхронизация"]
settings.Synchronization.parent = settings.name
InterfaceOptions_AddCategory(settings.Synchronization)

settings.CustomInterface = CreateFrame("Frame", settings)
settings.CustomInterface.name = L["Настроить интерфейс"]
settings.CustomInterface.parent = settings.name
InterfaceOptions_AddCategory(settings.CustomInterface)

settings.CustomList = CreateFrame("Frame", settings)
settings.CustomList.name = L["Пользовательский список"]
settings.CustomList.parent = settings.name
InterfaceOptions_AddCategory(settings.CustomList)

settings.QuietList = CreateFrame("Frame", settings)
settings.QuietList.name = L["Тихие зоны"]
settings.QuietList.parent = settings.name
InterfaceOptions_AddCategory(settings.QuietList)

settings.credits = CreateFrame("Frame", settings)
settings.credits.name = L["Благодарности"]
settings.credits.parent = settings.name
InterfaceOptions_AddCategory(settings.credits)

settings.Logs = CreateFrame("Frame", settings)
settings.Logs.name = L["Логи"]
settings.Logs.parent = settings.name
InterfaceOptions_AddCategory(settings.Logs)

--[[settings.db = CreateFrame("Frame", settings)
settings.db.name = "DB"
settings.db.parent = settings.name
InterfaceOptions_AddCategory(settings.db)]]

-- InterfaceOptionsFrame_OpenToCategory(settings)
-- InterfaceOptionsFrame_OpenToCategory(settings)
-- InterfaceOptionsFrame_OpenToCategory(settings.CustomInterface)
-- InterfaceOptionsFrame_OpenToCategory(settings.CustomInterface)


local w,h = 623, 568
interface.settings.content = GUI:Create("SimpleGroup")
settings = interface.settings.content
settings:SetWidth(w-20)
settings:SetHeight(h-20)
settings.frame:SetParent(interface.settings)
settings:SetLayout("NIL")
settings:SetPoint("TOPLEFT", interface.settings, "TOPLEFT", 10, -10)


settings.settingsCheckBoxGRP = GUI:Create("GroupFrame")
local settingsCheckBoxGRP = settings.settingsCheckBoxGRP
settingsCheckBoxGRP:SetLayout("NIL")
settingsCheckBoxGRP:SetHeight(205)
settingsCheckBoxGRP:SetWidth(size.settingsCheckBoxGRP)
settingsCheckBoxGRP:SetPoint("TOPLEFT", settings.frame, "TOPLEFT", 0, 0)
settings:AddChild(settingsCheckBoxGRP)

settingsCheckBoxGRP.addonMSG = GUI:Create("TCheckBox")
local frame = settingsCheckBoxGRP.addonMSG
frame:SetWidth(size.addonMSG)
frame:SetLabel(L["Выключить сообщения аддона"])
frame:SetTooltip(L["Не отображать в чате сообщения аддона"])
frame.frame:HookScript("OnClick", function()
	DB.global.addonMSG = settingsCheckBoxGRP.addonMSG:GetValue()
end)
frame:SetPoint("TOPLEFT", settings.settingsCheckBoxGRP.frame, "TOPLEFT", 0, 0)
settingsCheckBoxGRP:AddChild(frame)

settingsCheckBoxGRP.systemMSG = GUI:Create("TCheckBox")
local frame = settingsCheckBoxGRP.systemMSG
frame:SetWidth(size.systemMSG)
frame:SetLabel(L["Выключить системные сообщения"])
frame:SetTooltip(L["Не отображать в чате системные сообщения"])
frame.frame:HookScript("OnClick", function()
	DB.realm.systemMSG = settingsCheckBoxGRP.systemMSG:GetValue()
	updateMsgFilters()

end)
frame:SetPoint("TOPLEFT", settings.settingsCheckBoxGRP.addonMSG.frame, "BOTTOMLEFT", 0, 0)
settingsCheckBoxGRP:AddChild(frame)

settingsCheckBoxGRP.sendMSG = GUI:Create("TCheckBox")
local frame = settingsCheckBoxGRP.sendMSG
frame:SetWidth(size.sendMSG)
frame:SetLabel(L["Выключить отправляемые сообщения"])
frame:SetTooltip(L["Не отображать в чате отправляемые сообщения"])
frame.frame:HookScript("OnClick", function()
	DB.realm.sendMSG = settingsCheckBoxGRP.sendMSG:GetValue()

end)
frame:SetPoint("TOPLEFT", settings.settingsCheckBoxGRP.systemMSG.frame, "BOTTOMLEFT", 0, 0)
settingsCheckBoxGRP:AddChild(frame)

settingsCheckBoxGRP.minimapButton = GUI:Create("TCheckBox")
local frame = settingsCheckBoxGRP.minimapButton
frame:SetWidth(size.minimapButton)
frame:SetLabel(L["Не отображать значок у миникарты"])
frame:SetTooltip("")
frame.frame:HookScript("OnClick", function()
	DB.global.minimap.hide = settingsCheckBoxGRP.minimapButton:GetValue()
	if DB.global.minimap.hide then
		addon.icon:Hide("FGI")
	else
		addon.icon:Show("FGI")
	end
end)
frame:SetPoint("TOPLEFT", settings.settingsCheckBoxGRP.sendMSG.frame, "BOTTOMLEFT", 0, 0)
settingsCheckBoxGRP:AddChild(frame)

settingsCheckBoxGRP.createMenuButtons = GUI:Create("TCheckBox")
local frame = settingsCheckBoxGRP.createMenuButtons
frame:SetWidth(size.createMenuButtons)
frame:SetLabel(L["Добавлять кнопки аддона в выпадающее меню"])
frame:SetTooltip(L["Требуется перезагрузка интерфейса"])
frame.frame:HookScript("OnClick", function()
	DB.global.createMenuButtons = settingsCheckBoxGRP.createMenuButtons:GetValue()
end)
frame:SetPoint("TOPLEFT", settings.settingsCheckBoxGRP.minimapButton.frame, "BOTTOMLEFT", 0, 0)
settingsCheckBoxGRP:AddChild(frame)

settingsCheckBoxGRP.queueNotify = GUI:Create("TCheckBox")
local frame = settingsCheckBoxGRP.queueNotify
frame:SetWidth(size.queueNotify)
frame:SetLabel(L["Уведомление о найденных игроках"])
frame.frame:HookScript("OnClick", function()
	DB.global.queueNotify = settingsCheckBoxGRP.queueNotify:GetValue()
end)
frame:SetPoint("TOPLEFT", settings.settingsCheckBoxGRP.createMenuButtons.frame, "BOTTOMLEFT", 0, 0)
settingsCheckBoxGRP:AddChild(frame)

settingsCheckBoxGRP.searchAlertNotify = GUI:Create("TCheckBox")
local frame = settingsCheckBoxGRP.searchAlertNotify
frame:SetWidth(size.searchAlertNotify)
frame:SetLabel(L["Уведомление о готовности нового поиска"])
frame.frame:HookScript("OnClick", function()
	DB.global.searchAlertNotify = settingsCheckBoxGRP.searchAlertNotify:GetValue()
end)
frame:SetPoint("TOPLEFT", settings.settingsCheckBoxGRP.queueNotify.frame, "BOTTOMLEFT", 0, 0)
settingsCheckBoxGRP:AddChild(frame)

settingsCheckBoxGRP.blacklistOfficer = GUI:Create("TCheckBox")
local frame = settingsCheckBoxGRP.blacklistOfficer
frame:SetWidth(size.blacklistOfficer)
frame:SetLabel(L["Сообщать о добавлении в черный список в офицерский канал."])
frame.frame:HookScript("OnClick", function()
	DB.global.blacklistOfficer = settingsCheckBoxGRP.blacklistOfficer:GetValue()
end)
frame:SetPoint("TOPLEFT", settings.settingsCheckBoxGRP.searchAlertNotify.frame, "BOTTOMLEFT", 0, 0)
settingsCheckBoxGRP:AddChild(frame)

settingsCheckBoxGRP.rememberAll = GUI:Create("TCheckBox")
local frame = settingsCheckBoxGRP.rememberAll
frame:SetWidth(size.rememberAll)
frame:SetLabel(L["Запоминать всех игроков"])
frame:SetTooltip(L["Записывать игрока в базу данных даже если приглашение не было отправлено"])
frame.frame:HookScript("OnClick", function()
	DB.global.rememberAll = settingsCheckBoxGRP.rememberAll:GetValue()
end)
frame:SetPoint("TOPLEFT", settings.settingsCheckBoxGRP.blacklistOfficer.frame, "BOTTOMLEFT", 0, 0)
settingsCheckBoxGRP:AddChild(frame)




settings.clearDBtimes = GUI:Create("Dropdown")
local frame = settings.clearDBtimes
frame:SetWidth(size.clearDBtimes)
frame:SetLabel(L["Время запоминания игрока"])
frame:SetList({L["Отключить"], L["1 день"], L["1 неделя"], L["1 месяц"], L["6 месяцев"],})
frame:SetCallback("OnValueChanged", function(key)
	DB.global.clearDBtimes = settings.clearDBtimes:GetValue()
end)
frame:SetPoint("TOPLEFT", settings.settingsCheckBoxGRP.rememberAll.frame, "BOTTOMLEFT", 0, 0)
settings:AddChild(frame)

settingsCheckBoxGRP.confirmSearchClear = GUI:Create("TCheckBox")
local frame = settingsCheckBoxGRP.confirmSearchClear
frame:SetWidth(size.confirmSearchClear)
frame:SetLabel(L["Требовать подтверждение сброса поиска"])
frame.frame:HookScript("OnClick", function()
	DB.global.confirmSearchClear = settingsCheckBoxGRP.confirmSearchClear:GetValue()
end)
frame:SetPoint("TOPLEFT", settings.clearDBtimes.frame, "BOTTOMLEFT", 0, 0)
settingsCheckBoxGRP:AddChild(frame)

settingsCheckBoxGRP.saveSearch = GUI:Create("TCheckBox")
local frame = settingsCheckBoxGRP.saveSearch
frame:SetWidth(size.saveSearch)
frame:SetLabel(L["Сохранить состояние поиска"])
frame:SetTooltip(L["Сохранить состояние поиска между сессиями"])
frame.frame:HookScript("OnClick", function()
	DB.global.saveSearch = settingsCheckBoxGRP.saveSearch:GetValue()
	if not DB.global.saveSearch then
		DB.factionrealm.search = nil
	end
end)
frame:SetPoint("TOPLEFT", settingsCheckBoxGRP.confirmSearchClear.frame, "BOTTOMLEFT", 0, 0)
settingsCheckBoxGRP:AddChild(frame)

settingsCheckBoxGRP.showUpdateInfo = GUI:Create("TCheckBox")
local frame = settingsCheckBoxGRP.showUpdateInfo
frame:SetWidth(size.showUpdateInfo)
frame:SetLabel(L["Обновления"])
frame:SetTooltip(L["Показывать список обновлений"])
frame.frame:HookScript("OnClick", function()
	DB.global.introShow = settingsCheckBoxGRP.showUpdateInfo:GetValue()
end)
frame:SetPoint("TOPLEFT", settingsCheckBoxGRP.saveSearch.frame, "BOTTOMLEFT", 0, 0)
settingsCheckBoxGRP:AddChild(frame)

settingsCheckBoxGRP.quietZones = GUI:Create("TCheckBox")
local frame = settingsCheckBoxGRP.quietZones
frame:SetWidth(size.quietZones)
frame:SetLabel(L["Игнорировать тихие зоны"])
frame:SetTooltip(L["Игнорировать игроков в рейдах, подземельях, аренах, полях боя. (только текущее дополнение)"])
frame.frame:HookScript("OnClick", function()
	DB.global.quietZones = settingsCheckBoxGRP.quietZones:GetValue()
end)
frame:SetPoint("TOPLEFT", settingsCheckBoxGRP.showUpdateInfo.frame, "BOTTOMLEFT", 0, 0)
settingsCheckBoxGRP:AddChild(frame)









-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB

	settingsCheckBoxGRP.addonMSG:SetValue(DB.global.addonMSG or false)
	settingsCheckBoxGRP.systemMSG:SetValue(DB.realm.systemMSG or false)
	settingsCheckBoxGRP.sendMSG:SetValue(DB.realm.sendMSG or false)
	settingsCheckBoxGRP.minimapButton:SetValue(DB.global.minimap.hide or false)
	settingsCheckBoxGRP.rememberAll:SetValue(DB.global.rememberAll or false)
	settingsCheckBoxGRP.createMenuButtons:SetValue(DB.global.createMenuButtons or false)
	settingsCheckBoxGRP.queueNotify:SetValue(DB.global.queueNotify or false)
	settingsCheckBoxGRP.searchAlertNotify:SetValue(DB.global.searchAlertNotify or false)
	settingsCheckBoxGRP.blacklistOfficer:SetValue(DB.global.blacklistOfficer or false)
	settings.clearDBtimes:SetValue(DB.global.clearDBtimes)
	settingsCheckBoxGRP.confirmSearchClear:SetValue(DB.global.confirmSearchClear or false)
	settingsCheckBoxGRP.saveSearch:SetValue(DB.global.saveSearch or false)
	settingsCheckBoxGRP.showUpdateInfo:SetValue(DB.global.introShow or false)
	settingsCheckBoxGRP.quietZones:SetValue(DB.global.quietZones or false)


	updateMsgFilters()
end)
