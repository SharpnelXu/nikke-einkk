using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum CharacterSkillType
{
    Unknown = -1,
    None = 0,
    InstantAll = 1,
    InstantNumber = 2,
    AimingExplosion = 3,
    AimingPenetration = 4,
    InstallDrone = 5,
    InstallBarrier = 6,
    ChangeWeapon = 7,
    SetBuff = 8,
    InstantSkill = 9,
    Custom191Ulti = 10,
    LaunchWeapon = 11,
    TargetShot = 12,
    InstantCircle = 13,
    InstantLine = 14,
    InstantArea = 15,
    InstallDecoy = 16,
    MultiTarget = 17,
    LaserBeam = 18,
    Stigma = 19,
    MaxHPInstantNumber = 20,
    InstantCircleSeparate = 21,
    HitMonsterGetBuff = 22,
    ExplosiveCircuit = 23,
    InstantSequentialAttack = 24,
    ReFullChargeHitDamage = 25,
    InstantAllParts = 26,
    TargetHitCountGetBuff = 27,
    HealCharge = 28,
    TargetingSequentialAttack = 29,
    InstantAllProjectile = 30
}
