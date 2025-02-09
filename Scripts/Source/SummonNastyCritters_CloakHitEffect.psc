Scriptname SummonNastyCritters_CloakHitEffect extends activemagiceffect  

SummonNastyCritters_CreatureList Property CreatureList Auto
Faction property SummonNastyCrittersFaction Auto

Event OnEffectStart(Actor witness, Actor creature)
    ; witness not a critter
    if witness.IsInFaction(SummonNastyCrittersFaction)
        return 
    endif 

    ; Debug.MessageBox("witness:"+witness.GetLeveledActorBase().getName()+" "+witness.getType()+" creature:"+creature.GetLeveledActorBase().getName()+" "+creature.getType())
    Actor victum = CreatureList.GetVictumFromCreature(creature)
    ; Debug.MessageBox(victum+" victum:"+victum.GetLeveledActorBase().getName()+" "+victum.getType())
    ; Debug.Notification("CloakEffect witness:"+witness+ " victum:"+victum)
    if victum != None && creature.getRelationshipRank(witness) > -4
        int rel = victum.getRelationshipRank(victum)
        if rel > -1
            ;Debug.Notification("NastyCloak "+victum.GetLeveledActorBase().getName()+" "+witness.GetLeveledActorBase().getName()+" "+rel)
            witness.StartCombat(creature)
            witness.SetRelationshipRank(creature, -4)
        endif 
    endif 
endEvent 
