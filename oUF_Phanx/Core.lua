--[[--------------------------------------------------------------------
	oUF_Phanx
	Fully-featured PVE-oriented layout for oUF.
	Copyright (c) 2008-2014 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info13993-oUF_Phanx.html
	http://www.curse.com/addons/wow/ouf-phanx
----------------------------------------------------------------------]]

local _, ns = ...
ns.loadFuncs = {}

ns.fontList = {}
ns.statusbarList = {}

ns.fontstrings = {}
ns.statusbars = {}

------------------------------------------------------------------------
--	Default configuration
------------------------------------------------------------------------

ns.configDefault = {
	width = 225,
	height = 30,
	powerHeight = 0.2,				-- how much of the frame's height should be occupied by the power bar

	backdrop = { bgFile = [[Interface\BUTTONS\WHITE8X8]] },
	backdropColor = { 32/256, 32/256, 32/256, 1 },

	statusbar = [[Interface\AddOns\oUF_Phanx\media\Neal]],

	font = [[Interface\AddOns\oUF_Phanx\media\PTSans-Bold.ttf]],
	fontOutline = "OUTLINE",

	dispelFilter = true,				-- only highlight the frame for debuffs you can dispel
	ignoreOwnHeals = false,			-- only show incoming heals from other players
	threatLevels = true,				-- show threat levels instead of binary aggro

	combatText = false,				-- show combat feedback text
	druidMana = false,				-- [druid] show a mana bar in cat/bear forms
	eclipseBar = true,				-- [druid] show an eclipse bar
	eclipseBarIcons = false,		-- [druid] show animated icons on the eclipse bar
	runeBars = true,					-- [deathknight] show rune cooldown bars
	totemBars = true,					-- [shaman] show totem duration bars

	healthColor = { 0.2, 0.2, 0.2 },
	healthColorMode = "CUSTOM",
	healthBG = 2,

	powerColor = { 0.8, 0.8, 0.8 },
	powerColorMode = "CLASS",
	powerBG = 0.25,

	borderColor = { 0.5, 0.5, 0.5 },
	borderSize = 16,

	PVP = false, -- enable PVP mode, currently only affects aura filtering
}

------------------------------------------------------------------------
--	Default unit configuration
------------------------------------------------------------------------

