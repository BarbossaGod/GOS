if GetObjectName(GetMyHero()) ~= "Blitzcrank" then return end

require("Inspired")

local BlitzcrankMenu = Menu("Blitzcrank", "Blitzcrank")
BlitzcrankMenu:SubMenu("Combo", "Combo")
BlitzcrankMenu.Combo:Boolean("Q", "Use Q", true)
BlitzcrankMenu.Combo:Boolean("W", "Use W", true)
BlitzcrankMenu.Combo:Boolean("E", "Use E", true)
BlitzcrankMenu.Combo:Boolean("R", "Use R", true)
BlitzcrankMenu.Combo:Boolean("KSQ", "Killsteal with Q", true)
BlitzcrankMenu.Combo:Boolean("KSR", "Killsteal with R", true)


OnTick(function (myHero)

	    local target = GetCurrentTarget()
		
		if IOW:Mode() == "Combo" then
		
		        if BlitzcrankMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 925) then
				
				            local RPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target), 1750, 25, 925, 231.25, false, true)
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
				
end) 
print("BlitzcrankVer1.0 loaded")
