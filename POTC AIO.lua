if GetObjectName(GetMyHero()) == "Lux" then 

local ver = "0.01"

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat("New version found! " .. data)
        PrintChat("Downloading update, please wait...")
        DownloadFileAsync("https://raw.githubusercontent.com/Farscape2000/GOS/master/Lux%20Deluxe%20Edition.lua", SCRIPT_PATH .. "Lux-Deluxe-Edition.lua", function() PrintChat("Update Complete, please 2x F6!") return end)
    else
        PrintChat("No updates found!")
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/Farscape2000/GOS/master/Versions/LuxDeluxeEdition.version", AutoUpdate)

if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end

require("OpenPredict")
local LuxMenu = Menu("Lux", "The Lady of Luminosity ")
LuxMenu:SubMenu("Combo", "Combo")
LuxMenu:SubMenu("Laneclear", "Laneclear")
LuxMenu:SubMenu("Ks", "Killsteal")
LuxMenu:SubMenu("misc", "Misc Settings")
LuxMenu:SubMenu("SubReq",  "AutoLevel Settings")
LuxMenu:SubMenu("draw", "Draws")

LuxMenu.Combo:Boolean("Q", "Use Q", true)
LuxMenu.Combo:Boolean("W", "Use W", false)
LuxMenu.Combo:Slider("WM", "W Slider % HP", 40, 1, 100, 1)
LuxMenu.Combo:Boolean("WA", "Use W on Ally", false)
LuxMenu.Combo:Boolean("E", "Use E", true)
LuxMenu.Combo:Slider("WMA", "No Options here", 1, 1, 1, 1)

LuxMenu.Laneclear:Boolean("LE", "Use E", true)

LuxMenu.Ks:Boolean("Ign", "Auto Ignite", true)
LuxMenu.Ks:Boolean("R", "Use R", true)

local skinMeta       = {["Lux"] = {"Classic", "Spellthief", "Sorceress", "Steel Legion", "Commando", "Imperial", "Star Guardian"}}
LuxMenu.misc:DropDown('skin', myHero.charName.. " Skins", 1, skinMeta[myHero.charName], HeroSkinChanger, true)
LuxMenu.misc.skin.callback = function(model) HeroSkinChanger(myHero, model - 1) print(skinMeta[myHero.charName][model] .." ".. myHero.charName .. " Loaded!") end

LuxMenu.SubReq:Boolean("LevelUp", "Level Up Skills", true)
LuxMenu.SubReq:Slider("Start_Level", "Level to enable lvlUP", 1, 1, 17)
LuxMenu.SubReq:DropDown("autoLvl", "Skill order", 1, {"E-Q-W",})
LuxMenu.SubReq:Boolean("Humanizer", "Enable Level Up Humanizer", true)

LuxMenu.draw:Slider("cwidth", "Circle Width", 1, 1, 10, 1)
LuxMenu.draw:Slider("cquality", "Circle Quality", 1, 0, 8, 1)
LuxMenu.draw:Boolean("qdraw", "Draw Q", true)
LuxMenu.draw:ColorPick("qcirclecol", "Q Circle color", {255, 134, 26, 217}) 
LuxMenu.draw:Boolean("edraw", "Draw E", true)
LuxMenu.draw:ColorPick("ecirclecol", "E Circle color", {255, 134, 26, 217})
LuxMenu.draw:Boolean("wdraw", "Draw W", true)
LuxMenu.draw:ColorPick("wcirclecol", "W Circle color", {255, 134, 26, 217})

local LuxQ = {delay = .5, range = 1300, width = 80, speed = 1200}
local LuxW = {delay = .5, range = 1075, width = 150, speed = 1200}
local LuxE = {delay = .5, range = 1100, radius = 350, speed = 1400}
local LuxR = {delay = 1.75, range = 1700, width = 190, speed = 3000}
local igniteFound = false
local summonerSpells = {ignite = {}, flash = {}, heal = {}, barrier = {}}
local LevelUpTable={
	[1]={_Q,_E,_E,_W,_E,_R,_E,_Q,_E,_Q,_R,_Q,_Q,_W,_W,_R,_W,_W} 
}	

OnTick (function()
		if LuxMenu.SubReq.LevelUp:Value() and GetLevelPoints(myHero) >= 1 and GetLevel(myHero) >= LuxMenu.SubReq.Start_Level:Value() then
	        if LuxMenu.SubReq.Humanizer:Value() then
	            DelayAction(function() LevelSpell(LevelUpTable[LuxMenu.SubReq.autoLvl:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1]) end, math.random(0.3286,1.33250))
	        else
	            LevelSpell(LevelUpTable[LuxMenu.SubReq.autoLvl:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1])
	        end
		end
end)

OnLoad (function()
	if not igniteFound then
    	if GetCastName(myHero, SUMMONER_1):lower():find("summonerdot") then
      		igniteFound = true
      		summonerSpells.ignite = SUMMONER_1
      		LuxMenu.Ks:Boolean("Ign", "Auto Ignite", true)
    	elseif GetCastName(myHero, SUMMONER_2):lower():find("summonerdot") then
      		igniteFound = true
      		summonerSpells.ignite = SUMMONER_2
      		LuxMenu.Ks:Boolean("Ign", "Auto Ignite", true)
    	end
	end
end) 

OnTick(function ()
	Killsteal()
	LuxW()
end)

function Killsteal() 
	if igniteFound and LuxMenu.Ks.Ign:Value() and Ready(summonerSpells.ignite) then
    local iDamage = (50 + (20 * GetLevel(myHero)))
      	for _, enemy in pairs(GetEnemyHeroes()) do
        	if ValidTarget(enemy, 600) and (GetCurrentHP(enemy) + 5) <= iDamage then
          		CastTargetSpell(enemy, summonerSpells.ignite)
          	end
        end
	end
