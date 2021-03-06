local function GetRaceName(id)
	return C_CreatureInfo.GetRaceInfo(id) and C_CreatureInfo.GetRaceInfo(id).raceName or nil
end
local L = {
	FAQ = {
		help = {
			factorySettings = "/fgi factorySettings - Полный сброс базы данных аддона",
			filter = "ЛКМ - Включить/Выключить\nПКМ - Изменить\nShift+ЛКМ - Удалить\n\n",
			filterTooltip = "Имя фильтра: %s\nСостояние:%s\nФильтр имени: %s\nДиапазон уровней: %s\nФильтр повторений в имени:%d:%d\nКлассы: %s\nРасы: %s\nКоличество срабатываний фильтра:%d",
			minimap = "ЛКМ - пригласить\nПКМ - открыть главное окно\nShift+ЛКМ - пауза/продолжить\n\nОчередь: %d\nПрогресс: %s",
			resetDB = "/fgi resetDB - Очистить список отправленных приглашений.",
			resetWindowsPos = "/fgi resetWindowsPos - Сбросить позиции окон.",
			show = "/fgi show - Открыть главное окно аддона",
			invite = "/fgi invite - Пригласить первого игрока из очереди",
			nextSearch = "/fgi nextSearch - Запустить следующее сканирование",
			blacklist = "/fgibl <Имя> - <Причина> - Добавить игрока в черный список",
			help2 = "/fgi help2 - Команды с префиксом \"!\"",
		},
		help2 = {
			"|cff00ff96Команды с префиксом \"|cffff0000!|r|cff00ff96\" созданы для офицеров у которых не установлен аддон, эти команды могут быть использованы только в офицерском канале.|r",
			"В офицерском канале доступны следующие команды:",
			"!fgi - список доступных команд",
			"!blacklistAdd <Имя> - <Причина> - добавить игрока в черный список",
			"!blacklistDelete <Имя> - <Причина> - удалить игрока из черного списка",
			"!blacklistGetList - получить список игроков в черным списке",
		},
		error = {
			["Вы не состоите в гильдии или у вас нет прав для приглашения."] = "Вы не состоите в гильдии или у вас нет прав для приглашения.",
			["Выберите сообщение"] = "Выберите сообщение",
			["Максимальное количество фильтров %s. Пожалуйста измените или удалите имеющийся фильтр."] = "Максимальное количество фильтров %s. Пожалуйста измените или удалите имеющийся фильтр.",
			["Нельзя добавить пустое сообщение"] = "Нельзя добавить пустое сообщение",
			["Нельзя сохранить пустое сообщение"] = "Нельзя сохранить пустое сообщение",
			["Поиск вернул 50 или более результатов, рекомендуется изменить настройки поиска. Запрос: %s"] = "Поиск вернул 50 или более результатов, рекомендуется изменить настройки поиска. Запрос: %s",
			["Сочетание клавиш уже занято"] = "Сочетание клавиш уже занято",
			["Превышен лимит символов. Максимальная длина сообщения 255 символов. Длина сообщения превышена на %d"] = "Превышен лимит символов. Максимальная длина сообщения 255 символов. Длина сообщения превышена на %d",
		}
	},
	interface = {
		["Игрок не добавлен в список исключений."] = "Игрок не добавлен в список исключений.",
		defaultReason = "no reason",
		["Игрок %s добавлен в черный список."] = "Игрок %s добавлен в черный список.",
		["Причина"] = "Причина",
		["Черный список"] = "Черный список",
		["Пользовательский список"] = "Пользовательский список",
		["Для изменения значений используйте колесо мыши"] = "Для изменения значений используйте колесо мыши",
		["Включен"] = "Включен",
		["Включить фильтры"] = "Включить фильтры",
		["Выбрать приглашения"] = "Выбрать приглашения",
		["Выключен"] = "Выключен",
		["Выключить отправляемые сообщения"] = "Выключить отправляемые сообщения",
		["Выключить системные сообщения"] = "Выключить системные сообщения",
		["Выключить сообщения аддона"] = "Выключить сообщения аддона",
		["Да"] = "Да",
		["Диапазон уровней"] = "Диапазон уровней",
		["Диапазон уровней (Мин:Макс)"] = "Диапазон уровней (Мин:Макс)",
		["Добавить"] = "Добавить",
		["Добавить фильтр"] = "Добавить фильтр",
		["Запускать в фоновом режиме"] = "Запускать в фоновом режиме",
		["Игнорировать"] = "Игнорировать",
		["Имя фильтра"] = "Имя фильтра",
		["Имя фильтра занято"] = "Имя фильтра занято",
		["Имя фильтра не может быть пустым"] = "Имя фильтра не может быть пустым",
		["Интервал"] = "Интервал",
		["Классы:"] = "Классы:",
		["Количество ошибок: %d"] = "Количество ошибок: %d",
		["Нажмите на фильтр для изменения состояния"] = "Нажмите на фильтр для изменения состояния",
		["Назначить кнопку (%s)"] = "Назначить кнопку (%s)",
		["Настроить сообщения"] = "Настроить сообщения",
		["Настройки"] = "Настройки",
		["Начать сканирование"] = "Начать сканирование",
		["Не отображать значок у миникарты"] = "Не отображать значок у миникарты",
		["Неправильный шаблон"] = "Неправильный шаблон",
		["Нет"] = "Нет",
		["Обычный поиск"] = "Обычный поиск",
		["Обязательное поле \"Имя фильтра\", пустые текстовые поля не используются при фильтрации."] = "Обязательное поле \"Имя фильтра\",\nпустые текстовые поля не используются при фильтрации.",
		["Откл."] = "Откл.",
		["Отклонить"] = "Отклонить",
		["Поле может содержать только буквы"] = "Поле может содержать только буквы",
		["Пригласить"] = "Пригласить",
		["Пригласить: %d"] = "Пригласить: %d",
		["Расширенное сканирование"] = "Расширенное сканирование",
		["Расы:"] = "Расы:",
		["Режим приглашения"] = "Режим приглашения",
		["Сбросить"] = "Сбросить",
		["Слово NAME заглавными буквами будет заменено на название вашей гильдии."] = "Слово NAME заглавными буквами будет заменено на название вашей гильдии.",
		["Сохранить"] = "Сохранить",
		["Текущее сообщение: %s"] = "Текущее сообщение: %s",
		["Удалить"] = "Удалить",
		["Умный поиск"] = "Умный поиск",
		["Фильтр классов начало:"] = "Фильтр классов начало:",
		["Фильтр по имени"] = "Фильтр по имени",
		["Фильтр повторений в имени"] = "Фильтр повторений в имени",
		["Фильтр рас начало:"] = "Фильтр рас начало:",
		["Фильтры"] = "Фильтры",
		["Числа должны быть больше 0"] = "Числа должны быть больше 0",
		["Числа не могут быть меньше или равны 0. Минимальный уровень не может быть больше максимального"] = "Числа не могут быть меньше или равны 0. Минимальный уровень не может быть больше максимального",
		["Чтобы быть отфильтрованным, игрок должен соответствовать критериям ВСЕХ фильтров"] = "Чтобы быть отфильтрованным, игрок должен соответствовать критериям ВСЕХ фильтров",
		["Запоминать всех игроков"] = "Запоминать всех игроков",
		["Игрок %s найденный в черном списке, находится в вашей гильдии!"] = "Игрок %s найденный в черном списке, находится в вашей гильдии!",
		["Данные для синхронизации"] = "Данные для синхронизации",
		["Игрок для синхронизации"] = "Игрок для синхронизации",
		["Отправить запрос"] = "Отправить запрос",
		["Синхронизация"] = "Синхронизация",
		["Все"] = "Все",
		tooltip = {
			["Автоматическое увеличение детализации поиска"] = "Автоматическое увеличение детализации поиска",
			["Введите диапазон уровней для фильтра.\nНапример: %s55%s:%s58%s\nбудут подходить только те игроки, уровень\nкоторых варьируется от %s55%s до %s58%s (включительно)"] = "Введите диапазон уровней для фильтра.\nНапример: %s55%s:%s58%s\nбудут подходить только те игроки, уровень\nкоторых варьируется от %s55%s до %s58%s (включительно)",
			["Введите максимальное количество последовательных\nгласных и согласных, которое может содержать имя игрока.\nНапример: %s3%s:%s5%s\nБудет означать, что игроки с более чем %s3%s гласными подряд\nили более %s5%s согласными подряд не будут добавлены в очередь."] = "Введите максимальное количество последовательных\nгласных и согласных, которое может содержать имя игрока.\nНапример: %s3%s:%s5%s\nБудет означать, что игроки с более чем %s3%s гласными подряд\nили более %s5%s согласными подряд не будут добавлены в очередь.",
			["Дополнительные настройки сканирования"] = "Дополнительные настройки сканирования",
			["Если имя игрока содержит введенную\nфразу, он не будет добавлен в очередь"] = "Если имя игрока содержит введенную\nфразу, он не будет добавлен в очередь",
			["Запускать поиск в фоновом режиме"] = "Запускать поиск в фоновом режиме",
			["Количество уровней сканируемых за один раз"] = "Количество уровней сканируемых за один раз",
			["Назначить клавишу для приглашения"] = "Назначить клавишу для приглашения",
			["Назначить клавишу следующего поиска"] = "Назначить клавишу следующего поиска",
			["Не отображать в чате отправляемые сообщения"] = "Не отображать в чате отправляемые сообщения",
			["Не отображать в чате системные сообщения"] = "Не отображать в чате системные сообщения",
			["Не отображать в чате сообщения аддона"] = "Не отображать в чате сообщения аддона",
			["Уровень, с которого начинается фильтр по классам"] = "Уровень, с которого начинается фильтр по классам",
			["Уровень, с которого начинается фильтр по расам"] = "Уровень, с которого начинается фильтр по расам",
			["Записывать игрока в базу данных даже если приглашение не было отправлено"] = "Записывать игрока в базу данных даже если приглашение не было отправлено",
			["Использовать пользовательский список запросов"] = "Использовать пользовательский список запросов",
		},
		invType = {
			["Отправить сообщение и пригласить"] = "Отправить сообщение и пригласить",
			["Только пригласить"] = "Только пригласить",
			["Только сообщение"] = "Только сообщение",
		},
		synchType = {
			"Черный список",
			"Список приглашенных",
		},
		synchState = {
			["Игрок для синхронизации не выбран"] = "Игрок для синхронизации не выбран",
			["Данные для синхронизации не выбраны"] = "Данные для синхронизации не выбраны",
			["Запрос синхронизации у: %s. %d"] = "Запрос синхронизации у: %s. %d",
			["Ошибка типа синхронизации"] = "Ошибка типа синхронизации",
			["Начало синхронизации"] = "Начало синхронизации",
			["Данные синхронизированы с игроком %s."] = "Данные синхронизированы с игроком %s.",
			["Синхронизация с %s.\n %d/%d"] = "Синхронизация с %s.\n %d/%d",
			["Превышен лимит ожидания ответа"] = "Превышен лимит ожидания ответа",
		},
		clearDBtimes = {
			["Отключить"] = "Отключить",
			["1 день"] = "1 день",
			["1 неделя"] = "1 неделя",
			["1 месяц"] = "1 месяц",
			["6 месяцев"] = "6 месяцев",
			["Время запоминания игрока"] = "Время запоминания игрока",
		}
	},
	SYSTEM = {
		["c-"] = "к-",
		["r-"] = "р-",
		class = {},
		femaleClass = {},
		race = {},
		femaleRace = {
			Orc = "Орчиха",
			Tauren = "Тауренка",
			Dwarf = "Дворфийка",
			Gnome = "Гномка",
			NightElf = "Ночная эльфийка",
			BloodElf = "Эльфийка крови",
			HightmountainTauren = "Тауренка Крутогорья",
			MagharOrc = "Маг'харка",
			Nightborne = "Ночнорожденная",
			Pandaren = "Пандаренка",
			ZandalariTroll = "Зандаларка",
			DarkIronDwarf = "Дворфийка из клана Черного Железа",
			Draenei = "Дренейка",
			LightforgedDraenei = "Озаренная дренейка",
			Pandaren = "Пандаренка",
			VoidElf = "Эльфийка Бездны",
			KulTiran = "Култираска",
		},
	}
}

