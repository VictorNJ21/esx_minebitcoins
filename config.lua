Config                      = {}

-- Locations
Config.MineLoc              = vector3(1272.84, -1712.02, 53.87) 
Config.SellLoc              = vector3(1075.99, -1978.62, 30.57) 

-- Misc
Config.Locale               = 'en'  -- Language

Config.EnableBlips          = true  -- If set to true, both mine and sell locations are on the map

Config.DrawDistance         = 4     -- How far away can you see the markers?

Config.MineDuration         = 2000  -- Recieve 1 bitcoin every 2 secs, 2000ms = 2 secs.
Config.SellDuration         = 5000  -- Put out for sale duration, default is 20 secs. 20000 = 20 secs.

Config.GiveDirtMoney        = true  -- True = recive dirty money, false = recieve normal money.
Config.SellReward           = 500   -- How much 1 individual bitcoin sells for. SellReward * BitcoinAmount

Config.HackTime             = 60    -- How Much time you have to hack.
Config.NeedRaspberry        = true  -- If set to true, you'll need a raspberry to be able to hack.
Config.RemoveRaspberry      = false -- Remove raspberry from inventory when hack is started?

Config.NotifyCopsIfFailHack = true  -- Shall cops be notified if someone fails the hack?
Config.NotfityCopsWhenSell  = true  -- Shall cops be notified if someone sells bitcoins?
Config.UseGcphone           = false -- Use Gcphone to notify cops? False = esx notify. Requires one of above to be set to true.