end

function LuxW()
	if Ready(_W) and GetPercentHP(myHero) <= LuxMenu.Combo.WM:Value() and LuxMenu.Combo.W:Value() and EnemiesAround(myHero, 700) >= LuxMenu.Combo.WMA:Value() then
			CastSkillShot(_W,myHero.pos)
	end
end

OnTick(function()
	local target = GetCurrentTarget()
	if Mix:Mode() == "Combo" then
		--if GetPercentHP(ally) < 80 and Ready(_W) and LuxMenu.Combo.WA:Value() and EnemiesAround(ally.pos, 700) > 0 then
					--	CastSkillShot(_W,ally.pos)
		--end
		if LuxMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 1300) then
		local QPred = GetPrediction(target,LuxQ)
			if QPred.hitChance > 0.2 and not QPred:mCollision(2) then
				CastSkillShot(_Q,QPred.castPos)
			end
		end
		if LuxMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 1150) then
		local EPred = GetCircularAOEPrediction(target,LuxE)
			if EPred.hitChance > 0.2 then
				CastSkillShot(_E,EPred.castPos)
			end
		end
		for _, enemy in pairs(GetEnemyHeroes()) do
			if LuxMenu.Ks.R:Value() and LuxMenu.Ks.R:Value() and Ready(_R) and ValidTarget(enemy, 1700) then 
                  if GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, (250 + 100 * GetCastLevel(myHero,_R) + GetBonusAP(myHero) * 0.75)) then
						local RPred = GetPrediction(target,LuxR)
						if RPred.hitChance > .8 then
							CastSkillShot(_R,RPred.castPos)
						end
				  end
			end
		end
	end
end)

OnDraw (function()
	if not IsDead(myHero) then
		if LuxMenu.draw.qdraw:Value() and Ready(_Q) then
			DrawCircle(GetOrigin(myHero), 1250, LuxMenu.draw.cwidth:Value(), LuxMenu.draw.cquality:Value(), LuxMenu.draw.qcirclecol:Value())
		end
		if LuxMenu.draw.wdraw:Value() and Ready(_W) then 
			DrawCircle(GetOrigin(myHero), 700, LuxMenu.draw.cwidth:Value(), LuxMenu.draw.cquality:Value(), LuxMenu.draw.wcirclecol:Value())
		end
		if LuxMenu.draw.edraw:Value() and Ready(_E) then 
			DrawCircle(GetOrigin(myHero), 1150, LuxMenu.draw.cwidth:Value(), LuxMenu.draw.cquality:Value(), LuxMenu.draw.ecirclecol:Value())
		end
	end
end)

print("GamingonSteroids.com Share it with your friends!")
print("Lux Deluxe Edition Loaded")

elseif GetObjectName(GetMyHero()) == "Riven" then

local ver = "0.05"

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat("New version found! " .. data)
        PrintChat("Downloading update, please wait...")
        DownloadFileAsync("https://raw.githubusercontent.com/Farscape2000/GOS/master/Victorious-Riven.lua", SCRIPT_PATH .. "Victorious-Riven.lua", function() PrintChat("Update Complete, please 2x F6!") return end)
    else
        PrintChat("No updates found!")
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/Farscape2000/GOS/master/Versions/Victorious-Riven.version", AutoUpdate)

if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end

require("OpenPredict")
local RivenMenu = Menu("Riven", "Riven - The Exile")
RivenMenu:SubMenu("Combo", "Combo")
RivenMenu:SubMenu("Ks", "Killsteal")
RivenMenu:SubMenu("misc", "Misc Settings")
RivenMenu:SubMenu("drawing", "Draw Settings")
RivenMenu:SubMenu("SubReq",  "AutoLevel Settings")

RivenMenu.Combo:Boolean("Q", "Use Q", true)
RivenMenu.Combo:Boolean("W", "Use W", true)
RivenMenu.Combo:Boolean("E", "Use E", true)
RivenMenu.Combo:Boolean("Ign", "Auto Ignite", true)

RivenMenu.Ks:Boolean("KSW", "Killsteal with W", true)

local skinMeta       = {["Riven"] = {"Classic", "Crimson Elite", "Redeemed", "Battle Bunny", "Championship", "Dragonblade", "Arcade"}} --fix these
RivenMenu.misc:DropDown('skin', myHero.charName.. " Skins", 1, skinMeta[myHero.charName], HeroSkinChanger, true)
RivenMenu.misc.skin.callback = function(model) HeroSkinChanger(myHero, model - 1) print(skinMeta[myHero.charName][model] .." ".. myHero.charName .. " Loaded!") end
RivenMenu.drawing:Boolean("mDraw", "Disable All Range Draws", false)
for i = 0,3 do
	local str = {[0] = "Q", [1] = "W", [2] = "E", [3] = "R"}
	RivenMenu.drawing:Boolean(str[i], "Draw "..str[i], true)
	RivenMenu.drawing:ColorPick(str[i].."c", "Drawing Color", {255, 25, 155, 175})
end

RivenMenu.SubReq:Boolean("LevelUp", "Level Up Skills", true)
RivenMenu.SubReq:Slider("Start_Level", "Level to enable lvlUP", 1, 1, 17)
RivenMenu.SubReq:DropDown("autoLvl", "Skill order", 1, {"Q-E-W",})
RivenMenu.SubReq:Boolean("Humanizer", "Enable Level Up Humanizer", true)

