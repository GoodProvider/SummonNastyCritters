Scriptname SummonNastyCritters_CreatureList extends Quest  
SexLabFramework Property SexLab Auto
Faction Property SummonNastyCrittersFaction Auto

ReferenceAlias[] Property critter_refs Auto

int DOMO1_ID = 0x00000D61
int DOM02Topic_ID = 0x000ED87C
String DOM_FILE = "DiaryOfMine.esm"

import JContainers
import uiextensions
import Utility
import DOM_API

int info
int creatures
int creatures_all
int creature_victum

String info_file = "Data/SummonNastyCritters/info.json"
String idName = "SummonNastyCritters"
String creatures_file = "Data/SummonNastyCritters/Data/creatures.json"

event OnInit()
    creature_victum = JMap.object() 
    JValue.retain(creature_victum,idName)
    Rebuild()
EndEvent

function Rebuild(Bool verbose=false)
    if Game.GetModByName("CreatureSummon.esp") == 255
        Debug.TaceandBox("Failed to find plugin CreatureSummon.esp. Nothing will happen.")
        return 
    endif

    if info != 0
        JValue.release(info)
        info = 0
    endif
    info = JValue.readFromFile(info_file)
    JValue.retain(info,idName)

    if creatures == 0
        creatures = JMap.object()
        JValue.retain(creatures,idName)
    endif 
    if creatures_all == 0
        creatures_all = JMap.object() 
        JValue.retain(creatures_all,idName)
    endif 

    ;int array = JValue.readFromFile("data/creatures.json")
    if verbose
        Debug.Notification("loading "+creatures_file)
    endif 
    int array = JValue.readFromFile(creatures_file)
    int count = JArray.count(array)

    creatures_all = JMap.object() 
    JValue.retain(creatures_all,idName)

    JMap.clear(creatures)
    JMap.clear(creatures_all)
    int num_creatures = 0
    int num_creatures_all = 0
    int i = 0
    while i < count
        int creature = JArray.getObj(array,i)
        int id_plugins = JMap.getObj(creature,"ids")
        int j = 0
        int id_count = JArray.count(id_plugins)

        int actors = JArray.object() 
        int actors_all = JArray.object() 
        String name = JMap.getStr(creature,"name")
        while j < id_count
            int obj = JArray.GetObj(id_plugins,j)
            int id = JMap.getInt(obj,"id")
            String plugin = JMap.getStr(obj,"plugin")
            ActorBase base = game.GetFormFromFile(id,plugin) as ActorBase
            if base != None 
                int sexable = JMap.getInt(obj,"sexable")
                if sexable != 0
                    ; Debug.MessageBox(name+"sexable:"+sexable)
                    JArray.addForm(actors,base)
                endif
                JArray.addForm(actors_all, base)
            else
                Debug.Trace("SummonNastyCritters creature unknown: "+name+" id:"+id+" plugin:"+plugin)
            endif 
            j += 1
        endwhile 
        num_creatures += AddCreature(creatures, creature, actors)
        num_creatures_all += AddCreature(creatures_all, creature, actors_all)

        i += 1 
    endwhile 
    Debug.Notification("Summon Nasty Critters total "+num_creatures+"/"+num_creatures_all)
endFunction 

Bool Function CreaturesMD5Changed()
    if info == 0
       return true
    else
       int i = JValue.readFromFile(CreatureList.info_file)
       if JMap.getStr(i,"creatures_md5") != JMap.getStr(info,"creatures_md5")
          return true
       endif 
    endif 
    return false
EndFunction

int function AddCreature(int cs, int c, int actors)
    if JArray.count(actors) > 0
        int creature = JMap.object()
        JMap.setStr(creature,"name",JMap.getStr(c,"name"))
        ;JValue.writeToFile(creature, "data/"+JMap.getStr(creature,"name")+".json")
        JMap.setObj(creature, "actors", actors)
        int paths = JMap.getObj(c,"paths")
        int j = 0
        int paths_count = JArray.count(paths)
        while j < paths_count
            JValue.solveObjSetter(cs,JArray.getStr(paths,j),creature,true)
            j += 1
        endwhile 
        return 1
    endif 
    return 0
endfunction

