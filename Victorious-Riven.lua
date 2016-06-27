if GetObjectName(GetMyHero()) ~= "Riven" then return end

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
	if IOW:Mode() == "Combo" then
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