local RivenQ = {delay = .5, range = 250 , radius = 0, speed = 0}
local RivenE = {delay = 0, range = 325, radius = 0, speed = 1450}
local igniteFound = false
local summonerSpells = {ignite = {}, flash = {}, heal = {}, barrier = {}}
local LevelUpTable={
	[1]={_E,_Q,_W,_Q,_Q,_R,_Q,_E,_Q,_E,_R,_E,_E,_W,_W,_R,_W,_W}
}	

OnTick(function ()
	Killsteal()
end)

OnTick (function()
		if RivenMenu.SubReq.LevelUp:Value() and GetLevelPoints(myHero) >= 1 and GetLevel(myHero) >= RivenMenu.SubReq.Start_Level:Value() then
	        if RivenMenu.SubReq.Humanizer:Value() then
	            DelayAction(function() LevelSpell(LevelUpTable[RivenMenu.SubReq.autoLvl:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1]) end, math.random(0.3286,1.33250))
	        else
	            LevelSpell(LevelUpTable[RivenMenu.SubReq.autoLvl:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1])
	        end
		end
end)

OnTick(function()
	local target = GetCurrentTarget()
	if Mix:Mode() == "Combo" then
		if RivenMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 400) then	             
			CastSkillShot(_E, target.pos)
		end
		if RivenMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 260) then	             
			CastSpell(_W)
		end
		if RivenMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 250) then
            if GotBuff(myHero, "rivenpassiveaaboost") == 0 then
                local QPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target), math.huge, 75, 600, 150, false, true)
                if QPred.HitChance == 1 then
                    CastSkillShot(_Q,QPred.PredPos)    
                end
            end
        end
		-- killsteal
		for _, enemy in pairs(GetEnemyHeroes()) do
			if RivenMenu.Combo.W:Value() and RivenMenu.Ks.KSW:Value() and Ready(_W) and ValidTarget(enemy, 260) then
				if GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, 20 + 30 * GetCastLevel(myHero,_R) + GetBonusDmg(myHero) * 1.0, 0) then
					CastSpell(_W)
				end
			end
		end
	end
end)

function Killsteal() 
	if igniteFound and RivenMenu.Combo.Ign:Value() and Ready(summonerSpells.ignite) then
    local iDamage = (50 + (20 * GetLevel(myHero)))
      	for _, enemy in pairs(GetEnemyHeroes()) do
        	if ValidTarget(enemy, 600) and (GetCurrentHP(enemy) + 5) <= iDamage then
          		CastTargetSpell(enemy, summonerSpells.ignite)
          	end
        end
	end
end

OnLoad (function()
	if not igniteFound then
    	if GetCastName(myHero, SUMMONER_1):lower():find("summonerdot") then
      		igniteFound = true
      		summonerSpells.ignite = SUMMONER_1
      		RivenMenu.Combo:Boolean("Ign", "Auto Ignite", true)
    	elseif GetCastName(myHero, SUMMONER_2):lower():find("summonerdot") then
      		igniteFound = true
      		summonerSpells.ignite = SUMMONER_2
      		RivenMenu.Combo:Boolean("Ign", "Auto Ignite", true)
    	end
	end
end)

print("Riven - The Exile Loaded")

elseif GetObjectName(GetMyHero()) == "Kassadin" then

if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end

require("OpenPredict")
local KassadinMenu = Menu("Kassadin", "Kassadin - The Void Walker")
KassadinMenu:SubMenu("Combo", "Combo")
KassadinMenu:SubMenu("ksteal", "Killsteal")
KassadinMenu:SubMenu("SubReq", "["..myHero.charName.."] - AutoLevel Settings")
KassadinMenu.SubReq:Boolean("LevelUp", "Level Up Skills", true)
KassadinMenu.SubReq:Slider("Start_Level", "Level to enable lvlUP", 1, 1, 17)
KassadinMenu.SubReq:DropDown("autoLvl", "Skill order", 1, {"E-Q-W","Q-W-Q","Q-E-W",})
KassadinMenu.SubReq:Boolean("Humanizer", "Enable Level Up Humanizer", true)
KassadinMenu.Combo:Boolean("Q", "Use Q", true)
KassadinMenu.Combo:Boolean("W", "Use W", true)
KassadinMenu.Combo:Boolean("E", "Use E", true)
KassadinMenu.Combo:Boolean("R", "Use R", true)
KassadinMenu.Combo:Boolean("KSQ", "Killsteal with Q", true)
KassadinMenu.Combo:Boolean("KSE", "Killsteal with E", true)
KassadinMenu.Combo:Boolean("OnMana", "Combo if enough mana", true)
KassadinMenu.Combo:Slider("Rmana", "Choose mana to stop R", 800, 100, 2000)
KassadinMenu:SubMenu("misc", "["..myHero.charName.."] - Misc Settings")
KassadinMenu.misc:DropDown("skinList", "Choose your skin", 6, { "Festival Kassadin", "Deep One Kassadin", "Pre-Void Kassadin", "Harbinger Kassadin", "Cosmic Reaver Kassadin" })
KassadinMenu:SubMenu("drawing", "["..myHero.charName.."] - Draw Settings")	
KassadinMenu.drawing:Boolean("mDraw", "Disable All Range Draws", false)
for i = 0,3 do
local str = {[0] = "Q", [1] = "W", [2] = "E", [3] = "R"}
KassadinMenu.drawing:Boolean(str[i], "Draw "..str[i], true)
KassadinMenu.drawing:ColorPick(str[i].."c", "Drawing Color", {255, 25, 155, 175})
end

