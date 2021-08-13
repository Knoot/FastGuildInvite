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
		
		--@version-retail@
	--raids
		13224,
		13561,
	--dungeons
		12916,
		13228,
		13334,
		12831,
		12842,
		12841,
		13309,
		12837,
		13577,
		--@end-version-retail@
		
		--@version-bbc@
	--raids
		4075,
		3959,
		3606,
		3457,
		3845,
		3923,
		3607,
		3836,
	--dungeons
		3848,
		2366,
		3717,
		4131,
		3789,
		2367,
		3791,
		3714,
		3715,
		3716,
		3849,
		3713,
		3792,
		3847,
		3562,
		3790,
		--@end-version-bbc@
		
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