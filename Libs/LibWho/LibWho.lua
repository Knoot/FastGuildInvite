local MAJOR,MINOR = "FGI-WhoLib", 2
local libWho, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not libWho then return end

local i, result, total, num, info, whoFrame, searchIntervalActionEnd

local _G, type = _G, type


libWho.whoQuery=''
libWho.saveShown=false
libWho.isAddon=false
libWho.frameAlpha = 1
libWho.callback = false
libWho.timeCallbackStart = false
libWho.timeCallbackEnd = false
libWho.interval = 5

local function searchIntervalActionEnd()
	C_Timer.After(libWho.interval, function()
		libWho.timeCallbackEnd()
	end)
end

local function searchIntervalActionStart()
	if type(libWho.timeCallbackStart) == "function" then
		libWho.timeCallbackStart()
	end
	if type(libWho.timeCallbackEnd) == "function" then
		searchIntervalActionEnd()
	end
end


function libWho:SetCallback(callback)
	self.callback = callback
end

function libWho:SetInterval(interval)
	libWho.interval = interval
end

function libWho:GetInterval()
	return libWho.interval
end

function libWho:SetTimeCallbackStart(callback)
	libWho.timeCallbackStart = callback
end

function libWho:SetTimeCallbackEnd(callback)
	libWho.timeCallbackEnd = callback
end

function libWho:GetWho(query)
	libWho.isAddon = true
	libWho.whoQuery = query
	libWho.saveShown = false
	i=1
	
	if FriendsFrame:IsShown() then
		while(_G["FriendsFrameTab"..i]) do
			if not _G["FriendsFrameTab"..i]:IsEnabled() then
				libWho.saveShown = _G["FriendsFrameTab"..i]
				break
			end
			i = i+1
		end
	else
		libWho.frameAlpha = FriendsFrame:GetAlpha()
		FriendsFrame:SetAlpha(0)
		FriendsFrame:Show()
	end
	
	C_FriendList.SetWhoToUi(true)
	C_FriendList.SendWho(query)
	WhoFrameEditBox:SetText(query)
end

function libWho:returnWho(result)
	-- searchWhoResultCallback(libWho.whoQuery, result)
	if type(libWho.callback) == "function" then
		libWho.callback(self.whoQuery, result)
	end
end

whoFrame = CreateFrame('Frame')
whoFrame:RegisterEvent("WHO_LIST_UPDATE")
whoFrame:SetScript("OnEvent", function()
	searchIntervalActionStart()
	if not libWho.isAddon then return end
	libWho.isAddon = false
	result = {}

	total, num = C_FriendList.GetNumWhoResults()
	for i=1, num do
		info = nil
		info = C_FriendList.GetWhoInfo(i)
		--backwards compatibility START
		info.Name=info.fullName
		info.Guild=info.fullGuildName
		info.Level=info.level
		info.Race=info.raceStr
		info.Class=info.classStr
		info.Zone=info.area
		info.NoLocaleClass=info.filename
		info.Sex=info.gender
		--backwards compatibility END
		result[i] = info
	end
	
	C_FriendList.SetWhoToUi(false)
	libWho:returnWho(result)
	if libWho.saveShown then
		libWho.saveShown:Click()
	else
		FriendsFrame:Hide()
		FriendsFrame:SetAlpha(libWho.frameAlpha or 1)
	end
	SOUNDKIT.IG_CHARACTER_INFO_TAB = SOUNDKIT.IG_CHARACTER_INFO_TAB_old
	SOUNDKIT.IG_MAINMENU_CLOSE = SOUNDKIT.IG_MAINMENU_CLOSE_old
end)