local igniteFound = false
local summonerSpells = {ignite = {}, flash = {}, heal = {}, barrier = {}}
local KassadinE = {delay = 0.5, range = 700, width = 10, speed = math.huge}
local KassadinR = {delay = 0.5, range = 500, width = 150, speed = math.huge}   
local LevelUpTable={
			[1]={_Q,_W,_E,_E,_E,_R,_E,_Q,_E,_Q,_R,_Q,_Q,_W,_W,_R,_W,_W},

			[2]={_Q,_W,_E,_Q,_Q,_R,_Q,_E,_Q,_E,_R,_E,_E,_W,_W,_R,_W,_W},

			[3]={_Q,_E,_W,_Q,_Q,_R,_Q,_E,_Q,_E,_R,_E,_E,_W,_W,_R,_W,_W}
		}

	SpellRanges = 
	  {
	  [_Q] = {range = GetCastRange(myHero, 0)},
	  [_W] = {range = GetCastRange(myHero, 1)},
	  [_E] = {range = GetCastRange(myHero, 2)},
	  [_R] = {range = GetCastRange(myHero, 3)}
	  }
	  
OnLoad (function()
	if not igniteFound then
    	if GetCastName(myHero, SUMMONER_1):lower():find("summonerdot") then
      		igniteFound = true
      		summonerSpells.ignite = SUMMONER_1
      		KassadinMenu.ksteal:Boolean("ignite", "Auto Ignite", true)
    	elseif GetCastName(myHero, SUMMONER_2):lower():find("summonerdot") then
      		igniteFound = true
      		summonerSpells.ignite = SUMMONER_2
      		KassadinMenu.ksteal:Boolean("ignite", "Auto Ignite", true)
    	end
	end
end) 

lastSkin = 0
	function ChooseSkin()
		if KassadinMenu.misc.skinList:Value() ~= lastSkin then
			lastSkin = KassadinMenu.misc.skinList:Value()
			HeroSkinChanger(myHero, KassadinMenu.misc.skinList:Value())
		end
	end

OnTick (function()
		if KassadinMenu.SubReq.LevelUp:Value() and GetLevelPoints(myHero) >= 1 and GetLevel(myHero) >= KassadinMenu.SubReq.Start_Level:Value() then
	        if KassadinMenu.SubReq.Humanizer:Value() then
	            DelayAction(function() LevelSpell(LevelUpTable[KassadinMenu.SubReq.autoLvl:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1]) end, math.random(0.3286,1.33250))
	        else
	            LevelSpell(LevelUpTable[KassadinMenu.SubReq.autoLvl:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1])
	        end
	end
end)
	
OnTick(function ()
	Killsteal()
end)

OnTick(function (myHero)
	local target = GetCurrentTarget()	
	if Mix:Mode() == "Combo" then
        
		if KassadinMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 650) then
			CastTargetSpell(target , _Q)
		end
		if KassadinMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 150) then
			CastSpell(_W)
		end
		if KassadinMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 700) then
		local EPred = GetPrediction(target,KassadinE)
			if EPred.hitChance > 0.2 then
				CastSkillShot(_E,EPred.castPos)
			end
		end

            if KassadinMenu.Combo.Rmana:Value() > GetCastMana(myHero, 3, GetCastLevel(myHero, 3)) then
		if KassadinMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 500) then
		local RPred = GetPrediction(target,KassadinR)
			if RPred.hitChance > 0.2 then
				CastSkillShot(_R,RPred.castPos)
			end
		end
            else return end
		for _, enemy in pairs(GetEnemyHeroes()) do 
			if KassadinMenu.Combo.Q:Value() and KassadinMenu.Combo.KSQ:Value() and Ready(_Q) and ValidTarget(enemy, 650) then 
				if GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, (45 + 25 * GetCastLevel(myHero,_Q) + GetBonusAP(myHero))) then 
					CastTargetSpell(target , _Q)
				end
			end
		end
		if KassadinMenu.Combo.E:Value() and KassadinMenu.Combo.KSE:Value() and Ready(_E) and ValidTarget(enemy, 700) then
                  if GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, (55 + 25 * GetCastLevel(myHero,_E) + GetBonusAP(myHero))) then
                    CastSkillShot(_E,EPred.castPos)
                  end
                end
              
	end	
end)

function Killsteal() 
	if igniteFound and KassadinMenu.ksteal.ignite:Value() and Ready(summonerSpells.ignite) then
    local iDamage = (50 + (20 * GetLevel(myHero)))
      	for _, enemy in pairs(GetEnemyHeroes()) do
        	if ValidTarget(enemy, 600) and (GetCurrentHP(enemy) + 5) <= iDamage then
          		CastTargetSpell(enemy, summonerSpells.ignite)
          	end
        end
	end
end

OnDraw(function()
	ChooseSkin()
	if not KassadinMenu.drawing.mDraw:Value() then
		for i,s in pairs({"Q","W","E","R"}) do
		    if KassadinMenu.drawing[s]:Value() then
		      DrawCircle(myHero.pos, SpellRanges[i-1].range, 1, 32, KassadinMenu.drawing[s.."c"]:Value())
		    end
		end
	end
end)

print ("Kassadin - The Void Walker Loaded")

elseif GetObjectName(GetMyHero()) == "Blitzcrank" then

local ver = "0.07"

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat("New version found! " .. data)
        PrintChat("Downloading update, please wait...")
        DownloadFileAsync("https://raw.githubusercontent.com/Farscape2000/GOS/master/BlitzcrankVer%20I.lua", SCRIPT_PATH .. "BlitzcrankVerI.lua", function() PrintChat("Update Complete, please 2x F6!") return end)
    else
        PrintChat("No updates found!")
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/Farscape2000/GOS/master/BlitzcrankVer%20I.version", AutoUpdate)

