if GetObjectName(GetMyHero()) ~= "Lux" then return end

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
	if IOW:Mode() == "Combo" then
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
