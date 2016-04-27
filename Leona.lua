if GetObjectName(GetMyHero()) ~= "Leona" then return end

require("OpenPredict")
local LeonaMenu = Menu("Leona", "Leona")
LeonaMenu:SubMenu("Combo", "Combo")
LeonaMenu.Combo:Boolean("Q", "Use Q", true)
LeonaMenu.Combo:Boolean("E", "Use E", true)
LeonaMenu.Combo:Boolean("W", "Use W", true)
LeonaMenu.Combo:Boolean("R", "Use R", true)

local LeonaE = {delay = 0, range = 875, width = 85, speed = 2000} 
local LeonaR = {delay = 0.7, range = 1200, radius = 315, speed = math.huge}
OnTick(function (myHero)
	local target = GetCurrentTarget()	
	if IOW:Mode() == "Combo" then
		if LeonaMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 300) then	             
			CastSpell(_W)
		end
		if LeonaMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 875) then
		local EPred = GetPrediction(target,LeonaE)
			if EPred.hitChance > 0.2 then
				CastSkillShot(_E,EPred.castPos)
			end
		end
		if LeonaMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 155) then	             
			CastSpell(_Q)
		end
		if LeonaMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 1200) then
		local RPred = GetCircularAOEPrediction(target,LeonaR)
			if RPred.hitChance > 0.2 then
				CastSkillShot(_R,RPred.castPos)
			end
		end
	end
end)

print ("Leona Loaded")