if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end

require("OpenPredict")
local BlitzcrankMenu = Menu("Blitzcrank", "Blitzcrank")
BlitzcrankMenu:SubMenu("Combo", "Combo")
BlitzcrankMenu.Combo:Boolean("Q", "Use Q", true)
BlitzcrankMenu.Combo:Boolean("W", "Use W", true)
BlitzcrankMenu.Combo:Boolean("E", "Use E", true)
BlitzcrankMenu.Combo:Boolean("R", "Use R", true)
BlitzcrankMenu.Combo:Boolean("KSQ", "Killsteal with Q", true)
BlitzcrankMenu.Combo:Boolean("KSR", "Killsteal with R", true)
BlitzcrankMenu:SubMenu("draw", "Draws")
BlitzcrankMenu.draw:Slider("cwidth", "Circle Width", 1, 1, 10, 1)
BlitzcrankMenu.draw:Slider("cquality", "Circle Quality", 1, 0, 8, 1)
BlitzcrankMenu.draw:Boolean("qdraw", "Draw Q", true)
BlitzcrankMenu.draw:ColorPick("qcirclecol", "Q Circle color", {255, 134, 26, 217}) 
BlitzcrankMenu.draw:Boolean("rdraw", "Draw R", true)
BlitzcrankMenu.draw:ColorPick("rcirclecol", "R Circle color", {255, 134, 26, 217})
local BlitzcrankQ = {delay = 0.22, range = 925, width = 70, speed = 1750}
OnTick(function (myHero)
	local target = GetCurrentTarget()	
	if Mix:Mode() == "Combo" then
		if BlitzcrankMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 925) then
		local QPred = GetPrediction(target,BlitzcrankQ)
			if QPred.hitChance > 0.5 then
				CastSkillShot(_Q,QPred.castPos)
			end		 
		end
		if BlitzcrankMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 1000) then	             
			CastSpell(_W)
		end	
		if BlitzcrankMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 150) then	
			CastSpell(_E)
		end	
		if BlitzcrankMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 600) then	
			CastSpell(_R)			 
		end
	end
	for _, enemy in pairs(GetEnemyHeroes()) do 
		if BlitzcrankMenu.Combo.R:Value() and BlitzcrankMenu.Combo.KSR:Value() and Ready(_R) and ValidTarget(enemy, 600) then 
			if GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, (125 + 125 * GetCastLevel(myHero,_R) + GetBonusAP(myHero))) then 
				CastSpell(_R)
			end
		end	
	end		
end)

OnDraw (function()
	if not IsDead(myHero) then
		if BlitzcrankMenu.draw.qdraw:Value() and Ready(_Q) then
			DrawCircle(GetOrigin(myHero), 925, BlitzcrankMenu.draw.cwidth:Value(), BlitzcrankMenu.draw.cquality:Value(), BlitzcrankMenu.draw.qcirclecol:Value())
		end
		if BlitzcrankMenu.draw.rdraw:Value() and Ready(_R) then 
			DrawCircle(GetOrigin(myHero), 600, BlitzcrankMenu.draw.cwidth:Value(), BlitzcrankMenu.draw.cquality:Value(), BlitzcrankMenu.draw.rcirclecol:Value())
		end
	end
end)
		 
print("BlitzcrankVer1.2 loaded")

elseif GetObjectName(GetMyHero()) == "Katarina" then 

if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end

local KatarinaMenu = Menu("Katarina", "Katarina")
KatarinaMenu:SubMenu("Combo", "Combo")
KatarinaMenu.Combo:Boolean("KILL", "Kill when possible", true)
KatarinaMenu:SubMenu("ksteal", "Killsteal")
KatarinaMenu.Combo:Boolean("PokeQ", "autoQ", true)

local castingR = false
local mark = nil
local igniteFound = false
local summonerSpells = {ignite = {}, flash = {}, heal = {}, barrier = {}}

OnLoad (function()
	if not igniteFound then
    	if GetCastName(myHero, SUMMONER_1):lower():find("summonerdot") then
      		igniteFound = true
      		summonerSpells.ignite = SUMMONER_1
      		KatarinaMenu.ksteal:Boolean("ignite", "Auto Ignite", true)
    	elseif GetCastName(myHero, SUMMONER_2):lower():find("summonerdot") then
      		igniteFound = true
      		summonerSpells.ignite = SUMMONER_2
      		KatarinaMenu.ksteal:Boolean("ignite", "Auto Ignite", true)
    	end
	end
end) 

OnUpdateBuff (function(unit, buff)
	if not unit or not buff then 
		return 
	end 
	if unit.isMe then
		if buff.Name:lower() == "katarinarsound" then
			Mix:BlockMovement(false)
			Mix:BlockAttack(false)
			BlockF7OrbWalk(true)
			BlockF7Dodge(true)
			castingR = true
		end
	end
	if not unit.isMe and not unit.isMinion then
		if buff.Name:lower() == "katarinaqmark" then
			mark = unit.name
		end
	end
end)

OnRemoveBuff (function(unit, buff) 
	if not unit or not buff then 
		return 
	end 
	if unit.isMe then
		if buff.Name:lower() == "katarinarsound" then
			Mix:BlockMovement(true)
			Mix:BlockAttack(true)
			BlockF7OrbWalk(false)
			BlockF7Dodge(false)
			castingR = false
		end
	end
	if not unit.isMe and not unit.isMinion then 
		if buff.Name:lower() == "katarinaqmark" then
			mark = nil
		end
	end
end)


OnTick(function ()
	Killsteal()
	kataPoke()
	if Mix:Mode() == "Combo" then
		Combo()
	end
end)

