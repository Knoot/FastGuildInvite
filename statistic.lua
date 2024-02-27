local addon = FGI;
local fn = addon.functions;
local L = FGI:GetLocale();
local interface = addon.interface
local Graph = LibStub("LibGraph-2.0");
local GUI = LibStub("AceGUI-3.0");
local DB;

local graphFrame, graph, graphSett;
local historyFnList = {};

function historyFnList:search()
	table.insert(DB.factionrealm.history.search, fn.getTime());
end
function historyFnList:found(data)
	data.time = fn.getTime();
	table.insert(DB.factionrealm.history.found, data);
end
function historyFnList:send()
	table.insert(DB.factionrealm.history.send, fn.getTime());
end
function historyFnList:accept(name)
	table.insert(DB.factionrealm.history.accept, fn.getTime());
end
function historyFnList:decline()
	table.insert(DB.factionrealm.history.decline, fn.getTime());
end
function historyFnList:autodecline()
	table.insert(DB.factionrealm.history.autodecline, fn.getTime());
end
function historyFnList:leave()
	table.insert(DB.factionrealm.history.leave, fn.getTime());
end
function historyFnList:joined(name)
	-- save player race, class, level
	-- table.insert(DB.factionrealm.history.accept, fn.getTime());
end

local function getStartDate(arr, start)
	if not arr or #arr == 0 or (type(arr[#arr]) == 'number' and arr[#arr] or arr[#arr].time) < start then return end
	for i = #arr, 1, -1 do
		local t = type(arr[i]) == 'number' and arr[i] or arr[i].time;
		if t < start+3600 then
			return i+1;
		end
	end
	return 1;