ns.uconfigDefault = {
	player = {
		point = "BOTTOMRIGHT UIParent CENTER -200 -200",
		width = 1.3,
		power = true,
		castbar = true,
	},
	pet = {
		point = "RIGHT player LEFT -12 0",
		width = 0.5,
		power = true,
		castbar = true,
	},
	target = {
		point = "BOTTOMLEFT UIParent CENTER 200 -200",
		width = 1.3,
		power = true,
		castbar = true,
	},
	targettarget = {
		point = "LEFT target RIGHT 12 0",
		width = 0.5,
	},
	focus = {
		point = "TOPLEFT target BOTTOMLEFT 0 -60",
		power = true,
	},
	focustarget = {
		point = "LEFT focus RIGHT 12 0",
		width = 0.5,
	},
	party = {
		point = "TOPLEFT boss5 BOTTOMLEFT 0 -75", -- CHECK POSITION
		width = 0.5,
		power = true,
		attributes = { "showPlayer", true, "showParty", true, "showRaid", false, "xOffset", 0, "yOffset", -25 },
		visible = "party",
	},
	partypet = {
		point = "TOPLEFT party TOPRIGHT 12 0",
		width = 0.25,
		attributes = { "showPlayer", true, "showParty", true, "showRaid", false, "xOffset", 0, "yOffset", -25, "useOwnerUnit", true, "unitsuffix", "pet" },
		visible = "party",
	},
	-------------
	--	Bosses --
	-------------
	boss1 = {
		point = "TOPRIGHT UIParent TOPRIGHT -15 -250",
		width = 0.8,
		height = 0.8,
		power = true,
	},
	boss2 = {
		point = "TOPRIGHT boss1 BOTTOMRIGHT 0 -25",
		width = 0.8,
		height = 0.8,
		power = true,
	},
	boss3 = {
		point = "TOPRIGHT boss2 BOTTOMRIGHT 0 -25",
		width = 0.8,
		height = 0.8,
		power = true,
	},
	boss4 = {
		point = "TOPRIGHT boss3 BOTTOMRIGHT 0 -25",
		width = 0.8,
		height = 0.8,
		power = true,
	},
	boss5 = {
		point = "TOPRIGHT boss4 BOTTOMRIGHT 0 -25",
		width = 0.8,
		height = 0.8,
		power = true,
	},
	-----------------------
	--	Arena Oppnonents --
	-----------------------
	arena1 = {
		point = "TOPLEFT boss1",
		width = 0.5,
		height = 0.8,
		power = true,
	},
	arena2 = {
		point = "TOPRIGHT arena1 BOTTOMRIGHT 0 -25",
		width = 0.5,
		height = 0.8,
		power = true,
	},
	arena3 = {
		point = "TOPRIGHT arena2 BOTTOMRIGHT 0 -25",
		width = 0.5,
		height = 0.8,
		power = true,
	},
	arena4 = {
		point = "TOPRIGHT arena3 BOTTOMRIGHT 0 -25",
		width = 0.5,
		height = 0.8,
		power = true,
	},
	arena5 = {
		point = "TOPRIGHT arena4 BOTTOMRIGHT 0 -25",
		width = 0.5,
		height = 0.8,
		power = true,
	},
	----------------------------
	--	Arena Opponents' Pets --
	----------------------------
	arenapet1 = {
		point = "LEFT arena1 RIGHT 10 0",
		width = 0.25,
		height = 0.8,
	},
	arenapet2 = {
		point = "LEFT arena2 RIGHT 10 0",
		width = 0.25,
		height = 0.8,
	},
	arenapet3 = {
		point = "LEFT arena3 RIGHT 10 0",
		width = 0.25,
		height = 0.8,
	},
	arenapet4 = {
		point = "LEFT arena4 RIGHT 10 0",
		width = 0.25,
		height = 0.8,
	},
	arenapet5 = {
		point = "LEFT arena5 RIGHT 10 0",
		width = 0.25,
		height = 0.8,
	},
}

------------------------------------------------------------------------
--	Colors
------------------------------------------------------------------------

oUF.colors.fallback = { 1, 1, 0.8 }
oUF.colors.uninterruptible = { 1, 0.7, 0 }

oUF.colors.threat = {}
for i = 1, 3 do
	local r, g, b = GetThreatStatusColor(i)
	oUF.colors.threat[i] = { r, g, b }
end

do
	local pcolor = oUF.colors.power
	pcolor.MANA[1], pcolor.MANA[2], pcolor.MANA[3] = 0, 0.8, 1
	pcolor.RUNIC_POWER[1], pcolor.RUNIC_POWER[2], pcolor.RUNIC_POWER[3] = 0.8, 0, 1

	local rcolor = oUF.colors.reaction
	rcolor[1][1], rcolor[1][2], rcolor[1][3] = 1, 0.2, 0.2 -- Hated
	rcolor[2][1], rcolor[2][2], rcolor[2][3] = 1, 0.2, 0.2 -- Hostile
	rcolor[3][1], rcolor[3][2], rcolor[3][3] = 1, 0.6, 0.2 -- Unfriendly
	rcolor[4][1], rcolor[4][2], rcolor[4][3] = 1,   1, 0.2 -- Neutral
	rcolor[5][1], rcolor[5][2], rcolor[5][3] = 0.2, 1, 0.2 -- Friendly
	rcolor[6][1], rcolor[6][2], rcolor[6][3] = 0.2, 1, 0.2 -- Honored
	rcolor[7][1], rcolor[7][2], rcolor[7][3] = 0.2, 1, 0.2 -- Revered
	rcolor[8][1], rcolor[8][2], rcolor[8][3] = 0.2, 1, 0.2 -- Exalted