L.interface.synchBaseType = {--		WARNING
	"blacklist",
	"invitations",
}

for k,v in pairs(L.SYSTEM.class) do
	local n = LOCALIZED_CLASS_NAMES_FEMALE[k:upper()]
	if v~=n then
		L.SYSTEM.femaleClass[k] = n
	end
end
L.settings = {
	size = {
		mainFrameW = 620,
		mainFrameH = 320,
		wheelHint = 350,
		inviteTypeGRP = 200,
		backgroundRun = 220,
		enableFilters = 150,
		startScan = 160,
		chooseInvites = 180,
		settingsBtn = 120,
		gratitude = 120,
		lvlRange = 150,
		searchInterval = 120,
		raceFilterStart = 160,
		classFilterStart = 160,
		settingsFrameW = 550,
		settingsFrameH = 260,
		addonMSG = 230,
		systemMSG = 245,
		sendMSG = 270,
		minimapButton = 260,
		rememberAll = 260,
		clearDBtimes = 150,
		filters = 150,
		keyBindingsW = 440,
		keyBindingsH = 150,
		keyBind = 200,
		setMSG = 160,
		filtersFrameW = 620,
		filtersFrameH = 300,
		addFilter = 150,
		addfilterFrameW = 600,
		addfilterFrameH = 600,
		messageFrameW = 600,
		messageFrameH = 300,
		yes = 100,
		no = 100,
		save = 100,
		delete = 100,
		add = 100,
		chooseInvitesW = 400,
		chooseInvitesH = 100,
		reject = 100,
		invite = 100,
		blackListW = 400,
		blackListH = 360,
		blackList = 150,
		uninviteW = 220,
		uninviteH = 160,
		customListW = 360,
		customListH = 360,
		customListBtn = 200,
		synchFrameW = 450,
		synchFrameH = 250,
		sendRequest = 150,
		synchBtn = 200,
		
		classLabel = 60,
		Ignore = 120,
		DeathKnight = 130,
		DemonHunter = 160,
		Druid = 70,
		Hunter = 80,
		Mage = 50,
		Monk = 70,
		Paladin = 80,
		Priest = 65,
		Rogue = 95,
		Shaman = 70,
		Warlock = 125,
		Warrior = 60,
		
		raceLabel = 60,
		Orc = 50,
		Undead = 80,
		Tauren = 75,
		Troll = 75,
		BloodElf = 100,
		Goblin = 75,
		Nightborne = 140,
		HightmountainTauren = 150,
		MagharOrc = 85,
		Pandaren = 95,
		Human = 100,
		Dwarf = 100,
		NightElf = 120,
		Gnome = 100,
		Draenei = 100,
		Worgen = 100,
		VoidElf = 130,
		LightforgedDraenei = 150,
		DarkIronDwarf = 160,
		ZandalariTroll = 120,
		KulTiran = 120,
		
		
		filterNameLabel = 200,
		excludeNameLabel = 200,
		lvlRangeLabel = 200,
		excludeRepeatLabel = 200,
		saveButton = 100,
		
		scanFrameW = 260,
		scanFrameH = 105,
		inviteBTN = 120,
		clearBTN = 70,
	},
	Font = 'Interface\\AddOns\\FastGuildInvite\\fonts\\PT_Sans_Narrow.ttf',
	FontSize = 16,
}
L.Gratitude = {
	{"Category", "Name", "Contact", "Donate"},
	{"", "", "", ""},
	{"Author", "Knoot", "Knoot#7430", "paypal.me/Knoot"},
	{"Donate", "Anchep", "-", "-"},
	{"Donate", "dLuxian", "-", "-"},
	{"Donate", "Zipacna (Bleeding Hollow) <Imperial Patent>", "-", "-"},
	{"Translate-zhTW", "Anchep", "Services@280i.com", "paypal.me/280i"},
	{"Testing", "Shujin", "-", "-"},
	{"Testing", "StreetX", "-", "-"},
	{"Testing", "Мойгосподин", "-", "-"},
	{"Testing", "Zipacna", "-", "-"},
	{"OtherHelp", "(Змейталак) <Нам Везёт Мы Играем>", "-", "-"},
}

