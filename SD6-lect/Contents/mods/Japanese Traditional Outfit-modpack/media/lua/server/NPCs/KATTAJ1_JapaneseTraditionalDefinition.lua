require 'NPCs/ZombiesZoneDefinition'



--////////////////////////////////////////////////////// Japanese Traditional Outfit //////////////////////////////////////////////////////
local KATTAJ1_JapaneseTraditional_SpawnChance_Default = SandboxVars.KATTAJ1_Japanese.JapaneseTraditionalDefault
table.insert(ZombiesZoneDefinition.Default,{name = "KATTAJ1_Japanese_Traditional", chance= KATTAJ1_JapaneseTraditional_SpawnChance_Default});

local KATTAJ1_JapaneseTraditionalDyed_SpawnChance_Default = SandboxVars.KATTAJ1_Japanese.JapaneseTraditionalDyedDefault
table.insert(ZombiesZoneDefinition.Default,{name = "Traditional_Japanese_Outfit_Dyed", chance= KATTAJ1_JapaneseTraditionalDyed_SpawnChance_Default});