Actor function GetCreatureFromVictum(Actor victum)
    ; We are searching, rather them storing, becaues some race condition failed to update the critter_index :( 
    int i = 0
    int count = critter_refs.length
    while i < count && critter_refs[i].GetActorRef() != None
        i += 1
    endwhile 

    if i == count
        Debug.Notification("You have reached the maximum number of Nasty Critters "+critter_refs.length)
        ; ListCritters()
        return None 
    endif 
    ActorBase base = GetCreature(creatures) 
    if base != None
        Actor creature = victum.PlaceAtMe(base,1,false,false) as Actor
        JMap.setForm(creature_victum, creature, victum)
        creature.AddToFaction(SummonNastyCrittersFaction)
        ; JValue.writeToFile(creature_victum, "data/creature_victum.json")

        critter_refs[i].ForceRefTo(creature)
        creature.SetActorValue("health",95)

        DOM_API api = Game.GetFormFromFile(DOMO1_ID,DOM_FILE) as DOM_API
        if api != None && api.IsDOMSlave(victum) 
            DOM_Actor slave = api.GetDOMActor(victum) as DOM_Actor

            DOM_KEYS keys = Game.GetFormFromFile(DOM02Topic_ID,DOM_FILE) as DOM_KEYS
            string reason
            int imenu = keys.ShowDOMPunishmentMenu(victum)
            if imenu < 0
                reason = ""
            else
                reason = keys.selectPunishmentReason[imenu]
                if reason == ""
                    Debug.Trace("WARNING: Wheel menu returned invalid punishment reason")
                endif
            endif

            slave.Anim_SexlabWithNPC(creature, "", True, reason)
        else
            (critter_refs[i] as SummonNastyCritters_Critter).StartSex(victum)
        endif 
        return creature
    endif 
    return None
EndFunction 

Actor function GetVictumFromCreature(Actor Creature)
    return JMap.getForm(creature_victum, creature) as Actor
EndFunction 

Function BanishCreature(Actor creature)
    if !JMap.hasKey(creature_victum, creature)
        creature.DisableNoWait(true)
        creature.Delete()
        return
    endif 
    JMap.removeKey(creature_victum, creature)
    creature.DisableNoWait(true)
    creature.Delete()

    ; Find the creature reference
    int i = 0
    int count = critter_refs.length
    while i < count && creature != critter_refs[i].GetActorRef()
        i += 1
    endwhile 

    if i < count
        critter_refs[i].clear()
    Else
        Debug.Notification("Nasty Critter '"+creature.GetLeveledActorBase().getName()+"'' ("+creature.GetFormID()+") not found")
        ; ListCritters("Banish")
    endif 
EndFunction

function ListCritters(String buffer = "")
    int i = 0
    int count = critter_refs.length
    if buffer != ""
        buffer += "\n"
    endif 
    while i < count
        if critter_refs[i] == None 
            buffer += "   "+i+" None\n"
        else
            Actor act = critter_refs[i].GetActorRef()
            buffer += "   "+i+" "+act.GetLeveledActorBase().getName()+" ("+act.GetformID()+")\n"
        endif
        i += 1
    endwhile
    Debug.MessageBox(buffer)
endfunction

ActorBase function GetCreatureAll()
    return GetCreature(creatures_all)
endfunction

ActorBase Function GetCreature(int obj = 0)
    if obj == 0 
        obj = creatures 
    endif 

    String[] keys = JMap.allKeysPArray(obj)

    if JMap.hasKey(obj, "actors")
        int actors = JMap.getObj(obj,"actors")
        int last = JArray.count(actors) - 1
        int k = Utility.RandomInt(0,last)
        ActorBase creature = JArray.getForm(actors,k) as ActorBase
        return creature
    endif 
    int i = 0
    int count = keys.Length
    if count < 1
        Rebuild()
        keys = JMap.allKeysPArray(obj)
        count = keys.length
        if count < 1
            Debug.Notification("failed to find any critters")
            return None 
        endif 
    endif 

    uilistmenu listMenu = uiextensions.GetMenu("UIListMenu") AS uilistmenu
    while i < count
        listMenu.AddEntryItem(keys[i])
        i += 1
    endwhile
    listMenu.OpenMenu()
    String name = listmenu.GetResultString()
    if name
        return getCreature(JMap.getObj(obj,name)) 
    endif 
    return None
EndFunction 