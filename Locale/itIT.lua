local L = LibStub("AceLocale-3.0"):NewLocale("FastGuildInvite", "itIT")
if not L then return end
--@localization(locale="itIT", format="lua_additive_table", same-key-is-true=true)@

L.synchBaseType = {
	"blacklist",
	"invitations",
}

L = LibStub("AceLocale-3.0"):GetLocale("FastGuildInvite")

L.synchType = {
	L["Черный список"],
	L["Список приглашенных"],
}
