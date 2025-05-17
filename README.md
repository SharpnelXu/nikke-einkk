# Einkk
Battle Simulation app for Nikke.

Data sourced from Internet and not included in repo at the moment.

## Damage & Stat Formula

Final Damage = Final Attack * Final Damage Rate * Total Corrections * Elements * Charge Rate * Add Damage Rate * Receive Damage Rate

Final Attack = Base Attack + Attack Buffs - Base Defence - Defence Buffs
- Base Stat = Level Stat (Classified by Nikke Class + Weapon Type) + Limit Break Stat + Bond Stat + Console Stat + Core Break Stat + Gear Stat + Cube Stat + Doll Stat
  - Limit Break Stat = Level Stat * Limit Break Ratio (Usually 2%) * Limit Break Count (Range 0 ~ 3) + Limit Break Add Stat (Fixed Value) * Limit Break Count (Range 0 ~ 3)
  - Console Stat = Common Research + Class Research + Corporation Research
  - Core Break Stat = (Level Stat + Max Limit Break (Limit Break Count = 3) Stat + Bond Stat + Console Stat) * Core Break Ratio (Usually 2%) 
  - Gear Stat = Gear Base Stat * (1 + 0.1 * Level + Same Corporation Factor)
    - Same Corporation Factor = 0.3 if gear corporation label matches wearer's corporation, 0 otherwise
    - Note that T10 gears **do not** have corp label hence won't have this factor
   
Final Damage Rate = Damage Rate + Damage Rate Buffs
  - Damage Rate: Specified by skill or weapon
  
Total Corrections = 100% + Core Correction + Crit Correction + Range Correction + Full Burst Correction
  - Core Correction: Base is 100% (Data is 200%, but for correction needs to deduct 100%)
  - Crit Correction: Base is 50%
  - Range Correction: Base is 30%
  - Full Burst Correction: Base is 50%

Elements: Base is 110%

Charge Rate = (Max Charge Rate + Charge Rate Multiplier * Max Charge Rate + Charge Damage Buffs) * Charge Percent
  - Charge Rate Multiplier: SR Doll skill

Add Damage Rate = 100% + Add Damage Buffs + Part Damage Buffs + Interruption Part Damage Buffs + Sustained Damage Buffs + Pierce Damage Buffs

Receive Damage Rate = 100% + Receive Damage Buffs + Distributed Damage Buffs

## Weapon Mechanism

- All weapons have `spotFirstDelay` which specifies how long it takes for a nikke to come out of cover
  - Usually 0.2s (12 frames), exceptions are Tove 0.33s (20 frames) and Nero (she is faster than normal)
- All weapons have `spotLastDelay` which specifies how long it takes for a nikke to retreat behind cover
  - Can be cancelled by user input
  - This is factored into reload time calculation, so technically reload time buffs need to be 100%+ to achieve one frame reload
- After each shot, SRs & RLs will retreat to cover, so each sequential attack needs to wait an extra of `spotFirstDelay + spotLastDelay`
  - Except for nikkes with `maintainFireStance` (A2 & SBS)
- SRs & RLs start charging at 100% (first frame of charging), and will fire after charging complete (since `inputType` is `UP`)
  - Without charging speed buffs, charging time is constant regardless of charge rate buffs

## Niche Mechanisms Waiting To Be Categorized
- Shotgun's burst gen data is per pellet
- Snipers & Rocket Launchers have -1 frame charge time compared to data, so chargeTime = 60 frames (from 1s) only needs
59 frames to fully charge, and the 60th frame is for firing the bullet / projectile. Also, when moving out of cover,
the last frame will actually be the first charging frame, so each full charge attack cycle is actually 2 frames faster
compared to calculation
- Equipment level stat rounding method is roundHalfToEvent (stat from level & stat from same corp are rounded separately)
- Nikke stat rounding: gradeRatioStat is truncated to int, core stat is normal rounding
- Current damage formula is roughly 0.0001% inaccurate due to rounding, the extreme example I used is Snow White's ult
where the difference is 0.000004% (actual: 902435165 vs calculated: 902435200)
- HP Ratio triggers (Emergency Max HP Cube) will not trigger again if the HP stays in trigger range
- Each burst skill takes 1 frame (fastest possible), re-enter burst skills have 0.5s cd

## TODOs

### Simulation

- Weapons
  - Better formula for core %, current formula is hardcoded as `50 * rapture.coreSize / (nikke.accuracyCircleScale * rapture.distance)` 
    - 50 is a made up number
    - `rapture.coreSize` is a made up data
  - A2: need to deduct bullet at upTypeFireTiming
  - A2: has 9 extra frames each attack comparing to data
  - RLs: projectile travel calculation, current formula is hardcoded as `100 * rapture.distance / projectileSpeed`
- Skills
  - Function Target & Timing Trigger Standard & Status Trigger Standard
- Equip skills
- Cube skills
- Doll skills
- Data provisioning, too unpredictable if sourced from static game data
- User actions
- Boss actions

### UI
- *Essentially everything*
- Real timeline
- Individual damage specifications
- Filter out actions
- Damage summary
- Nikke select UI
- Nikke config UI
- User action edit UI
- Boss action edit UI
