Scriptname SummonNastyCritters_ControlEffect extends activemagiceffect  

SummonNastyCritters_CreatureList Property CreatureList Auto
SexLabFramework Property SexLab Auto

import uiextensions

String reset_list = "Reload Critters List"
String recheck_critters = "Check SexLab-able Critters"

String creaturesum_esp = "CreatureSummoner.esp"
Int actorBaseType = 43

Event OnEffectStart(Actor target, Actor caster)
    uilistmenu listMenu = uiextensions.GetMenu("UIListMenu") AS uilistmenu
    listMenu.AddEntryItem(reset_list)
    listMenu.AddEntryItem(recheck_critters)
    listMenu.OpenMenu()
    String result = listmenu.GetResultString()
    if result == reset_list
        CreatureList.Rebuild(verbose=true) 
    endif
    if result == recheck_critters 
        Check(caster) 
    endif 
EndEvent

Function Check(Actor caster)
    if !SexLab.AllowCreatures
        Debug.MessageBox("SexLab does not allow creature animations.  Change in MCM.")
        ;return 
    endif

    Form[] forms = PO3_SKSEFunctions.GetAllFormsInMod(asModName = creaturesum_esp, aiFormtype = actorBaseType)
    int count = forms.length
    int i = 0
    int creatures = JArray.object()

    int num_sexable = 0
    int num_unsexable = 0
    JValue.retain(creatures,"SummonNastyCritters")
    ; check if the animal is a valid actor
    while i < count; && JArray.count(creatures) < 10
        ActorBase base = forms[i] as ActorBase
        if base != None
            Debug.Trace("Nasty Check "+i+" "+base.getName())
            Actor act = caster.PlaceActorAtMe(base)
            int creature = JMAP.object()   
            JMap.setStr(creature,"name",base.GetName())
            JMap.setStr(creature,"plugin",creaturesum_esp)
            JMap.setStr(creature,"id",base.GetFormID())

            Utility.wait(1)
            if SexLab.IsValidActor(act)
                num_sexable += 1 
                JMap.setInt(creature,"sexable",1)
            else
                num_unsexable += 1 
                JMap.setInt(creature,"sexable",0)
            endif 
            JArray.addObj(creatures, creature)
            act.Disable()
            act.Delete() 
        endif 
        i += 1
    endwhile
    Debug.MessageBox("num forms:"+forms.length+" creatures:"+JArray.count(creatures)+" sexable:"+num_sexable+" unsexable:"+num_unsexable)

    JValue.writeToFile(creatures, "Data/SummonNastyCritters/Data/"+creaturesum_esp+".json")
EndFunction