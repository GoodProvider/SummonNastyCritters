Scriptname SummonNastyCritters_Core extends ReferenceAlias  
Import JContainers

Actor property PlayerRef auto
Spell Property SummonNastyCritters_Summon Auto
Spell Property SummonNastyCritters_SummonNice Auto
SummonNastyCritters_CreatureList Property CreatureList Auto
SexLabFramework Property SexLab Auto

String creaturesAll_file = "data/creatures.json"
String creatures_file = "data/creatures_available.json"

Event OnInit() 
    if !PlayerRef.HasSpell(SummonNastyCritters_Summon)
        PlayerRef.AddSpell(SummonNastyCritters_Summon, true)
    endIf
    if !PlayerRef.HasSpell(SummonNastyCritters_SummonNice)
        PlayerRef.AddSpell(SummonNastyCritters_SummonNice, true)
    endIf
    CreatureList.rebuild()
EndEvent

Event OnPlayerLoadGame()
    CreatureList.rebuild()
EndEvent

int Function CreaturesList()
    return JValue.readFromFile(creaturesAll_file)
EndFunction