function Combo()
	local target = GetCurrentTarget() 
	if KatarinaMenu.Combo.KILL:Value() and ValidTarget(target, 675) then
		local damage = 0;
		if Ready(_Q) and not castingR then
			damage = damage + CalcDamage(myHero, target, 0, (35 + 25 * GetCastLevel(myHero,_Q) + GetBonusAP(myHero) * 0.45))
		end
		if Ready(_W) and not castingR then
			damage = damage + CalcDamage(myHero, target, 0, (5 + 35 * GetCastLevel(myHero,_W) + GetBonusAP(myHero) * 0.25))
			if (mark ~= nil) and (mark == GetObjectBaseName(target)) then -- that should be proper mark tracking yeah he needed to go btw
				damage = damage + CalcDamage(myHero, target, 0, (15 * GetCastLevel(myHero,_Q) + GetBonusAP(myHero) * 0.2))
			end
		end
		if Ready(_E) and not castingR then
			damage = damage + CalcDamage(myHero, target, 0, (10 + 30 * GetCastLevel(myHero,_E) + GetBonusAP(myHero) * 0.25))
			if (mark ~= nil) and (mark == GetObjectBaseName(target)) then
				damage = damage + CalcDamage(myHero, target, 0, (15 * GetCastLevel(myHero,_Q) + GetBonusAP(myHero) * 0.2))
			end
		end
		if Ready(_R) then -- no range check?
			damage = damage + CalcDamage(myHero, target, 0, (150 + 200 * GetCastLevel(myHero,_R) + GetBonusAP(myHero) * 2.5))
			if (mark ~= nil) and (mark == GetObjectBaseName(target)) then
				damage = damage + CalcDamage(myHero, target, 0, (15 * GetCastLevel(myHero,_Q) + GetBonusAP(myHero) * 0.2))
			end
		end
		if GetCurrentHP(target) < damage then
			if Ready(_E) and ValidTarget(target, 700) then
				CastTargetSpell(target , _E)
			end
			if Ready(_Q) and ValidTarget(target, 675) then
				CastTargetSpell(target , _Q)
			end
			if Ready(_W) and ValidTarget(target, 375) then
				CastSpell(_W)
			end
			if Ready(_R) and ValidTarget(target, 550) then
				CastSpell(_R)
			end
		end
	end
end

function Killsteal() 
	if igniteFound and KatarinaMenu.ksteal.ignite:Value() and Ready(summonerSpells.ignite) then
    local iDamage = (50 + (20 * GetLevel(myHero)))
      	for _, enemy in pairs(GetEnemyHeroes()) do
        	if ValidTarget(enemy, 600) and (GetCurrentHP(enemy) + 5) <= iDamage then
          		CastTargetSpell(enemy, summonerSpells.ignite)
          	end
        end
	end
end

	function kataPoke()
 local target = GetCurrentTarget()
 if KatarinaMenu.Combo.PokeQ:Value() then
  if Ready(_Q) and ValidTarget(target, 675) then
   CastTargetSpell(target , _Q)
  end
 end
end

print("Katarina Loaded")

elseif GetObjectName(GetMyHero()) == "Nautilus" then

if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end

local ver = "0.04"

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat("New version found! " .. data)
        PrintChat("Downloading update, please wait...")
        DownloadFileAsync("https://raw.githubusercontent.com/Farscape2000/GOS/master/Nautilus.lua", SCRIPT_PATH .. "Nautilus.lua", function() PrintChat("Update Complete, please 2x F6!") return end)
    else
        PrintChat("No updates found!")
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/Farscape2000/GOS/master/Versions/NautilusVersion.lua", AutoUpdate)

require("OpenPredict")
local NautilusMenu = Menu("Nautilus", "Nautilus - The Titan Of The Depths")
NautilusMenu:SubMenu("Combo", "Combo")
NautilusMenu:SubMenu("Interupter", "Interupter")
NautilusMenu:SubMenu("SubReq",  "AutoLevel Settings")
NautilusMenu:SubMenu("RS", "R Selector")
NautilusMenu.RS:Boolean("RS", "R Selector")
NautilusMenu.SubReq:Boolean("LevelUp", "Level Up Skills", true)
NautilusMenu.SubReq:Slider("Start_Level", "Level to enable lvlUP", 1, 1, 17)
NautilusMenu.SubReq:DropDown("autoLvl", "Skill order", 1, {"E-Q-W","Q-W-Q","Q-E-W",})
NautilusMenu.SubReq:Boolean("Humanizer", "Enable Level Up Humanizer", true)
NautilusMenu.Combo:Boolean("Q", "Use Q", true)
NautilusMenu.Combo:Boolean("W", "Use W", true)
NautilusMenu.Combo:Boolean("E", "Use E", true)
NautilusMenu.Combo:Boolean("R", "Use R", true)
NautilusMenu:SubMenu("misc", "Misc Settings")
NautilusMenu.misc:DropDown("skinList", "Choose your skin", 5, { "Abyssal Nautilus", "Subterranean Nautilus", "AstroNautilus", "Warden Nautilus" })
NautilusMenu:SubMenu("drawing", "Draw Settings")	
NautilusMenu.drawing:Boolean("mDraw", "Disable All Range Draws", false)
for i = 0,3 do
	local str = {[0] = "Q", [1] = "W", [2] = "E", [3] = "R"}
	NautilusMenu.drawing:Boolean(str[i], "Draw "..str[i], true)
	NautilusMenu.drawing:ColorPick(str[i].."c", "Drawing Color", {255, 25, 155, 175})
end

