Scriptname SummonNastyCritters_Critter extends ReferenceAlias  

SummonNastyCritters_CreatureList Property CreatureList Auto
SexLabFramework Property SexLab Auto
Spell Property SummonNastyCritters_Cloak Auto

import MfgConsoleFunc

Event OnDeath(Actor akKiller) 
  ;Debug.Notification(self.GetActorRef().GetLeveledActorBase().GetName()+" killed by "+akKiller.GetActorBase().GetName())
 ;  SE_RefMan.RemoveSuccubus(self.GetActorRef())
  CreatureList.BanishCreature(self.GetActorRef())
EndEvent

Event OnCellDetach()
  CreatureList.BanishCreature(self.GetActorRef())
EndEvent

Event OnEnterBleedout()
  ;Debug.Notification(self.GetActorRef().GetLeveledActorBase().GetName()+"is bleeding")
  CreatureList.BanishCreature(self.GetActorRef())
EndEvent

bool function StartSex(Actor victum)
  Actor creature = self.GetActorRef()
  if !StartSexHelper(creature,victum)
    CreatureList.BanishCreature(creature)
    return false
  endif
  creature.AddSpell(SummonNastyCritters_Cloak)
  return True
endFunction 

Bool Function StartSexHelper(Actor creature, Actor target)
    Race creatureRace = creature.GetRace()
    sslThreadModel thread = SexLab.NewThread()

    if !SexLab.AllowCreatures
        Debug.Notification("SexLab does not allow creature animations.  Change in MCM.")
        Return false
    endif

    ; check if the animal is a valid actor
    if !SexLab.IsValidActor(target)
        Debug.Notification(target.GetLeveledActorBase().GetName()+" can't have sex")
        return false
    endif 
    if !SexLab.IsValidActor(creature)
        Debug.Notification(creature.GetLeveledActorBase().GetName()+" can't have sex (did you load SLAL?)")
        return false
    endif 

    if thread.addActor(creature) < 0   
        Debug.Notification("SummonNastyCritters: Failed to slot creature into the animation thread - See debug log for details.")
        return false
    endif  
    if thread.addActor(target) < 0   
        Debug.Notification("SummonNastyCritters: Failed to slot target into the animation thread - See debug log for details.")
        return false
    endif  

    ; Now that is is possible

    ; Set hook and setup event 
    thread.SetHook("SummonNastyCritters")
    ; RegisterForModEvent("HookAnimationEnd_SummonNastyCritters", "AnimationStart")
    RegisterForModEvent("HookAnimationEnd_SummonNastyCritters", "AnimationEnd")
    thread.StartThread()
    return True
EndFunction

; Our AnimationStart hook, called from the RegisterForModEvent("HookAnimationEnd_MatchMaker", "AnimationEnd") in TriggerSex()
;  -  HookAnimationEnd is sent by SexLab called once the sex animation has fully stopped.
event AnimationStart(int ThreadID, bool HasPlayer)
	; Get the thread that triggered this event via the thread id
	 sslThreadController Thread = SexLab.GetController(ThreadID)
	; Get our list of actors that were in this animation thread.
	Actor[] actors = Thread.Positions
    actors[0].StartCombat(actors[1])
    actors[1].StartCombat(actors[0])
endEvent

; Our AnimationEnd hook, called from the RegisterForModEvent("HookAnimationEnd_MatchMaker", "AnimationEnd") in TriggerSex()
;  -  HookAnimationEnd is sent by SexLab called once the sex animation has fully stopped.
event AnimationEnd(int ThreadID, bool HasPlayer)
	; Get the thread that triggered this event via the thread id
	sslThreadController Thread = SexLab.GetController(ThreadID)
	; Get our list of actors that were in this animation thread.
	Actor[] actors = Thread.Positions
    Actor victim = actors[0]
    Actor creature = actors[1]
    CreatureList.BanishCreature(creature)

    if !victim.isDead()
      ; Set up the victum to cry
      sslBaseVoice voice = SexLab.PickVoice(victim)
      ;	int vfxInstance = voice.Moan(victim, 0.5, true)
      ;	Sound.SetInstanceVolume(vfxInstance, SexLab.Config.fVoiceVolume)			
      MfgConsoleFunc.ResetPhonemeModifier(victim)	; Remove any previous modifiers and phenomes
      victim.SetExpressionOverride(3,100)	; for "That hurt like hell! look"
      MfgConsoleFunc.SetModifier(victim,2,50)
      MfgConsoleFunc.SetModifier(victim,3,50)
      MfgConsoleFunc.SetModifier(victim,4,50)
      MfgConsoleFunc.SetModifier(victim,5,50)
      MfgConsoleFunc.SetModifier(victim,8,50)
      MfgConsoleFunc.SetModifier(victim,12,30)
      MfgConsoleFunc.SetModifier(victim,13,30)
      MfgConsoleFunc.SetPhoneme(victim,1,10)
      MfgConsoleFunc.SetPhoneme(victim,2,100)
      MfgConsoleFunc.SetPhoneme(victim,7,50)
      debug.SendAnimationEvent(victim,"IdleChildCryingStart")	; Cry patiently while waiting for your next Mating partner or your designated Mate to get it up again
    endif 
endEvent