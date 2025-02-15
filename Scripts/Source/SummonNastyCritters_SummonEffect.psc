Scriptname SummonNastyCritters_SummonEffect extends activemagiceffect  

SummonNastyCritters_CreatureList Property CreatureList Auto
Spell Property SummonNastyCritters_Cloak Auto
Faction Property SummonNastyCrittersFaction Auto
SexLabFramework Property SexLab Auto
Faction property SexLabAnimatingFaction auto hidden


Event OnEffectStart(Actor victum, Actor caster)
    ; ActorBase creatureBase = (game.GetForm(0x00023A92) as ActorBase) ; dog
    ; ActorBase creatureBase = (game.GetFormFromFile(0x01B657,"Dragonborn.esm") as ActorBase) ; ash
    ; ActorBase creatureBase = (game.GetFormFromFile(0x00023ABB,"Skyrim.esm") as ActorBase) ; troll

    ; Is a nasty critter
    Actor creature = None 
    if victum.IsInFaction(SummonNastyCrittersFaction) 
        creature = victum
    ; Already has a partner
    else
        creature = CreatureList.GetVictumFromCreature(victum)
    endif 

    if creature != None
        DeBug.Notification("Bansihing:"+creature.GetLeveledActorBase().GetName())
        float cost = self.GetBaseObject().GetBaseCost()
        caster.ModActorValue("magicka", cost)
        CreatureList.BanishCreature(creature)
        return 
    endif
    caster.ModActorValue("magicka", 95)

    ;Actor creature = victum.PlaceActorAtMe(game.GetForm(0x00023A92) as ActorBase) ; dog
    if victum != caster
        if victum.IsInFaction(SexLabAnimatingFaction) 
            Debug.Notification("They seem busy.")
            return
        endif
        CreatureList.SummonCreatureFromVictum(victum)
    else
        ActorBase base = CreatureList.SummonCreatureAll()
        creature = caster.PlaceActorAtMe(base)
        creature.AddToFaction(SummonNastyCrittersFaction)
    endif

    ; Set health to caster's mana
    ; float health = creature.GetActorValueMax("health")
    ; float mana_current = caster.GetActorValue("magicka")
    ; float mana = 0.9*mana_current
    ; if mana < health
        ; health = mana 
    ; endif 
    ; creature.SetActorValue("health",health)
    ;caster.SetActorValue("magicka",mana_current-health)
EndEvent