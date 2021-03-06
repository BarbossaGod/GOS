local ver = "5.4"

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat("New version found! " .. data)
        PrintChat("Downloading update, please wait...")
        DownloadFileAsync("https://raw.githubusercontent.com/BarbossaGod/GOS/master/Better%20SkinChanger.lua", SCRIPT_PATH .. "Better SkinChanger.lua", function() PrintChat("Update Complete, please 2x F6!") return end)
    else
        PrintChat("No updates found!")
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/BarbossaGod/GOS/master/Versions/Better%20Skinchanger.version", AutoUpdate)

-- Ordering Chromas ATM of Jan 27
skinMeta       = 
{
   	["Aatrox"] = { "Classic", "Justicar Aatrox", "Mecha Aatrox", "Sea Hunter Aatrox" }, 
	["Ahri"] = { "Classic", "Dynasty Ahri", "Midnight Ahri", "Foxfire Ahri", "Popstar Ahri", "Challenger Ahri", "Academy Ahri", "Arcade Ahri", "Chroma 1", "Chroma 2", "Chroma 3", "Chroma 4", "Chroma 5", "Chroma 6" }, 
	["Akali"] = { "Classic", "Stinger Akali", "Crimson Akali", "All-star Akali", "Nurse Akali", "Blood Moon Akali", "Silverfang Akali", "Headhunter Akali", "Sashimi Akali" }, 
	["Alistar"] = { "Classic", "Black Alistar", "Golden Alistar", "Matador Alistar", "Longhorn Alistar", "Unchained Alistar", "Infernal Alistar", "Sweeper Alistar", "Marauder Alistar", "SKT T1 Alistar" }, 
	["Amumu"] = { "Classic", "Pharaoh Amumu", "Vancouver Amumu", "Emumu", "Re-Gifted Amumu", "Almost-Prom King Amumu", "Little Knight Amumu", "Sad Robot Amumu", "Surprise Party Amumu", "Sewn Chaos Amumu" }, 
	["Anivia"] = { "Classic", "Team Spirit Anivia", "Bird of Prey Anivia", "Noxus Hunter Anivia", "Hextech Anivia", "Blackfrost Anivia", "Prehistoric Anivia" }, 
	["Annie"] = { "Classic", "Goth Annie", "Red Riding Annie", "Annie in Wonderland", "Prom Queen Annie", "Frostfire Annie", "Reverse Annie", "FrankenTibbers Annie", "Panda Annie", "Sweetheart Annie", "Hextech Annie" }, 
	["Ashe"] = { "Classic", "Freljord Ashe", "Sherwood Forest Ashe", "Woad Ashe", "Queen Ashe", "Amethyst Ashe", "Heartseeker Ashe", "Marauder Ashe", "PROJECT: Ashe" }, 
	["AurelionSol"] = { "Classic", "Ashen Lord Aurelion Sol" }, 
	["Azir"] = { "Classic", "Galactic Azir", "Gravelord Azir", "SKT T1 Azir", "Warring Kingdoms Azir" }, 
	["Bard"] = { "Classic", "Elderwood Bard", "Snow Day Bard", "Bloom Marigold Chroma", "Bloom Ivy Chroma", "Bloom Sage Chroma", "Bard Bard" }, 
	["Blitzcrank"] = { "Classic", "Rusty Blitzcrank", "Goalkeeper Blitzcrank", "Boom Boom Blitzcrank", "Piltover Customs Blitzcrank", "Definitely Not Blitzcrank", "iBlitzcrank", "Riot Blitzcrank",  "Molten Chroma", "Cobalt Chroma", "Gunmetal Chroma", "Battle Boss Blitzcrank", "Sewn Chaos Blitzcrank" }, 
	["Brand"] = { "Classic", "Apocalyptic Brand", "Vandal Brand", "Cryocore Brand", "Zombie Brand", "Spirit Fire Brand" }, 
	["Braum"] = { "Classic", "Dragonslayer Braum", "El Tigre Braum", "Braum Lionheart", "Santa Braum" }, 
	["Caitlyn"] = { "Classic", "Resistance", "Sheriff", "Safari", "Arctic Warfare", "Officer", "Headhunter", "Pink Chroma", "Green Chroma", "Blue Chroma", "Lunar Wraith" }, 
	["Camille"] = { "Classic", "Program Camille" }, 
	["Cassiopeia"] = { "Classic", "Desperada", "Siren", "Mythic", "Day Chroma", "Dusk Chroma", "Night Chroma", "Jade Fang" }, 
	["Chogath"] = { "Classic", "Nightmare Cho'Gath", "Gentleman Cho'Gath", "Loch Ness Cho'Gath", "Jurassic Cho'Gath", "Battlecast Prime Cho'Gath", "Prehistoric Cho'Gath" }, 
	["Corki"] = { "Classic", "UFO Corki", "Ice Toboggan Corki", "Red Baron Corki", "Hot Rod Corki", "Urfrider Corki", "Dragonwing Corki", "Fnatic Corki", "Arcade Corki" }, 
	["Darius"] = { "Classic", "Lord", "BioForge", "Woad King", "DunkMaster", "Black Iron Chroma", "Bronze Chroma", "Copper Chroma", "Academy", "Amethyst", "Aquamarine", "Catseye", "Citrine", "Emerald" }, 
	["Diana"] = { "Classic", "Dark Valkyrie Diana", "Lunar Goddess Diana", "Infernal Diana", "Amethyst Chroma", "Aquamarine Chroma", "Obsidian Chroma", "Pearl Chroma", "Ruby Chroma", "Peridot Chroma", "Blood Moon Diana" }, 
	["Draven"] = { "Classic", "Soul Reaver Draven", "Gladiator Draven", "Primetime Draven", "Pool Party Draven", "Beast Hunter Draven", "Draven Draven" }, 
	["DrMundo"] = { "Classic", "Toxic Dr. Mundo", "Mr. Mundoverse", "Corporate Mundo", "Mundo Mundo", "Executioner Mundo", "Rageborn Mundo", "TPA Mundo", "Pool Party Mundo", "El Macho Mundo" }, 
	["Ekko"] = { "Classic", "Sandstorm Ekko", "Academy Ekko", "PROJECT: Ekko" }, 
	["Elise"] = { "Classic", "Death Blossom Elise", "Victorious Elise", "Blood Moon Elise", "SKT T1 Elise" }, 
	["Evelynn"] = { "Classic", "Shadow Evelynn", "Masquerade Evelynn", "Tango Evelynn", "Safecracker Evelynn" }, 
	["Ezreal"] = { "Classic", "Nottingham Ezreal", "Striker Ezreal", "Frosted Ezreal", "Explorer Ezreal", "Pulsefire Ezreal", "TPA Ezreal", "Debonair Ezreal", "Ace of Spades Ezreal", "Arcade Ezreal", "Amethyst Chroma", "Meteorite Chroma", "Obsidian Chroma", "Pearl Chroma", "Rose Quartz Chroma", "Ruby Chroma", "Sandstone Chroma", "Striped Chroma" }, 
	["FiddleSticks"] = { "Classic", "Spectral Fiddlesticks", "Union Jack Fiddlesticks", "Bandito Fiddlesticks", "Pumpkinhead Fiddlesticks", "Fiddle Me Timbers", "Surprise Party Fiddlesticks", "Dark Candy Fiddlesticks", "Risen Fiddlesticks" }, 
	["Fiora"] = { "Classic", "Royal Guard Fiora", "Nightraven Fiora", "Headmistress Fiora", "PROJECT: Fiora", "Pool Party Fiora", "Amethyst Chroma", "Catseye Chroma", "Jasper Chroma", "Pearl Chroma", "Rose Quartz Chroma", "Ruby Chroma", "Sandstone Chroma", "Sapphire Chroma" }, 
	["Fizz"] = { "Classic", "Atlantean Fizz", "Tundra Fizz", "Fisherman Fizz", "Void Fizz", "Orange Chroma", "Black Chroma", "Red Chroma", "Cottontail Fizz", "Super Galaxy Fizz" }, 
	["Galio"] = { "Classic", "Enchanted Galio", "Hextech Galio", "Commando Galio", "Gatekeeper Galio", "Debonair Galio" }, 
	["Gangplank"] = { "Classic", "Spooky Gangplank", "Minuteman Gangplank", "Sailor Gangplank", "Toy Soldier Gangplank", "Special Forces Gangplank", "Sultan Gangplank", "Captain Gangplank", "Dreadnova Gangplank" }, 
	["Garen"] = { "Classic", "Sanguine Garen", "Desert Trooper Garen", "Commando Garen", "Dreadknight Garen", "Rugged Garen", "Steel Legion Garen", "Garnet Chroma", "Plum Chroma", "Ivory Chroma", "Rogue Admiral Garen", "Warring Kingdoms Garen" }, 
	["Gnar"] = { "Classic", "Dino Gnar", "Gentleman Gnar", "Snow Day Gnar", "El León Gnar" }, 
	["Gragas"] = { "Classic", "Scuba Gragas", "Hillbilly Gragas", "Santa Gragas", "Gragas, Esq.", "Vandal Gragas", "Oktoberfest Gragas", "Superfan Gragas", "Fnatic Gragas", "Gragas Caskbreaker" }, 
	["Graves"] = { "Classic", "Hired Gun Graves", "Jailbreak Graves", "Mafia Graves", "Riot Graves", "Pool Party Graves", "Cutthroat Graves", "Snow Day Graves" }, 
	["Hecarim"] = { "Classic", "Blood Knight Hecarim", "Reaper Hecarim", "Headless Hecarim", "Arcade Hecarim", "Elderwood Hecarim", "Worldbreaker Hecarim" }, 
	["Heimerdinger"] = { "Classic", "Alien Invader Heimerdinger", "Blast Zone Heimerdinger", "Piltover Customs Heimerdinger", "Snowmerdinger", "Hazmat Heimerdinger" }, 
	["Illaoi"] = { "Classic", "Void Bringer Illaoi" }, 
	["Irelia"] = { "Classic", "Nightblade Irelia", "Aviator Irelia", "Infiltrator Irelia", "Frostblade Irelia", "Order of the Lotus Irelia" }, 
	["Ivern"] = { "Classic", "Candy King Ivern" }, 
	["Janna"] = { "Classic", "Tempest Janna", "Hextech Janna", "Frost Queen Janna", "Victorious Janna", "Forecast Janna", "Fnatic Janna", "Star Guardian Janna" }, 
	["JarvanIV"] = { "Classic", "Commando Jarvan IV", "Dragonslayer Jarvan IV", "Darkforge Jarvan IV", "Victorious Jarvan IV", "Warring Kingdoms Jarvan IV", "Fnatic Jarvan IV" }, 
	["Jax"] = { "Classic", "The Mighty Jax", "Vandal Jax", "Angler Jax", "PAX Jax", "Jaximus", "Temple Jax", "Nemesis Jax", "SKT T1 Jax", "Cream Chroma", "Amber Chroma", "Brick Chroma", "Warden Jax" }, 
	["Jayce"] = { "Classic", "Full Metal Jayce", "Debonair Jayce", "Forsaken Jayce", "Jayce Brighthammer" }, 
	["Jhin"] = { "Classic", "High Noon Jhin", "Blood Moon Jhin" }, 
	["Jinx"] = { "Classic", "Mafia Jinx", "Firecracker Jinx", "Slayer Jinx", "Star Guardian Jinx" }, 
	["Kalista"] = { "Classic", "Blood Moon Kalista", "Championship Kalista", "SKT T1 Kalista" }, 
	["Karma"] = { "Classic", "Sun Goddess Karma", "Sakura Karma", "Traditional Karma", "Order of the Lotus Karma", "Warden Karma", "Winter Wonder Karma" }, 
	["Karthus"] = { "Classic", "Phantom Karthus", "Statue of Karthus", "Grim Reaper Karthus", "Pentakill Karthus", "Burn Chroma", "Blight Chroma", "Frostbite Chroma", "Fnatic Karthus", "Karthus Lightsbane" }, 
	["Kassadin"] = { "Classic", "Festival Kassadin", "Deep One Kassadin", "Pre-Void Kassadin", "Harbinger Kassadin", "Cosmic Reaver Kassadin" }, 
	["Katarina"] = { "Classic", "Mercenary Katarina", "Red Card Katarina", "Bilgewater Katarina", "Kitty Cat Katarina", "High Command Katarina", "Sandstorm Katarina", "Slay Belle Katarina", "Warring Kingdoms Katarina", "PROJECT: Katarina" }, 
	["Kayle"] = { "Classic", "Silver Kayle", "Viridian Kayle", "Unmasked Kayle", "Battleborn Kayle", "Judgment Kayle", "Aether Wing Kayle", "Riot Kayle", "Iron Inquisitor Kayle" }, 
	["Kennen"] = { "Classic", "Deadly Kennen", "Swamp Master Kennen", "Karate Kennen", "Kennen M.D.", "Arctic Ops Kennen", "Blood Moon Kennen" }, 
	["Khazix"] = { "Classic", "Mecha Kha'Zix", "Guardian of the Sands Kha'Zix", "Death Blossom Kha'Zix" }, 
	["Kindred"] = { "Classic", "Shadowfire Kindred", "Super Galaxy Kindred" }, 
	["Kled"] = { "Classic", "Sir Kled" }, 
	["KogMaw"] = { "Classic", "Caterpillar Kog'Maw", "Sonoran Kog'Maw", "Monarch Kog'Maw", "Reindeer Kog'Maw", "Lion Dance Kog'Maw", "Deep Sea Kog'Maw", "Jurassic Kog'Maw", "Battlecast Kog'Maw" }, 
	["Leblanc"] = { "Classic", "Wicked LeBlanc", "Prestigious LeBlanc", "Mistletoe LeBlanc", "Ravenborn LeBlanc", "Elderwood LeBlanc", "Chroma 1", "Chroma 2", "Chroma 3", "Chroma 4", "Chroma 5", "Chroma 6" }, 
	["LeeSin"] = { "Classic", "Traditional Lee Sin", "Acolyte Lee Sin", "Dragon Fist Lee Sin", "Muay Thai Lee Sin", "Pool Party Lee Sin", "SKT T1 Lee Sin", "Black Chroma", "Blue Chroma", "Yellow Chroma", "Knockout Lee Sin" }, 
	["Leona"] = { "Classic", "Valkyrie Leona", "Defender Leona", "Iron Solari Leona", "Pool Party Leona", "Pink Chroma", "Lemon Chroma", "Azure Chroma", "PROJECT: Leona", "Barbecue Leona" }, 
	["Lissandra"] = { "Classic", "Bloodstone Lissandra", "Blade Queen Lissandra", "Program Lissandra" }, 
	["Lucian"] = { "Classic", "Hired Gun Lucian", "Striker Lucian", "Yellow Chroma", "Red Chroma", "Blue Chroma", "PROJECT: Lucian", "Heartseeker Lucian" }, 
	["Lulu"] = { "Classic", "Bittersweet Lulu", "Wicked Lulu", "Dragon Trainer Lulu", "Winter Wonder Lulu", "Pool Party Lulu", "Star Guardian Lulu" }, 
	["Lux"] = { "Classic", "Sorceress Lux", "Spellthief Lux", "Commando Lux", "Imperial Lux", "Steel Legion Lux", "Star Guardian Lux", "Elementalist Lux" }, 
	["Malphite"] = { "Classic", "Shamrock Malphite", "Coral Reef Malphite", "Marble Malphite", "Obsidian Malphite", "Glacial Malphite", "Mecha Malphite", "Ironside Malphite", "Catseye Chroma", "Citrine Chroma", "Emerald Chroma", "Granite Chroma", "Obsidian Chroma", "Pearl Chroma", "Sandstone Chroma", "Sapphire Chroma" }, 
	["Malzahar"] = { "Classic", "Vizier Malzahar", "Shadow Prince Malzahar", "Djinn Malzahar", "Overlord Malzahar", "Snow Day Malzahar" }, 
	["Maokai"] = { "Classic", "Charred Maokai", "Totemic Maokai", "Festive Maokai", "Haunted Maokai", "Goalkeeper Maokai", "Meowkai", "Victorious Maokai" }, 
	["MasterYi"] = { "Classic", "Assassin Master Yi", "Chosen Master Yi", "Ionia Master Yi", "Samurai Yi", "Headhunter Master Yi", "Gold Chroma", "Aqua Chroma", "Crimson Chroma", "PROJECT: Yi" }, 
	["MissFortune"] = { "Classic", "Cowgirl Miss Fortune", "Waterloo Miss Fortune", "Secret Agent Miss Fortune", "Candy Cane Miss Fortune", "Road Warrior Miss Fortune", "Mafia Miss Fortune", "Arcade Miss Fortune", "Captain Fortune", "Pool Party Miss Fortune", "Amethyst Chroma", "Aquamarine Chroma", "Citrine Chroma", "Peridot Chroma", "Ruby Chroma" }, 
	["MonkeyKing"] = { "Classic", "Volcanic Wukong", "General Wukong", "Jade Dragon Wukong", "Underworld Wukong", "Radiant Wukong" }, 
	["Mordekaiser"] = { "Classic", "Dragon Knight Mordekaiser", "Infernal Mordekaiser", "Pentakill Mordekaiser", "Lord Mordekaiser", "King of Clubs Mordekaiser" }, 
	["Morgana"] = { "Classic", "Exiled Morgana", "Sinful Succulence Morgana", "Blade Mistress Morgana", "Blackthorn Morgana", "Ghost Bride Morgana", "Victorious Morgana", "Toxic Chroma", "Pale Chroma", "Ebony Chroma", "Lunar Wraith Morgana", "Bewitching Morgana" }, 
	["Nami"] = { "Classic", "Koi Nami", "River Spirit Nami", "Sunbeam Chroma", "Smoke Chroma", "Twilight Chroma", "Urf the Nami-tee", "Deep Sea Nami" }, 
	["Nasus"] = { "Classic", "Galactic Nasus", "Pharaoh Nasus", "Dreadknight Nasus", "Riot K-9 Nasus", "Infernal Nasus", "Burn Chroma", "Blight Chroma", "Frostbite Chroma", "Archduke Nasus", "Worldbreaker Nasus" }, 
	["Nautilus"] = { "Classic", "Abyssal Nautilus", "Subterranean Nautilus", "AstroNautilus", "Warden Nautilus", "Worldbreaker Nautilus" }, 
	["Nidalee"] = { "Classic", "Snow Bunny Nidalee", "Leopard Nidalee", "French Maid Nidalee", "Pharaoh Nidalee", "Bewitching Nidalee", "Headhunter Nidalee", "Warring Kingdoms Nidalee", "Challenger Nidalee" }, 
	["Nocturne"] = { "Classic", "Frozen Terror Nocturne", "Void Nocturne", "Ravager Nocturne", "Haunting Nocturne", "Eternum Nocturne", "Cursed Revenant Nocturne" }, 
	["Nunu"] = { "Classic", "Sasquatch Nunu", "Workshop Nunu", "Grungy Nunu", "Nunu Bot", "Demolisher Nunu", "TPA Nunu", "Zombie Nunu" }, 
	["Olaf"] = { "Classic", "Forsaken Olaf", "Glacial Olaf", "Brolaf", "Pentakill Olaf", "Marauder Olaf", "Butcher Olaf" }, 
	["Orianna"] = { "Classic", "Gothic Orianna", "Sewn Chaos Orianna", "Bladecraft Orianna", "TPA Orianna", "Winter Wonder Orianna", "Heartseeker Orianna" }, 
	["Pantheon"] = { "Classic", "Myrmidon Pantheon", "Ruthless Pantheon", "Perseus Pantheon", "Full Metal Pantheon", "Glaive Warrior Pantheon", "Dragonslayer Pantheon", "Slayer Pantheon", "Baker Pantheon" }, 
	["Poppy"] = { "Classic", "Noxus Poppy", "Lollipoppy", "Blacksmith Poppy", "Ragdoll Poppy", "Battle Regalia Poppy", "Scarlet Hammer Poppy", "Star Guardian Poppy" }, 
	["Quinn"] = { "Classic", "Phoenix Quinn", "Woad Scout Quinn", "Corsair Quinn", "Heartseeker Quinn" }, 
	["Rammus"] = { "Classic", "King Rammus", "Chrome Rammus", "Molten Rammus", "Freljord Rammus", "Ninja Rammus", "Full Metal Rammus", "Guardian of the Sands Rammus" }, 
	["RekSai"] = { "Classic", "Eternum Rek'Sai", "Pool Party Rek'Sai" }, 
	["Renekton"] = { "Classic", "Galactic Renekton", "Outback Renekton", "Bloodfury Renekton", "Rune Wars Renekton", "Scorched Earth Renekton", "Pool Party Renekton", "Prehistoric Renekton", "SKT T1 Renekton" }, 
	["Rengar"] = { "Classic", "Headhunter Rengar", "Night Hunter Rengar", "SSW Rengar" }, 
	["Riven"] = { "Classic", "Redeemed Riven", "Crimson Elite Riven", "Battle Bunny Riven", "Championship Riven", "Dragonblade Riven", "Arcade Riven", "Championship Riven 2016", "Amethyst", "Astral", "Catseye", "Emerald", "Granite", "Rose Quartz", "Ruby", "Sapphire" }, 
	["Rumble"] = { "Classic", "Rumble in the Jungle", "Bilgerat Rumble", "Super Galaxy Rumble" }, 
	["Ryze"] = { "Classic", "Young Ryze", "Tribal Ryze", "Uncle Ryze", "Triumphant Ryze", "Professor Ryze", "Zombie Ryze", "Dark Crystal Ryze", "Pirate Ryze", "Ryze Whitebeard", "SKT T1 Ryze" }, 
	["Sejuani"] = { "Classic", "Sabretusk Sejuani", "Darkrider Sejuani", "Traditional Sejuani", "Bear Cavalry Sejuani", "Poro Rider Sejuani", "Beast Hunter Sejuani", "Sejuani Dawnchaser" }, 
	["Shaco"] = { "Classic", "Mad Hatter Shaco", "Royal Shaco", "Nutcracko", "Workshop Shaco", "Asylum Shaco", "Masked Shaco", "Wild Card Shaco" }, 
	["Shen"] = { "Classic", "Frozen Shen", "Yellow Jacket Shen", "Surgeon Shen", "Blood Moon Shen", "Warlord Shen", "TPA Shen" }, 
	["Shyvana"] = { "Classic", "Ironscale Shyvana", "Boneclaw Shyvana", "Darkflame Shyvana", "Ice Drake Shyvana", "Championship Shyvana", "Super Galaxy Shyvana" }, 
	["Singed"] = { "Classic", "Riot Squad Singed", "Hextech Singed", "Surfer Singed", "Mad Scientist Singed", "Augmented Singed", "Snow Day Singed", "SSW Singed", "Black Scourge Singed" }, 
	["Sion"] = { "Classic", "Hextech Sion", "Barbarian Sion", "Lumberjack Sion", "Warmonger Sion", "Mecha Zero Sion" }, 
	["Sivir"] = { "Classic", "Warrior Princess Sivir", "Spectacular Sivir", "Huntress Sivir", "Bandit Sivir", "PAX Sivir", "Snowstorm Sivir", "Warden Sivir", "Victorious Sivir" }, 
	["Skarner"] = { "Classic", "Sandscourge Skarner", "Earthrune Skarner", "Battlecast Alpha Skarner", "Guardian of the Sands Skarner" }, 
	["Sona"] = { "Classic", "Muse Sona", "Pentakill Sona", "Silent Night Sona", "Guqin Sona", "Arcade Sona", "DJ Sona", "Sweetheart Sona" }, 
	["Soraka"] = { "Classic", "Dryad Soraka", "Divine Soraka", "Celestine Soraka", "Reaper Soraka", "Order of the Banana Soraka", "Program Soraka" }, 
	["Swain"] = { "Classic", "Northern Front Swain", "Bilgewater Swain", "Tyrant Swain" }, 
	["Syndra"] = { "Classic", "Justicar Syndra", "Atlantean Syndra", "Queen of Diamonds Syndra", "Snow Day Syndra" }, 
	["TahmKench"] = { "Classic", "Master Chef Tahm Kench", "Urf Kench" }, 
	["Taliyah"] = { "Classic", "Freljord Taliyah" }, 
	["Talon"] = { "Classic", "Renegade Talon", "Crimson Elite Talon", "Dragonblade Talon", "SSW Talon", "Blood Moon Talon" }, 
	["Taric"] = { "Classic", "Emerald Taric", "Armor of the Fifth Age Taric", "Bloodstone Taric", "Pool Party Taric" }, 
	["Teemo"] = { "Classic", "Happy Elf Teemo", "Recon Teemo", "Badger Teemo", "Astronaut Teemo", "Cottontail Teemo", "Super Teemo", "Panda Teemo", "Omega Squad Teemo", "Cottontail Chroma 1", "Cottontail Chroma 2", "Cottontail Chroma 3", "Cottontail Chroma 4", "Cottontail Chroma 5", "Little Devil Teemo" }, 
	["Thresh"] = { "Classic", "Deep Terror Thresh", "Championship Thresh", "Blood Moon Thresh", "SSW Thresh", "Dark Star Thresh" }, 
	["Tristana"] = { "Classic", "Riot Girl Tristana", "Earnest Elf Tristana", "Firefighter Tristana", "Guerilla Tristana", "Buccaneer Tristana", "Rocket Girl Tristana", "Navy Chroma", "Purple Chroma", "Orange Chroma", "Dragon Trainer Tristana", "Bewitching Tristana" }, 
	["Trundle"] = { "Classic", "Lil' Slugger Trundle", "Junkyard Trundle", "Traditional Trundle", "Constable Trundle", "Worldbreaker Trundle" }, 
	["Tryndamere"] = { "Classic", "Highland Tryndamere", "King Tryndamere", "Viking Tryndamere", "Demonblade Tryndamere", "Sultan Tryndamere", "Warring Kingdoms Tryndamere", "Nightmare Tryndamere", "Beast Hunter Tryndamere" }, 
	["TwistedFate"] = { "Classic", "PAX Twisted Fate", "Jack of Hearts Twisted Fate", "The Magnificent Twisted Fate", "Tango Twisted Fate", "High Noon Twisted Fate", "Musketeer Twisted Fate", "Underworld Twisted Fate", "Red Card Twisted Fate", "Cutpurse Twisted Fate", "Blood Moon Twisted Fate" }, 
	["Twitch"] = { "Classic", "Kingpin Twitch", "Whistler Village Twitch", "Medieval Twitch", "Gangster Twitch", "Vandal Twitch", "Pickpocket Twitch", "SSW Twitch" }, 
	["Udyr"] = { "Classic", "Black Belt Udyr", "Primal Udyr", "Spirit Guard Udyr", "Definitely Not Udyr" }, 
	["Urgot"] = { "Classic", "Giant Enemy Crabgot", "Butcher Urgot", "Battlecast Urgot" }, 
	["Varus"] = { "Classic", "Blight Crystal Varus", "Arclight Varus", "Arctic Ops Varus", "Heartseeker Varus", "Varus Swiftbolt", "Dark Star Varus" }, 
	["Vayne"] = { "Classic", "Vindicator Vayne", "Aristocrat Vayne", "Dragonslayer Vayne", "Heartseeker Vayne", "SKT T1 Vayne", "Arclight Vayne", "DragonSlayer Green", "DragonSlayer Red", "DragonSlayer Blue",  "Soulstealer Vayne" }, 
	["Veigar"] = { "Classic", "White Mage Veigar", "Curling Veigar", "Veigar Greybeard", "Leprechaun Veigar", "Baron Von Veigar", "Superb Villain Veigar", "Bad Santa Veigar", "Final Boss Veigar" }, 
	["Velkoz"] = { "Classic", "Battlecast Vel'Koz", "Arclight Vel'Koz", "Definitely Not Vel'Koz" }, 
	["Vi"] = { "Classic", "Neon Strike Vi", "Officer Vi", "Debonair Vi", "Demon Vi", "Warring Kingdoms Vi" }, 
	["Viktor"] = { "Classic", "Full Machine Viktor", "Prototype Viktor", "Creator Viktor" }, 
	["Vladimir"] = { "Classic", "Count Vladimir", "Marquis Vladimir", "Nosferatu Vladimir", "Vandal Vladimir", "Blood Lord Vladimir", "Soulstealer Vladimir", "Academy Vladimir" }, 
	["Volibear"] = { "Classic", "Thunder Lord Volibear", "Northern Storm Volibear", "Runeguard Volibear", "Captain Volibear", "El Rayo Volibear" }, 
	["Warwick"] = { "Classic", "Grey Warwick", "Urf the Manatee", "Big Bad Warwick", "Tundra Hunter Warwick", "Feral Warwick", "Firefang Warwick", "Hyena Warwick", "Marauder Warwick" }, 
	["Xerath"] = { "Classic", "Runeborn Xerath", "Battlecast Xerath", "Scorched Earth Xerath", "Guardian of the Sands Xerath" }, 
	["XinZhao"] = { "Classic", "Commando Xin Zhao", "Imperial Xin Zhao", "Viscero Xin Zhao", "Winged Hussar Xin Zhao", "Warring Kingdoms Xin Zhao", "Secret Agent Xin Zhao","Amethyst", "Aquamarine Chroma", "Pearl Chroma", "Peridot Chroma", "Rose Quartz Chroma", "Ruby Chroma" }, 
	["Yasuo"] = { "Classic", "High Noon Yasuo", "PROJECT: Yasuo", "Blood Moon Yasuo", "Amethyst Chroma", "Emerald Chroma", "Jasper Chroma", "Obsidian Chroma", "Sapphire Chroma" }, 
	["Yorick"] = { "Classic", "Undertaker Yorick", "Pentakill Yorick" }, 
	["Zac"] = { "Classic", "Special Weapon Zac", "Orange Chroma", "Bubblegum Chroma", "Honey Chroma", "Pool Party Zac" }, 
	["Zed"] = { "Classic", "Shockblade Zed", "SKT T1 Zed", "PROJECT: Zed", "Amethyst Chroma", "Aquamarine Chroma", "Catseye Chroma", "Emerald Chroma", "Rose Quartz Chroma", "Ruby Chroma", "Championship Zed" }, 
	["Ziggs"] = { "Classic", "Mad Scientist Ziggs", "Major Ziggs", "Pool Party Ziggs", "Snow Day Ziggs", "Master Arcanist Ziggs" }, 
	["Zilean"] = { "Classic", "Old Saint Zilean", "Groovy Zilean", "Shurima Desert Zilean", "Time Machine Zilean", "Blood Moon Zilean" }, 
	["Zyra"] = { "Classic", "Wildfire Zyra", "Haunted Zyra", "SKT T1 Zyra" }
}
local Menu = MenuConfig(myHero.charName, myHero.charName.." Skin Changer")
Menu:SubMenu("misc", "Misc Settings")
Menu.misc:DropDown('skin', myHero.charName.. " Skins", 1, skinMeta[myHero.charName], 
	function(model)
        HeroSkinChanger(myHero, model - 1) print(skinMeta[myHero.charName][model] .." ".. myHero.charName .. " Loaded!") 
    end,
true)

print("Enjoy Your Free Skins ~Scortch/Zuffy")