--[[-------------------------------------------------------------------------------------
								UNIQUE FOR RETAIL VERSION
]]---------------------------------------------------------------------------------------
L.SYSTEM.class = {
	DeathKnight = LOCALIZED_CLASS_NAMES_MALE.DEATHKNIGHT,
	DemonHunter = LOCALIZED_CLASS_NAMES_MALE.DEMONHUNTER,
	Druid = LOCALIZED_CLASS_NAMES_MALE.DRUID,
	Hunter = LOCALIZED_CLASS_NAMES_MALE.HUNTER,
	Mage = LOCALIZED_CLASS_NAMES_MALE.MAGE,
	Monk = LOCALIZED_CLASS_NAMES_MALE.MONK,
	Paladin = LOCALIZED_CLASS_NAMES_MALE.PALADIN,
	Priest = LOCALIZED_CLASS_NAMES_MALE.PRIEST,
	Rogue = LOCALIZED_CLASS_NAMES_MALE.ROGUE,
	Shaman = LOCALIZED_CLASS_NAMES_MALE.SHAMAN,
	Warlock = LOCALIZED_CLASS_NAMES_MALE.WARLOCK,
	Warrior = LOCALIZED_CLASS_NAMES_MALE.WARRIOR,
}
L.SYSTEM.race = {
	Horde = {
		Orc = GetRaceName(2),	--	"Орк"
		Tauren = GetRaceName(6),	--	"Таурен"
		Troll = GetRaceName(8),	--	"Тролль"
		Undead = GetRaceName(5),	--	"Нежить"
		BloodElf = GetRaceName(10),	--	"Эльф крови"
		Goblin = GetRaceName(9),	--	"Гоблин"
		HightmountainTauren = GetRaceName(28),	--	"Таурен Крутогорья"
		MagharOrc = GetRaceName(36),	--	"Маг'хар"
		Nightborne = GetRaceName(27),	--	"Ночнорожденный"
		Pandaren = GetRaceName(26),	--	"Пандарен"
		ZandalariTroll = GetRaceName(31),	--	"Зандалар"
	},
	Alliance = {
		Dwarf = GetRaceName(3),	--	"Дворф"
		Gnome = GetRaceName(7),	--	"Гном"
		Human = GetRaceName(1),	--	"Человек"
		NightElf = GetRaceName(4),	--	"Ночной эльф"
		DarkIronDwarf = GetRaceName(34),	--	"Дворф из клана Черного Железа"
		Draenei = GetRaceName(11),	--	"Дреней"
		LightforgedDraenei = GetRaceName(30),	--	"Озаренный дреней"
		Pandaren = GetRaceName(25),	--	"Пандарен"
		VoidElf = GetRaceName(29),	--	"Эльф Бездны"
		Worgen = GetRaceName(22),	--	"Ворген"
		KulTiran = GetRaceName(32),	--	"Култирасец"
	},
}
--[[-------------------------------------------------------------------------------------
							/	UNIQUE FOR RETAIL VERSION
]]---------------------------------------------------------------------------------------


FGI.L["ruRU"] = L
