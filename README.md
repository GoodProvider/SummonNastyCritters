### Summary

This provides two spells that can be used to summon creatures. Both
spells are added to the player. The nice version has all the "friendly"
creatures from CreatureSummoner_MNCSEv15. Nasty only those I was
able to run in SexLab. For no there is no MCM, but there does
exist a Control spell you can get with [AddItem](https://www.nexusmods.com/skyrimspecialedition/mods/17563).
You shouldn't need it.

Bug Reports or features requests should be added to this repository's [Issues](issues)

- **Summon Critters Nasty**: spawns a creature by the target, starts sex between
  the target and the creature, and then has all allies of the target attack the creature.

- **Summon Critters Nice**: spawns the creature by the player

### Issues I would like Help with

- DOM support for DOM slaves
- Improved creature tree:
  - [current tree](SummonNastyCritters/data/groups.yaml)
- Increase the number of creatures with animations. Several creatures should have animations
  in Billy, but I couldn't get them to work.

### Requirements

- Esssential
  - [SKSE](https://skse.silverlock.org/)
  - [Address Library for SKSE Plugins](https://www.nexusmods.com/skyrimspecialedition/mods/32444)
  - [USSEP](https://www.nexusmods.com/skyrimspecialedition/mods/266)
  - [Vanilla Script MicroOptimizations](https://www.nexusmods.com/skyrimspecialedition/mods/54061)
  - [Fuz Ro D'oh](https://www.nexusmods.com/skyrimspecialedition/mods/15109)
  - [UIExtensions](https://www.nexusmods.com/skyrimspecialedition/mods/17561)
  - [JContainers](https://www.nexusmods.com/skyrimspecialedition/mods/16495)
  - [SkyUI SE](https://www.nexusmods.com/skyrimspecialedition/mods/12604)
  - [PapyrusUtil SE](https://www.nexusmods.com/skyrimspecialedition/mods/13048)
  - [Alternate Start](https://www.nexusmods.com/skyrimspecialedition/mods/272) (nice, but not needed)
- nude body not required
  - [Scholongs of Skyrim SE](https://www.loverslab.com/files/file/5355-schlongs-of-skyrim-se/)
  - [Caliente's Beautiful Bodies Enhancer -CBBE-](https://www.nexusmods.com/skyrimspecialedition/mods/198) or BHUNP
- Animation
  - [Pandora](https://www.nexusmods.com/skyrimspecialedition/mods/133232)
  - Pandora Output (recommanded to store Pandora's output)
  - [XP32 Maximum Skeleton Special Extended (XPMSSE)](https://www.nexusmods.com/skyrimspecialedition/mods/1988)
  - Fores New Idles in Skyrim SE <br/>
    └─ [FNIS Creature Pack SE](https://www.nexusmods.com/skyrimspecialedition/mods/3038?tab=files)
  - [More Nasty Critters](https://www.loverslab.com/files/file/5464-more-nasty-critters-specialanniversary-edition/) <br/>
    ├─ CreatureFramework...7z<br/>
    ├─ CreatureSummoner_MNCSEv15.7z<br/>
    └─ MoreNastyCrittersSE_v15_6(SplitVolumeFile).7z
- SexLab
  - [Sexlab Framework](https://www.loverslab.com/files/category/228-sexlab-framework-se/)
  - [OSL Aroused Reborn](https://www.loverslab.com/files/file/20867-osl-aroused-arousal-reborn-sse-ae/)
- animations (YOu might be able to get away with less ... )
  - [Anub](https://www.loverslab.com/files/file/2376-anubs-animation-dump-reborn/)
  - [Billyy](https://www.loverslab.com/files/file/3999-billyys-slal-animations-2025-1-1/)
  - [BakaFacrtory](https://www.loverslab.com/files/file/6707-bakafactorys-slal-animation-le-sse/)
  - [FunnyBizness](https://www.loverslab.com/files/file/2702-funnybizness-v25-slal-pack-by-shashankie/)
- SummonNastyCritters
  - SummonNastyCritters (this mod)

### Setup

- Run Pandora (will need to rerun with each change in animations)
- Start skyrim with SKSE
- Go into the MCM and start SexLab
  - After SexLab has loaded, go back in to SexLab and enable creatures (top left)
- Go into SASL and click on "enable all" (to make sure the animations loaded)