end
local function prepareGraph(arr, start, step)
	local x = {};
	for i = 1, math.max(step[2], 2) do
		table.insert(x, {i, 0});
	end
	if step[2] == 0 then
		start = 1;
	end
	if not start then return {} end
	local shift, prev = 0, time({year = date('%Y'), month = date("%m"), day = date("%d"), hour = date("%H")});
	for i = #arr, start, -1 do
	local t = type(arr[i]) == 'number' and arr[i] or arr[i].time;
		if prev-t >= step[3]*3600 then
			shift = shift + (step[2] > 0 and math.floor((prev-t)/(step[3]*3600)) or 1);
			if step[2] == 0 then
				table.insert(x, {i, 0});
			end
			prev = t;
		end
		x[#x - shift][2] = x[#x - shift][2]+1;
	end
	return x
end

local function draw(data)
	graph:ResetData();
	
	local sended = {};
	local decline = {};
	local autodecline = {};
	local accept = {};
	local search = {};
	local found = {};
	local leave = {};
	local max = 0;
	
	local function updateMax(arr)
		if type(arr) ~= 'table' then return end
		for i = 1, #arr do
			if arr[i][2] and arr[i][2] > max then
				max = arr[i][2];
			end
		end
	end
	
	local startDate = time({year = date('%Y'), month = date("%m"), day = date("%d")-data.period[1], hour = date("%H")});
	local history = DB.factionrealm.history
	if data.show.send then
		sended = prepareGraph(history.send, getStartDate(history.send, startDate), data.period);
		updateMax(sended);
		graph:AddDataSeries(sended, {0, 0.9, 1, 0.8}, false);				--blue		inv send 
	end
	if data.show.decline then
		decline = prepareGraph(history.decline, getStartDate(history.decline, startDate), data.period);
		updateMax(decline);
		graph:AddDataSeries(decline, {1, 0, 0, 0.8}, false);				--red		inv decline
	end
	if data.show.autodecline then
		autodecline = prepareGraph(history.autodecline, getStartDate(history.autodecline, startDate), data.period);
		updateMax(autodecline);
		graph:AddDataSeries(autodecline, {1, 0.4, 0.4, 0.8}, false);		--red2		inv autodecline
	end
	if data.show.accept then
		accept = prepareGraph(history.accept, getStartDate(history.accept, startDate), data.period);
		updateMax(accept);
		graph:AddDataSeries(accept, {0.2, 1.0, 0.2, 0.8}, false);			--green		inv accept
	end
	if data.show.search then
		search = prepareGraph(history.search, getStartDate(history.search, startDate), data.period);
		updateMax(search);
		graph:AddDataSeries(search, {1, 1, 0, 0.8}, false);					--yellow	search
	end
	if data.show.found then
		found = prepareGraph(history.found, getStartDate(history.found, startDate), data.period);
		updateMax(found);
		graph:AddDataSeries(found, {0.8, 0, 1, 0.8}, false);				--purple	found
	end
	if data.show.leave then
		leave = prepareGraph(history.leave, getStartDate(history.leave, startDate), data.period);
		updateMax(leave);
		graph:AddDataSeries(leave, {0.67, 0.67, 0.67, 0.8}, false);			--gray		leave
	end
	graph:SetXAxis(0, math.max(2, data.period[2]+1));
	graph:SetYAxis(0, max+1);
	graph:SetGridSpacing(1, math.ceil(max/20)+1);
	graph:SetYLabels(true, false);
	graph:SetGridColorSecondary({0.5, 0.5, 0.5, 0.3})
	graph:SetGridSecondaryMultiple(0, 2);
end

interface.graphFrame = GUI:Create("ClearFrame");
graphFrame = interface.graphFrame;
graphFrame:SetWidth(600);
graphFrame:SetHeight(510);
graphFrame:SetTitle("Fast Guild Invite "..L["Статистика"]);
graphFrame:SetLayout("NIL");
graphFrame:SetPoint("CENTER");

graphFrame.title:SetScript('OnMouseUp', function(mover)
	local frame = mover:GetParent();
	frame:StopMovingOrSizing();
	local self = frame.obj;
	local status = self.status or self.localstatus;
	status.width = frame:GetWidth();
	status.height = frame:GetHeight();
	status.top = frame:GetTop();
	status.left = frame:GetLeft();
end)

graphFrame.closeButton = GUI:Create('Button');
local frame = graphFrame.closeButton;
frame:SetText('X');
frame:SetWidth(frame.frame:GetHeight());
fn:closeBtn(frame);
frame:SetPoint("CENTER", graphFrame.frame, "TOPRIGHT", -8, -8);
frame:SetCallback('OnClick', function()
	graphFrame:Hide();
end)
graphFrame:AddChild(frame);



graphFrame.settings = GUI:Create("GroupFrame");
graphSett = graphFrame.settings;
graphSett:SetLayout("NIL");
graphSett:SetHeight(60);
graphSett:SetWidth(graphFrame.frame:GetWidth()-20);
graphSett:SetPoint("TOPLEFT", graphFrame.frame, "TOPLEFT", 10, -25);
graphFrame:AddChild(graphSett);

graph = Graph:CreateGraphLine('FGIStatisticGraph', graphSett.frame, "TOPLEFT", "BOTTOMLEFT", 0, -5, graphFrame.frame:GetWidth()-20, 410);
graph:SetGridColor({0.5, 0.5, 0.5, 0.3});
graph:SetAxisDrawing(true, true);
graph:SetAxisColor({1.0, 1.0, 1.0, 1.0});
graph:SetAutoScale(true);
graph:LockYMin(0);
graph:LockXMax(30);

graphSett.send = GUI:Create("TCheckBox");
local frame = graphSett.send;
frame:SetLabel(L["Отправлено"]);
frame:SetTooltip(L["Отправленные приглашения"]);
frame:SetWidth(110);
frame:SetColor({0, 0.9, 1});
frame:SetPoint("TOPLEFT", graphSett.frame, "TOPLEFT", 0, 0);
frame.frame:HookScript("OnClick", function()
	DB.global.statistic.send = frame:GetValue();
end);
graphSett:AddChild(frame);

graphSett.accept = GUI:Create("TCheckBox");
local frame = graphSett.accept;
frame:SetLabel(L["Принято"]);
frame:SetTooltip(L["Принято приглашений"]);
frame:SetWidth(90);
frame:SetColor({0.2, 1.0, 0.2});
frame:SetPoint("TOPLEFT", graphSett.send.frame, "BOTTOMLEFT", 0, 0);
frame.frame:HookScript("OnClick", function()
	DB.global.statistic.accept = frame:GetValue();
end);
graphSett:AddChild(frame);

graphSett.decline = GUI:Create("TCheckBox");
local frame = graphSett.decline;
frame:SetLabel(L["Отклонено"]);
frame:SetTooltip(L["Игроки отклонившие приглашение"]);
frame:SetWidth(130);
frame:SetColor({1, 0, 0});
frame:SetPoint("TOPLEFT", graphSett.send.frame, "TOPRIGHT", 0, 0);
frame.frame:HookScript("OnClick", function()
	DB.global.statistic.decline = frame:GetValue();
end);
graphSett:AddChild(frame);

graphSett.autodecline = GUI:Create("TCheckBox");
local frame = graphSett.autodecline;
frame:SetLabel(L["Отклонено авт."]);
frame:SetTooltip(L["Игроки отклонившие приглашение автоматически"]);
frame:SetWidth(130);
frame:SetColor({1, 0.4, 0.4});
frame:SetPoint("TOPLEFT", graphSett.decline.frame, "BOTTOMLEFT", 0, 0);
frame.frame:HookScript("OnClick", function()
	DB.global.statistic.autodecline = frame:GetValue();
end);
graphSett:AddChild(frame);

graphSett.search = GUI:Create("TCheckBox");
local frame = graphSett.search;
frame:SetLabel(L["Поиски"]);
frame:SetTooltip(L["Количество запущенных поисков"]);
frame:SetWidth(90);
frame:SetColor({1, 1, 0});
frame:SetPoint("TOPLEFT", graphSett.decline.frame, "TOPRIGHT", 0, 0);
frame.frame:HookScript("OnClick", function()
	DB.global.statistic.search = frame:GetValue();
end);
graphSett:AddChild(frame);

graphSett.found = GUI:Create("TCheckBox");
local frame = graphSett.found;
frame:SetLabel(L["Найдено"]);
frame:SetTooltip(L["Найдено в результате поиска"]);
frame:SetWidth(110);
frame:SetColor({0.8, 0, 1});
frame:SetPoint("TOPLEFT", graphSett.search.frame, "BOTTOMLEFT", 0, 0);
frame.frame:HookScript("OnClick", function()
	DB.global.statistic.found = frame:GetValue();
end);
graphSett:AddChild(frame);

graphSett.leave = GUI:Create("TCheckBox");
local frame = graphSett.leave;
frame:SetLabel(L["Покинули"]);
frame:SetTooltip(L["Покинули гильдию"]);
frame:SetWidth(110);
frame:SetColor({0.67, 0.67, 0.67});
frame:SetPoint("TOPLEFT", graphSett.search.frame, "TOPRIGHT", 0, 0);
frame.frame:HookScript("OnClick", function()
	DB.global.statistic.leave = frame:GetValue();
end);
graphSett:AddChild(frame);

graphSett.update = GUI:Create("Button");
local frame = graphSett.update;
frame:SetText(L['Обновить']);
frame:SetWidth(110);
frame:SetPoint("TOPLEFT", graphSett.leave.frame, "TOPRIGHT", 0, 0);
frame:SetCallback("OnClick", function()
	draw({
		show = {
			send = graphSett.send:GetValue(),
			decline = graphSett.decline:GetValue(),
			autodecline = graphSett.autodecline:GetValue(),
			accept = graphSett.accept:GetValue(),
			search = graphSett.search:GetValue(),
			found = graphSett.found:GetValue(),
			leave = graphSett.leave:GetValue(),
		},
		period = graphSett.drop.connect[graphSett.drop:GetValue()]
	});
end)
graphSett:AddChild(frame);

graphSett.drop = GUI:Create("Dropdown")
local frame = graphSett.drop
frame:SetWidth(110)
frame:SetList({L["24 часа"], L["1 неделя"], L["1 месяц"], L["Все"],})
frame:SetValue(1)
frame:SetPoint("TOPLEFT", graphSett.update.frame, "BOTTOMLEFT", 0, 0);
frame:SetCallback("OnValueChanged", function(key)
	-- DB.global.inviteType = graphSett.drop:GetValue()
end)
frame.connect = {
	{1, 24, 1},
	{7, 7, 24},
	{30, 30, 24},
	{0,0,720}
}
graphSett:AddChild(frame)

local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB;
	fn.history = {};
	fn.history.onSearch			= historyFnList.search;
	fn.history.onFound			= historyFnList.found;
	fn.history.onSend			= historyFnList.send;
	fn.history.onAccept			= historyFnList.accept;
	fn.history.onDecline		= historyFnList.decline;
	fn.history.onDeclineAuto	= historyFnList.autodecline;
	fn.history.onLeave			= historyFnList.leave;
	fn.history.joined			= historyFnList.joined;
	
	graphSett.send:SetValue(DB.global.statistic.send or false);
	graphSett.decline:SetValue(DB.global.statistic.decline or false);
	graphSett.autodecline:SetValue(DB.global.statistic.autodecline or false);
	graphSett.accept:SetValue(DB.global.statistic.accept or false);
	graphSett.search:SetValue(DB.global.statistic.search or false);
	graphSett.found:SetValue(DB.global.statistic.found or false);
	graphSett.leave:SetValue(DB.global.statistic.leave or false);
	
	graphFrame:Hide();
end)