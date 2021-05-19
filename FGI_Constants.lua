FGI = {animations = {}, L = {}}
FGI_MINLVL = 1
FGI_DEFAULT_SEARCHINTERVAL = 5
FGI_SEARCHINTERVAL_MAX = 30
FGI_SCANINTERVALTIME = 5
FGI_FILTERSLIMIT = 35
FGI_MAXWHORETURN = 50
FGI_MAXWHOQUERY = 200
FGI_MAXSYNCHWAIT = 10
FGI_BLACKLIST_MAX = 20
FGI_NOTEMAXLENGTH = 31
FGI_RESETSENDDBTIME = {
	0,		--disable
	86400,	--1 day
	604800,	--1 week
	2592000,--1 month
	15552000,--6 months
}


FGISYNCH_PREFIX = "FGI_SYNCH"


C_ChatInfo.RegisterAddonMessagePrefix(FGISYNCH_PREFIX)


--@version-classic@
FGI_MAXLVL = 60
--@end-version-classic@
--@version-bcc@
FGI_MAXLVL = 70
--@end-version-bcc@
--@retail@
FGI_MAXLVL = 60
--@end-retail@

function FGI:GetLocale()
	return FGI.L[GetLocale()]
end