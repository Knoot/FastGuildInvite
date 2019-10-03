-- if not(GetLocale() == "enUS") then
  -- return
-- end
local L = {
	["FAQ"] = {
		["help"] = {
			["factorySettings"] = "/fgi factorySettings - Full reset of the addon database",
			["filter"] = "LMB-enable/disable\nRMB-change\nShift+LMB-delete\n\n",
			["filterTooltip"] = "Filter Name:%s\nstatus:%s\nfilter by Name:%s\nlevel range:%s\nrepeat filter in name:%d:%d\nclasses:%s\nrace:%s\nnumber of filter triggers:%d",
			["minimap"] = "LMB-invite\nRMB-Open main window\nShift+:LMB-Pause/continue\n\nQueue:%d\nprogress:%s",
			["resetDB"] = "/fgi resetDB - Clear the list of sent invitations.",
			["resetWindowsPos"] = "/fgi resetWindowsPos - Reset the position of the window(s).",
			["show"] = "/fgi show - Open the main window of the addon",
			["invite"] = "/fgi invite - Invite the first player from the queue",
			["nextSearch"] = "/fgi nextSearch - Run next scan",
		},
		["error"] = {
			["Вы не состоите в гильдии или у вас нет прав для приглашения."] = "You are not a member of the guild or you do not have permission to invite.",
			["Выберите сообщение"] = "Select message",
			["Максимальное количество фильтров %s. Пожалуйста измените или удалите имеющийся фильтр."] = "The maximum number of filters %s. Please change or remove existing filter.",
			["Нельзя добавить пустое сообщение"] = "Cannot add empty message",
			["Нельзя сохранить пустое сообщение"] = "Cannot save empty message",
			["Поиск вернул 50 или более результатов, рекомендуется изменить настройки поиска. Запрос: %s"] = "Search returned 50 or more results, it is recommended to change the search settings. Query: %s",
			["Превышен лимит символов. Максимальная длина сообщения 255 символов. Длина сообщения превышена на %d"] = "Character limit exceeded. The maximum message length is 255 characters. Message length exceeded by %d",
			["Сочетание клавиш уже занято"] = "Keyboard shortcut busy",
		}
	},
	["interface"] = {
		["Включен"] = "Included",
		["Черный список"] = "Blacklist",
		["Включить фильтры"] = "Enable filters",
		["Выбрать приглашения"] = "Choose invitations",
		["Выключен"] = "Switched off",
		["Выключить отправляемые сообщения"] = "Disable sent messages",
		["Выключить системные сообщения"] = "Turn off system messages",
		["Выключить сообщения аддона"] = "Disable addon messages",
		["Да"] = "Yes",
		["Диапазон уровней"] = "Level range",
		["Диапазон уровней (Мин:Макс)"] = "Level Range (Min: Max)",
		["Для изменения значений используйте колесо мыши"] = "Use the mouse wheel to change the values.",
		["Добавить"] = "Add",
		["Добавить фильтр"] = "Add filter",
		["Запускать в фоновом режиме"] = "Run in the background",
		["Игнорировать"] = "Ignore",
		["Игрок не добавлен в список исключений."] = "The player is not added to the exceptions list.",
		["Имя фильтра"] = "Filter name",
		["Имя фильтра занято"] = "Filter name is busy",
		["Имя фильтра не может быть пустым"] = "Filter name cannot be empty",
		["Интервал"] = "Interval",
		["Классы:"] = "Classes:",
		["Количество ошибок: %d"] = "Number of errors: %d",
		["Нажмите на фильтр для изменения состояния"] = "Click on the filter to change the state",
		["Назначить кнопку (%s)"] = "Assign button (%s)",
		["Настроить сообщения"] = "Customize posts",
		["Настройки"] = "Settings",
		["Начать сканирование"] = "Start Scan",
		["Не отображать значок у миникарты"] = "Do not display the minimap icon.",
		["Неправильный шаблон"] = "Wrong template",
		["Нет"] = "No",
		["Обычный поиск"] = "Normal Search",
		["Обязательное поле \"Имя фильтра\", пустые текстовые поля не используются при фильтрации."] = "Required field \"Filter name\",\nempty text boxes are not used in filtering. ",
		["Откл."] = "Turn off",
		["Отклонить"] = "Reject",
		["Поле может содержать только буквы"] = "This field can only contain letters. ",
		["Пригласить"] = "Invite",
		["Пригласить: %d"] = "Invite: %d",
		["Расширенное сканирование"] = "Advanced Scan",
		["Расы:"] = "Race:",
		["Режим приглашения"] = "Invitation mode",
		["Сбросить"] = "Reset",
		["Слово NAME заглавными буквами будет заменено на название вашей гильдии."] = "The word NAME in capital letters will be replaced with the name of your guild.",
		["Сохранить"] = "Save",
		["Текущее сообщение: %s"] = "Current message: %s",
		["Удалить"] = "Delete",
		["Умный поиск"] = "Smart Search",
		["Фильтр классов начало:"] = "Class Filter Start:",
		["Фильтр по имени"] = "Filter by name",
		["Фильтр повторений в имени"] = "Repeat filter in Name",
		["Фильтр рас начало:"] = "Filter start races:",
		["Фильтры"] = "Filters",
		["Числа должны быть больше 0"] = "Numbers must be greater than 0",
		["Числа не могут быть меньше или равны 0. Минимальный уровень не может быть больше максимального"] = "Numbers cannot be less than or equal to 0. The minimum level cannot be greater than the maximum",
		["Чтобы быть отфильтрованным, игрок должен соответствовать критериям ВСЕХ фильтров"] = "To be filtered, the player must meet the criteria of all filters",
		["Запоминать всех игроков"] = "Remember all players",
		["Игрок %s найденный в черном списке, находится в вашей гильдии!"] = "Blacklisted %s player is in your guild!",
		["tooltip"] = {
			["Автоматическое увеличение детализации поиска"] = "Automatically increase search details.",
			["Введите диапазон уровней для фильтра.\nНапример: %s55%s:%s58%s\nбудут подходить только те игроки, уровень\nкоторых варьируется от %s55%s до %s58%s (включительно)"] = "Enter a range of levels for the filter.\nfor Example:%s55%s:%s58%s\nwill be approached only by those players, the level\nwhich varies from%s55%s to %s58%s (inclusive)",
			["Введите максимальное количество последовательных\nгласных и согласных, которое может содержать имя игрока.\nНапример: %s3%s:%s5%s\nБудет означать, что игроки с более чем %s3%s гласными подряд\nили более %s5%s согласными подряд не будут добавлены в очередь."] = "Enter the maximum number of consecutive\nvowels and consonants that may contain the player's name.\nfor Example:%s3%s:%s5%s\nwill mean that players with more than%s3%s vowels in a row\nor more%s5%s consonants will not be added to Queue.",
			["Дополнительные настройки сканирования"] = "Advanced Scan Settings",
			["Если имя игрока содержит введенную\nфразу, он не будет добавлен в очередь"] = "If the player name contains the entered\nphrase, it will not be added to the queue",
			["Запускать поиск в фоновом режиме"] = "Run a background search",
			["Количество уровней сканируемых за один раз"] = "Number of levels scanned at one time",
			["Назначить клавишу для приглашения"] = "Assign a key to the invitation",
			["Назначить клавишу следующего поиска"] = "Assign a key to the next search",
			["Не отображать в чате отправляемые сообщения"] = "Do not show sent messages in chat",
			["Не отображать в чате системные сообщения"] = "Do not display system messages in Chat",
			["Не отображать в чате сообщения аддона"] = "Do not display addon messages in Chat",
			["Уровень, с которого начинается фильтр по классам"] = "The level at which the filter starts by class",
			["Уровень, с которого начинается фильтр по расам"] = "The level at which the race filter starts",
			["Записывать игрока в базу данных даже если приглашение не было отправлено"] = "Write a player to the database even if the invitation has not been sent",
		},
		["invType"] = {
			["Отправить сообщение и пригласить"] = "Send a message and invite",
			["Только пригласить"] = "Only invite",
			["Только сообщение"] = "Message only",
		},
		["clearDBtimes"] = {
			["Отключить"] = "Disable",
			["1 день"] = "1 day",
			["1 неделя"] = "1 week",
			["1 месяц"] = "1 month",
			["6 месяцев"] = "6 months",
			["Время запоминания игрока"] = "Player memorization time",
		}
	},
	["SYSTEM"] = {
		["c-"] = "c-",
		["r-"] = "r-",
	}
}


L.settings = {
	size = {
		mainFrameW = 600,
		mainFrameH = 300,
		wheelHint = 350,
		inviteTypeGRP = 200,
		backgroundRun = 220,
		enableFilters = 150,
		startScan = 130,
		chooseInvites = 130,
		settingsBtn = 130,
		gratitude = 130,
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
		blackListW = 200,
		blackListH = 360,
		blackList = 150,
		uninviteW = 220,
		uninviteH = 160,
		
		classLabel = 60,
		Ignore = 120,
		DeathKnight = 130,
		DemonHunter = 160,
		Druid = 70,
		Hunter = 80,
		Mage = 50,
		Monk = 70,
		Paladin = 80,
		Priest = 60,
		Rogue = 95,
		Shaman = 70,
		Warlock = 120,
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
	Font = 'Interface\\AddOns\\FastGuildInvite\\fonts\\simhei.ttf',
	FontSize = 16,
}

L.Gratitude = {
	testing = {"介绍", "----","作者","----","汉化",},
	coding = {"姓名:","----", "毛熊:Knoot","----","280i.com",},
	donations = {"",}
}


FGI.L["zhTW"] = L