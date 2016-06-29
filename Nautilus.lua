if GetObjectName(GetMyHero()) ~= "Nautilus" then return end

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
	if IOW:Mode() == "Combo" then
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
