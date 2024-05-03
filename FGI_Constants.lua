FGI = {animations = {}, L = {}}
FGI_MINLVL = 1
FGI_DEFAULT_SEARCHINTERVAL = 5
FGI_SEARCHINTERVAL_MAX = 30
FGI_SCANINTERVALTIME = 5
FGI_FILTERSLIMIT = 35
FGI_MAXWHORETURN = 50
FGI_MAXWHOQUERY = 200
FGI_MAXSYNCHWAIT = 10
FGI_BLACKLIST_MAX = 13
FGI_NOTEMAXLENGTH = 31
FGI_RESETSENDDBTIME = {
	0,		--disable
	86400,	--1 day
	604800,	--1 week
	2592000,--1 month
	15552000,--6 months
}
FGI_CONST = {
	areas = {
	--battlegrounds
		2597,
		6665,
		3358,
		4710,
		4384,
		3820,
		8485,
		6126,
		3277,
		5449,
		5031,
		7107,
		9136,
		6051,
		10176,
	--arenas
		8008,
		4406,
		6732,
		3968,
		4378,
		7816,
		6296,
		3698,
		3702,
		8624,
		14436,

		--@version-retail@
	--raids
		14663,
		14030,
		14663,
	--dungeons
		14032,
		13991,
		14082,
		14011,
		14063,
		13954,
		13982,
		13968,
		14514,
		--M+ rotating
		9391,
		7546,
		8093,
		--@end-version-retail@

		--@version-wrath@
	--raids
		4987,
		4812,
		2159,
		4722,
		4273,
		4500,
		4493,
		3456,
		4603,
	--dungeons
		4820,
		4813,
		4809,
		4723,
		4100,
		1196,
		4228,
		4272,
		4264,
		4416,
		4415,
		4196,
		4265,
		4494,
		4277,
		206,
		--@end-version-wrath@

		--@version-classic@
	--raids
		3456,
		3428,
		2677,
		3429,
		2717,
		2159,
		1977,
	--dungeons
		1477,
		2057,
		2557,
		1337,
		2017,
		2100,
		1176,
		1584,
		722,
		209,
		491,
		796,
		--@end-version-classic@
	}
}


FGISYNC_PREFIX = "FGI_SYNC_V1"
FGISYNC_PREFIX_G = "FGI_SYNC"

C_ChatInfo.RegisterAddonMessagePrefix(FGISYNC_PREFIX)
C_ChatInfo.RegisterAddonMessagePrefix(FGISYNC_PREFIX_G)


--@version-classic@
FGI_MAXLVL = 60
--@end-version-classic@
--@version-wrath@
FGI_MAXLVL = 80
--@end-version-wrath@
--@version-cata@
FGI_MAXLVL = 85
--@end-version-cata@
--@retail@
FGI_MAXLVL = 70
--@end-retail@

function FGI:GetLocale()
	return FGI.L[GetLocale()]
end