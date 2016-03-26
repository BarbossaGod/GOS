if GetObjectName(GetMyHero()) ~= "Katarina" then return end

require("Inspired")

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
			IOW.movementEnabled = false
			IOW.attacksEnabled = false
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
			IOW.movementEnabled = true
			IOW.attacksEnabled = true
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
	if IOW:Mode() == "Combo" then -- if u wanna add killsteal which u should just add it in its own function
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