end

------------------------------------------------------------------------
--	Load stuff
------------------------------------------------------------------------

local Loader = CreateFrame("Frame")
Loader:RegisterEvent("ADDON_LOADED")
Loader:SetScript("OnEvent", function(self, event, ...)
	return self[event] and self[event](self, event, ...)
end)

function Loader:ADDON_LOADED(event, addon)
	if addon ~= "oUF_Phanx" then return end

	local function initDB(db, defaults)
		if type(db) ~= "table" then db = {} end
		if type(defaults) ~= "table" then return db end
		for k, v in pairs(defaults) do
			if type(v) == "table" then
				db[k] = initDB(db[k], v)
			elseif type(v) ~= type(db[k]) then
				db[k] = v
			end
		end
		return db
	end

	-- Global settings:
	oUFPhanxConfig = initDB(oUFPhanxConfig, ns.configDefault)
	ns.config = oUFPhanxConfig

	-- Global unit settings:
	oUFPhanxUnitConfig = initDB(oUFPhanxUnitConfig, ns.uconfigDefault)
	ns.uconfig = oUFPhanxUnitConfig

	-- Aura settings stored per character:
	oUFPhanxAuraConfig = initDB(oUFPhanxAuraConfig)
	ns.UpdateAuraList()

	-- SharedMedia
	local SharedMedia = LibStub("LibSharedMedia-3.0", true)
	if SharedMedia then
		SharedMedia:Register("font", "PT Sans Bold", [[Interface\AddOns\oUF_Phanx\media\PTSans-Bold.ttf]])

		SharedMedia:Register("statusbar", "Flat", [[Interface\BUTTONS\WHITE8X8]])
		SharedMedia:Register("statusbar", "Neal", [[Interface\AddOns\oUF_Phanx\media\Neal]])

		for i, name in pairs(SharedMedia:List("font")) do
			tinsert(ns.fontList, name)
		end
		sort(ns.fontList)

		for i, name in pairs(SharedMedia:List("statusbar")) do
			tinsert(ns.statusbarList, name)
		end
		sort(ns.statusbarList)

		SharedMedia.RegisterCallback("oUF_Phanx", "LibSharedMedia_Registered", function(callback, mediaType, name)
			if mediaType == "font" then
				wipe(ns.fontList)
				for i, v in pairs(SharedMedia:List("font")) do
					tinsert(ns.fontList, v)
				end
				sort(ns.fontList)
			elseif mediaType == "statusbar" then
				wipe(ns.statusbarList)
				for i, v in pairs(SharedMedia:List("statusbar")) do
					tinsert(ns.statusbarList, v)
				end
				sort(ns.statusbarList)
			end
		end)

		SharedMedia.RegisterCallback("oUF_Phanx", "LibSharedMedia_SetGlobal", function(callback, mediaType)
			if mediaType == "font" then
				ns.SetAllFonts()
			elseif mediaType == "statusbar" then
				ns.SetAllStatusBarTextures()
			end
		end)
	end

	-- Miscellaneous
	for i = 1, #ns.loadFuncs do
		ns.loadFuncs[i]()
	end
	ns.loadFuncs = nil

	-- Cleanup
	self:UnregisterEvent(event)
	self.ADDON_LOADED = nil
	self:RegisterEvent("PLAYER_LOGOUT")

	-- Sounds for target/focus changing and PVP flagging
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("PLAYER_FOCUS_CHANGED")
	self:RegisterUnitEvent("UNIT_FACTION", "player")

	-- Shift to temporarily show all buffs
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	if not UnitAffectingCombat("player") then
		self:RegisterEvent("MODIFIER_STATE_CHANGED")
	end

	-- Load options on demand
	local Options = CreateFrame("Frame", "oUFPhanxOptions")
	Options.name = "oUF Phanx"
	InterfaceOptions_AddCategory(Options)
	Options:SetScript("OnShow", function(self)
		oUFPhanx = ns
		local loaded, reason = LoadAddOn("oUF_Phanx_Config")
		if not loaded then
			local text = self:CreateFontString(nil, nil, "GameFontHighlight")
			text:SetPoint("BOTTOMLEFT", 16, 16)
			text:SetPoint("TOPRIGHT", -16, -16)
			text:SetFormattedText(ADDON_LOAD_FAILED, "oUF_Phanx_Config", _G[reason])
			oUFPhanx = nil
		end
	end)

	SLASH_OUFPHANX1 = "/pouf"
	function SlashCmdList.OUFPHANX()
		InterfaceOptionsFrame_OpenToCategory("oUF Phanx")
		InterfaceOptionsFrame_OpenToCategory("oUF Phanx")
	end
