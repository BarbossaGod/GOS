if GetObjectName(GetMyHero()) ~= "Blitzcrank" then return end

local ver = "0.01"

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

require("Inspired")

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

OnTick(function (myHero)
	local target = GetCurrentTarget()	
	if IOW:Mode() == "Combo" then
		if BlitzcrankMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 925) then
			local RPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target), 1750, 25, 925, 100, true, true)
            if RPred.HitChance == 1 then
				CastSkillShot(_Q,RPred.PredPos)	
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
		 
print("BlitzcrankVer1.0 loaded")