local NautilusQ = {delay = 250, range = 1100, radius = 90, speed = 2000}
local LevelUpTable={
	[1]={_Q,_W,_E,_E,_E,_R,_E,_Q,_E,_Q,_R,_Q,_Q,_W,_W,_R,_W,_W}, --fix these to champion.gg
	[2]={_Q,_W,_E,_Q,_Q,_R,_Q,_E,_Q,_E,_R,_E,_E,_W,_W,_R,_W,_W},
	[3]={_Q,_E,_W,_Q,_Q,_R,_Q,_E,_Q,_E,_R,_E,_E,_W,_W,_R,_W,_W}
}		
	 
OnTick(function (myHero)
	local target = GetCurrentTarget()	
	if Mix:Mode() == "Combo" then
		if NautilusMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 175) then	             
			CastSpell(_W)
		end
		if NautilusMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 1100) then 
		local QPred = GetPrediction(target,NautilusQ)
			if QPred.hitChance > 0.2 and not QPred:mCollision(1) then
				CastSkillShot(_Q,QPred.castPos)
			end
		end
		if NautilusMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 600) then 
			CastSpell(_E)
		end
		if NautilusMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 825) then
			CastTargetSpell(_R)
		end
	end
end)
	 
lastSkin = 0
function ChooseSkin()
	if NautilusMenu.misc.skinList:Value() ~= lastSkin then
		lastSkin = NautilusMenu.misc.skinList:Value()
		HeroSkinChanger(myHero, NautilusMenu.misc.skinList:Value())
	end
end

OnTick (function()
		if NautilusMenu.SubReq.LevelUp:Value() and GetLevelPoints(myHero) >= 1 and GetLevel(myHero) >= NautilusMenu.SubReq.Start_Level:Value() then
			if NautilusMenu.SubReq.Humanizer:Value() then
			DelayAction(function() LevelSpell(LevelUpTable[NautilusMenu.SubReq.autoLvl:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1]) end, math.random(0.3286,1.33250))
			else
				LevelSpell(LevelUpTable[NautilusMenu.SubReq.autoLvl:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1])
			end
		end
end)

--]OnProcessSpell(function(unit,spellProc)
	--if GetTeam(unit) ~= MINION_ALLY and Interupter[spellProc.name]	then
		--if NautilusMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(unit, 1000) then 
		--local QPred = GetPrediction(unit,NautilusQ)
			--if QPred.hitChance > 0.2 and not QPred:mCollision(1) then
				--CastSkillShot(_Q,QPred.castPos)
			--end
		--end
	--end
--end)

--local Interupter = {
   -- ["CaitlynAceintheHole"]         = {charName = "Caitlyn"		},
   -- ["Crowstorm"]                   = {charName = "FiddleSticks"},
  --  ["Drain"]                       = {charName = "FiddleSticks"},
  --  ["GalioIdolOfDurand"]           = {charName = "Galio"		},
   -- ["ReapTheWhirlwind"]            = {charName = "Janna"		},
	--["JhinR"]						= {charName = "Jhin"		},
  --  ["KarthusFallenOne"]            = {charName = "Karthus"     },
   -- ["KatarinaR"]                   = {charName = "Katarina"    },
   -- ["LucianR"]                     = {charName = "Lucian"		},
   -- ["AlZaharNetherGrasp"]          = {charName = "Malzahar"	},
   -- ["MissFortuneBulletTime"]       = {charName = "MissFortune"	},
   -- ["AbsoluteZero"]                = {charName = "Nunu"		},                       
    --["PantheonRJump"]               = {charName = "Pantheon"	},
   -- ["ShenStandUnited"]             = {charName = "Shen"		},
   -- ["Destiny"]                     = {charName = "TwistedFate"	},
    --["UrgotSwap2"]                  = {charName = "Urgot"		},
   -- ["VarusQ"]                      = {charName = "Varus"		},
  --  ["VelkozR"]                     = {charName = "Velkoz"		},
   -- ["InfiniteDuress"]              = {charName = "Warwick"		},
   -- ["XerathLocusOfPower2"]         = {charName = "Xerath"		},
--}

print ("Nautilus - The Titan Of The Depths Loaded")

elseif GetObjectName(GetMyHero()) == "Braum" then

if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end

require("OpenPredict")
local BraumMenu = Menu("Braum", "The Heart of The Freljord")
BraumMenu:SubMenu("Combo", "Combo")
BraumMenu:SubMenu("misc", "Misc Settings")
BraumMenu:SubMenu("SubReq",  "AutoLevel Settings")
BraumMenu:SubMenu("draw", "Draws")

BraumMenu.Combo:Boolean("Q", "Use Q", true)
BraumMenu.Combo:Boolean("W", "Use W", true)
BraumMenu.Combo:Boolean("E", "Use E", true)
BraumMenu.Combo:Boolean("EALLY", "Use E To Defend Ally", true)
BraumMenu.Combo:Boolean("R", "Use R", true)
BraumMenu.Combo:Slider("WA", "W Slider % Ally HP", 40, 1, 100, 1)
BraumMenu.Combo:Slider("EM", "E Slider % HP", 40, 1, 100, 1)
BraumMenu.Combo:Slider("EA", "E Slider % Ally HP", 40, 1, 100, 1)
BraumMenu.Combo:Slider("RE", "Use r on x enemies", 3, 1, 5, 1)
BraumMenu.Combo:Slider("SR", "use r if enemy hp below x %", 40, 1, 100, 1)

