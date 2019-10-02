local L = {}
local locale = GetLocale()
local function GetL(ru,en,cur)
  ru = ru or FGI.L["ruRU"]
  en = en or FGI.L["enUS"] or {}
  cur = cur or FGI.L[locale] or {}
  local L = {}
  for k,v in pairs(ru) do
    if type(v) == "table" then
      L[k] = GetL(v,en[k],cur[k])
    else
      L[k] = cur[k] or en[k] or v
    end
  end
  return L
end
FGI.L = GetL()



local size = FGI.L.settings.size

FGI.L.SYSTEM.race = FGI.L.SYSTEM.race[UnitFactionGroup("player")]


size.mainButtonsGRP = size.startScan + size.chooseInvites + size.settingsBtn
size.mainCheckBoxGRP = math.max(size.backgroundRun, size.enableFilters, size.customListBtn)
size.searchRangeGRP = math.max(size.lvlRange + size.raceFilterStart, size.searchInterval + size.classFilterStart)+30
size.settingsCheckBoxGRP = math.max(size.addonMSG, size.systemMSG, size.sendMSG, size.minimapButton, size.rememberAll)
size.settingsButtonsGRP = size.filters + size.keyBind + size.setMSG
size.raceShift = math.max(size.Ignore, size.DeathKnight, size.DemonHunter, size.Druid, size.Hunter, size.Mage, size.Monk, size.Paladin, size.Priest, size.Rogue, size.Shaman, size.Warlock, size.Warrior)
size.raceShift = size.raceShift - size.classLabel + 20
size.filterNameShift = {}
for k,v in pairs(FGI.L.SYSTEM.race) do 
table.insert(size.filterNameShift, size[k]) 
end 
size.filterNameShift = math.max(unpack(size.filterNameShift) or size.raceShift) - size.raceLabel + 20
size.filtersEdit = math.max(size.filterNameLabel, size.excludeNameLabel, size.lvlRangeLabel, size.excludeRepeatLabel)
