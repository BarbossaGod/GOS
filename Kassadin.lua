if GetObjectName(GetMyHero()) ~= "Kassadin" then return end

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
	if IOW:Mode() == "Combo" then
        
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