local skinMeta       = {["Braum"] = {"Classic", "Dragonslayer Braum", "El Tigre Braum", "Braum Lionheart"}}
BraumMenu.misc:DropDown('skin', myHero.charName.. " Skins", 1, skinMeta[myHero.charName], HeroSkinChanger, true)
BraumMenu.misc.skin.callback = function(model) HeroSkinChanger(myHero, model - 1) print(skinMeta[myHero.charName][model] .." ".. myHero.charName .. " Loaded!") end

BraumMenu.SubReq:Boolean("LevelUp", "Level Up Skills", true)
BraumMenu.SubReq:Slider("Start_Level", "Level to enable lvlUP", 1, 1, 18)
BraumMenu.SubReq:DropDown("autoLvl", "Skill order", 1, {"Q-W-E",})
BraumMenu.SubReq:Boolean("Humanizer", "Enable Level Up Humanizer", true)

BraumMenu.draw:Slider("cwidth", "Circle Width", 1, 1, 10, 1)
BraumMenu.draw:Slider("cquality", "Circle Quality", 1, 0, 8, 1)
BraumMenu.draw:Boolean("qdraw", "Draw Q", true)
BraumMenu.draw:ColorPick("qcirclecol", "Q Circle color", {255, 134, 26, 217}) 
BraumMenu.draw:Boolean("wdraw", "Draw W", true)
BraumMenu.draw:ColorPick("wcirclecol", "W Circle color", {255, 134, 26, 217})
BraumMenu.draw:Boolean("rdraw", "Draw R", true)
BraumMenu.draw:ColorPick("rcirclecol", "R Circle color", {255, 134, 26, 217})

local BraumQ = {delay = 0.25, range = 1000, radius = 60, speed = 1700}
local BraumR = {delay = 0.5, range = 1250, radius = 115, speed = 1400}
local LevelUpTable={
	[1]={_Q,_E,_W,_Q,_Q,_R,_Q,_E,_Q,_E,_R,_E,_E,_W,_W,_R,_W,_W} 
}	

OnTick (function()
		if BraumMenu.SubReq.LevelUp:Value() and GetLevelPoints(myHero) >= 1 and GetLevel(myHero) >= BraumMenu.SubReq.Start_Level:Value() then
	        if BraumMenu.SubReq.Humanizer:Value() then
	            DelayAction(function() LevelSpell(LevelUpTable[BraumMenu.SubReq.autoLvl:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1]) end, math.random(0.3286,1.33250))
	        else
	            LevelSpell(LevelUpTable[BraumMenu.SubReq.autoLvl:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1])
	        end
		end
end)

OnDraw (function()
	if not IsDead(myHero) then
		if BraumMenu.draw.qdraw:Value() and Ready(_Q) then
			DrawCircle(GetOrigin(myHero), 1000, BraumMenu.draw.cwidth:Value(), BraumMenu.draw.cquality:Value(), BraumMenu.draw.qcirclecol:Value())
		end
		if BraumMenu.draw.wdraw:Value() and Ready(_W) then 
			DrawCircle(GetOrigin(myHero), 650, BraumMenu.draw.cwidth:Value(), BraumMenu.draw.cquality:Value(), BraumMenu.draw.wcirclecol:Value())
		end
		if BraumMenu.draw.edraw:Value() and Ready(_R) then 
			DrawCircle(GetOrigin(myHero), 1250, BraumMenu.draw.cwidth:Value(), BraumMenu.draw.cquality:Value(), BraumMenu.draw.rcirclecol:Value())
		end
	end
end)

OnTick(function()
	local target = GetCurrentTarget()
	if Mix:Mode() == "Combo" then
		if BraumMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 1000) then
		local QPred = GetPrediction(target,BraumQ)
			if QPred.hitChance > 0.2 and not QPred:mCollision(1) then
				CastSkillShot(_Q,QPred.castPos)
			end
		end
		if Ready(_E) and GetPercentHP(myHero) <= BraumMenu.Combo.EM:Value() and BraumMenu.Combo.E:Value() then
			CastSkillShot(_E, target.pos)
		end
		if Ready(_R) and EnemiesAround(myHero, 1250) >= BraumMenu.Combo.RE:Value() and BraumMenu.Combo.R:Value() then
		local RPred = GetPrediction(target,BraumR)
			if RPred.hitChance > 0.4 then
				CastSkillShot(_R,RPred.castPos)
			end
		end
		if Ready(_R) and GetPercentHP(target) <= BraumMenu.Combo.SR:Value() and BraumMenu.Combo.R:Value() then
		local RPred = GetPrediction(target,BraumR)
			if RPred.hitChance > 0.4 then
				CastSkillShot(_R,RPred.castPos)
			end
		end
		for _, ally in pairs(GetAllyHeroes()) do
			if Ready(_W) and GetPercentHP(ally) <= BraumMenu.Combo.WA:Value() and BraumMenu.Combo.W:Value() and GetDistance(ally, myHero) < 650 then
				CastTargetSpell(ally, _W)
			end
			if Ready(_E) and GetPercentHP(ally) <= BraumMenu.Combo.EA:Value() and BraumMenu.Combo.EALLY:Value() then
				CastSkillShot(_E, target.pos)
			end
		end
	end
end)

print("Braum Loaded")

else 
return 
end

local ver = "1.1"

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat("New version found! " .. data)
        PrintChat("Downloading update, please wait...")
        DownloadFileAsync("https://raw.githubusercontent.com/Farscape2000/GOS/master/All%20Series.lua", SCRIPT_PATH .. "All Series.lua", function() PrintChat("Update Complete, please 2x F6!") return end)
    else
        PrintChat("No updates found!")
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/Farscape2000/GOS/master/Versions/All%20Series.version", AutoUpdate)

print("Hello Thanks for using All Series AIO")
