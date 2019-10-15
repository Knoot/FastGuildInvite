local MAJOR,MINOR = "FGI-WhoLib", 1
local libWho, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not libWho then return end


libWho.whoQuery=''
libWho.saveShown=false
libWho.isAddon=false
libWho.frameAlpha = 1
libWho.callback = false

function libWho:SetCallback(callback)
	self.callback = callback
end

function libWho:GetWho(query)
	libWho.isAddon = true
	libWho.whoQuery = query
	libWho.saveShown = false
	local i=1
	
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

local whoFrame = CreateFrame('Frame')
whoFrame:RegisterEvent("WHO_LIST_UPDATE")
whoFrame:SetScript("OnEvent", function()
	if not libWho.isAddon then return end
	libWho.isAddon = false
	local result = {}

	local total, num = C_FriendList.GetNumWhoResults()
	for i=1, num do
	--	self.Result[i] = C_FriendList.GetWhoInfo(i)
		local info = C_FriendList.GetWhoInfo(i)
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
end)