end

------------------------------------------------------------------------

function Loader:PLAYER_LOGOUT(event)
	local function cleanDB(db, defaults)
		if type(db) ~= "table" then return {} end
		if type(defaults) ~= "table" then return db end
		for k, v in pairs(db) do
			if type(v) == "table" then
				if not next(cleanDB(v, defaults[k])) then
					-- Remove empty subtables
					db[k] = nil
				end
			elseif v == defaults[k] then
				-- Remove default values
				db[k] = nil
			end
		end
		return db
	end

	oUFPhanxConfig = cleanDB(oUFPhanxConfig, ns.configDefault)
	oUFPhanxUnitConfig = cleanDB(oUFPhanxUnitConfig, ns.uconfigDefault)
end

------------------------------------------------------------------------

function Loader:PLAYER_FOCUS_CHANGED(event)
	if UnitExists("focus") then
		if UnitIsEnemy("focus", "player") then
			PlaySound("igCreatureAggroSelect")
		elseif UnitIsFriend("player", "focus") then
			PlaySound("igCharacterNPCSelect")
		else
			PlaySound("igCreatureNeutralSelect")
		end
	else
		PlaySound("INTERFACESOUND_LOSTTARGETUNIT")
	end
end

function Loader:PLAYER_TARGET_CHANGED(event)
	if UnitExists("target") then
		if UnitIsEnemy("target", "player") then
			PlaySound("igCreatureAggroSelect")
		elseif UnitIsFriend("player", "target") then
			PlaySound("igCharacterNPCSelect")
		else
			PlaySound("igCreatureNeutralSelect")
		end
	else
		PlaySound("INTERFACESOUND_LOSTTARGETUNIT")
	end
end

local announcedPVP
function Loader:UNIT_FACTION(event, unit)
	if UnitIsPVPFreeForAll("player") or UnitIsPVP("player") then
		if not announcedPVP then
			announcedPVP = true
			PlaySound("igPVPUpdate")
		end
	else
		announcedPVP = nil
	end
end

------------------------------------------------------------------------

function Loader:PLAYER_REGEN_DISABLED(event)
	self:UnregisterEvent("MODIFIER_STATE_CHANGED")
	self:MODIFIER_STATE_CHANGED(event, "LSHIFT", 0)
end

function Loader:PLAYER_REGEN_ENABLED(event)
	self:RegisterEvent("MODIFIER_STATE_CHANGED")
	self:MODIFIER_STATE_CHANGED(event, "LSHIFT", IsShiftKeyDown() and 1 or 0)
end

function Loader:MODIFIER_STATE_CHANGED(event, key, state)
	if key ~= "LSHIFT" and key ~= "RSHIFT" then
		return
	end
	if state == 1 then
		a, b = "CustomFilter", "__CustomFilter"
	else
		a, b = "__CustomFilter", "CustomFilter"
	end
	for i = 1, #oUF.objects do
		local object = oUF.objects[i]
		local buffs = object.Auras or object.Buffs
		if buffs and buffs[a] then
			buffs[b] = buffs[a]
			buffs[a] = nil
			buffs:ForceUpdate()
		end
	end
end

------------------------------------------------------------------------

function ns.si(value, raw)
	local absvalue = abs(value)

	local str, val

	if absvalue >= 1e10 then
		str, val = "%.0fb", value / 1e9
	elseif absvalue >= 1e9 then
		str, val = "%.1fb", value / 1e9
	elseif absvalue >= 1e7 then
		str, val = "%.1fm", value / 1e6
	elseif absvalue >= 1e6 then
		str, val = "%.2fm", value / 1e6
	elseif absvalue >= 1e5 then
		str, val = "%.0fk", value / 1e3
	elseif absvalue >= 1e3 then
		str, val = "%.1fk", value / 1e3
	else
		str, val = "%d", value
	end

	if raw then
		return str, val
	else
		return format(str, val)
	end
end

------------------------------------------------------------------------

function ns.CreateFontString(parent, size, justify)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(ns.config.font, size or 16, ns.config.fontOutline)
	fs:SetJustifyH(justify or "LEFT")
	fs:SetShadowOffset(1, -1)

	tinsert(ns.fontstrings, fs)
	return fs
end

function ns.SetAllFonts(file, flag)
	if not file then file = ns.config.font end
	if not flag then flag = ns.config.fontOutline end

	for i = 1, #ns.fontstrings do
		local fontstring = ns.fontstrings[i]
		local _, size, flag = fontstring:GetFont()
		if not size or size == 0 then
			local element = fontstring:GetParent()

			local frame = element:GetParent()
			while frame and not frame:GetName() do
				frame = frame:GetParent()
			end

			local found
			for k, v in pairs(frame) do
				if v == element then
					for k2, v2 in pairs(element) do
						if v2 == fontstring then
							print("bad font height", tostring(size), "on", frame:GetName(), k, k2)
							found = true
						end
					end
				end
			end
			if not found then
				print("bad font height", tostring(size), "on mystery fontstring", fontstring:GetText() or "<no text>")
			end

			size = 18
		end
		fontstring:SetFont(file, size, flag)
	end

	for i = 1, 3 do
		local bar = _G["MirrorTimer" .. i]
		local _, size = bar.text:GetFont()
		bar.text:SetFont(file, size, flag)
	end
end

------------------------------------------------------------------------

do
	local function SetReverseFill(self, reverse)
		self.__reverse = reverse
	end

	local function SetTexCoord(self, v)
		local mn, mx = self:GetMinMaxValues()
		if v > 0 and v > mn and v <= mx then
			local pct = (v - mn) / (mx - mn)
			if self.__reverse then
				self.tex:SetTexCoord(1 - pct, 1, 0, 1)
			else
				self.tex:SetTexCoord(0, pct, 0, 1)
			end
		end
	end

	function ns.CreateStatusBar(parent, size, justify)
		local sb = CreateFrame("StatusBar", nil, parent)
		sb:SetStatusBarTexture(ns.config.statusbar)

		sb.tex = sb:GetStatusBarTexture()
		sb.tex:SetDrawLayer("BORDER")
		sb.tex:SetHorizTile(false)
		sb.tex:SetVertTile(false)
		hooksecurefunc(sb, "SetReverseFill", SetReverseFill)
		hooksecurefunc(sb, "SetValue", SetTexCoord)

		sb.bg = sb:CreateTexture(nil, "BACKGROUND")
		sb.bg:SetTexture(ns.config.statusbar)
		sb.bg:SetAllPoints(true)

		if size then
			sb.value = ns.CreateFontString(sb, size, justify)
		end

		tinsert(ns.statusbars, sb)
		return sb
	end
end

function ns.SetAllStatusBarTextures(file)
	if not file then
		file = ns.config.statusbar
	end

	for i = 1, #ns.statusbars do
		local sb = ns.statusbars[i]
		if sb.SetStatusBarTexture then
			sb:SetStatusBarTexture(file)
		else
			sb:SetTexture(file)
		end
		if sb.bg then
			sb.bg:SetTexture(file)
		end
	end

	for i = 1, 3 do
		local bar = _G["MirrorTimer" .. i]
		bar.bar:SetStatusBarTexture(file)
		bar.bg:SetTexture(file)
	end
end