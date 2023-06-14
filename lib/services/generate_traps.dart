import '../models/trap.dart';

class TrapsGenerator {
  static Trap frozen = getTraps().where((t) => t.name == 'Frozen').first;
  static Trap teleport = getTraps().where((t) => t.name == 'Teleport').first;
  static Trap bomb = getTraps().where((t) => t.name == 'Bomb').first;
  static Trap knife = getTraps().where((t) => t.name == 'Knife').first;
  static Trap speed15 = getTraps().where((t) => t.name == 'Speed increase x 1.5').first;
  static Trap speed2 = getTraps().where((t) => t.name == 'Speed increase x 2').first;
  static Trap ghost = getTraps().where((t) => t.name == 'Go through the wall').first;
  static Trap blindness = getTraps().where((t) => t.name == 'Blindness').first;
  static Trap poison = getTraps().where((t) => t.name == 'Poison').first;
  static Trap healing = getTraps().where((t) => t.name == 'Healing').first;
  static Trap meteor = getTraps().where((t) => t.name == 'Meteor').first;
  static Trap invisibility = getTraps().where((t) => t.name == 'Invisibility').first;
  static Trap builder = getTraps().where((t) => t.name == 'Builder').first;

  static List<Trap> getTraps() {
    var traps = [
      Trap(
          id: 1,
          name: 'Frozen',
          description:
              'Trap your rival in a block of solid ice, dealing 5 damage and preventing them from moving 8 sec. ',
          damage: 5,
          baff: 0,
          img: 'assets/images/trap_Icons/texture_FrostTrap.png',
          audio: 'sfx_FrostTrap.mp3',
          cost: 3,
          used: false,
          weight: 2),
      Trap(
          id: 2,
          name: 'Teleport',
          description:
              'Instantly teleport your rival, dealing 10 damage and giving you a momentary advantage.',
          damage: 10,
          baff: 0,
          img: 'assets/images/trap_Icons/texture_Teleport.png',
          audio: 'sfx_teleport.mp3',
          cost: 3,
          used: false,
          weight: 3),
      Trap(
          id: 3,
          name: 'Bomb',
          description: 'Drop a bomb on your rival, dealing 15 damage.',
          damage: 20,
          baff: 0,
          img: 'assets/images/trap_Icons/texture_bomb.png',
          audio: 'sfx_Bomb.mp3',
          cost: 3,
          used: false,
          weight: 3),
      Trap(
          id: 4,
          name: 'Knife',
          description:
              'Throw a knife at your rival for 25 damage, but watch out for its high cost and weight.',
          damage: 30,
          baff: 0,
          img: 'assets/images/trap_Icons/texture_Knife.png',
          audio: 'sfx_KnifeTrap.mp3',
          cost: 12,
          used: false,
          weight: 5),
      Trap(
          id: 5,
          name: 'Speed increase x 1.5',
          description:
              'Give yourself a quick boost of speed 50%, leaving your rival in the dust.',
          damage: 0,
          baff: 0,
          img: 'assets/images/trap_Icons/texture_BootOfSpeed.png',
          audio: '',
          cost: 5,
          used: false,
          weight: 2),
      Trap(
          id: 6,
          name: 'Speed increase x 2',
          description:
              'Give yourself a quick boost of speed 100%, leaving your rival in the dust.',
          damage: 0,
          baff: 0,
          img: 'assets/images/trap_Icons/texture_BootOfSpeed.png',
          audio: '',
          cost: 12,
          used: false,
          weight: 5),
      Trap(
          id: 7,
          name: 'Go through the wall',
          description:
              'Skip an obstacle by teleporting yourself through solid walls.',
          damage: 0,
          baff: 0,
          img: 'assets/images/trap_Icons/texture_Ghost.png',
          audio: '',
          cost: 8,
          used: false,
          weight: 3),
      Trap(
          id: 8,
          name: 'Blindness',
          description:
              'Strike your rival with a blast of light, blinding them and dealing 5 damage.',
          damage: 10,
          baff: 0,
          img: 'assets/images/trap_Icons/texture_blindingTrap.png',
          audio: '',
          cost: 2,
          used: false,
          weight: 1),
      Trap(
          id: 9,
          name: 'Poison',
          description:
              'Put a deadly venom on their skin, dealing 10 damage and hampering their abilities.',
          damage: 15,
          baff: 0,
          img: 'assets/images/trap_Icons/texture_PoisonTrap.png',
          audio: '',
          cost: 10,
          used: false,
          weight: 3),
      Trap(
          id: 10,
          name: 'Healing',
          description: 'Cast a spell that will heal 25 life.',
          damage: 0,
          baff: 25,
          img: 'assets/images/trap_Icons/texture_HealingTrap.png',
          audio: '',
          cost: 12,
          used: false,
          weight: 5),
      Trap(
          id: 11,
          name: 'Meteor',
          description:
              'A meteor shower falls from the sky all over the map, inflicting a random defeat on different cells',
          damage: 0,
          baff: 0,
          img: 'assets/images/trap_default.png',
          audio: '',
          cost: 12,
          used: false,
          weight: 5),
      Trap(
          id: 12,
          name: 'Invisibility',
          description: 'You become invisible for 20 seconds',
          damage: 0,
          baff: 0,
          img: 'assets/images/trap_default.png',
          audio: '',
          cost: 8,
          used: false,
          weight: 3),
      Trap(
          id: 13,
          name: 'Builder',
          description: 'Builds an illusion of a wall that lasts 15 seconds',
          damage: 0,
          baff: 0,
          img: 'assets/images/trap_default.png',
          audio: '',
          cost: 8,
          used: false,
          weight: 3),
    ];
    return upTo(traps, 16);
  }

  static List<Trap> toListTraps(List<dynamic> traps, List<Trap> allTraps) {
    List<Trap> listToReturn = [];
    if (traps.length > 0) {
      for (var i = 0; i < traps.length; i++) {
        Trap trap = allTraps
            .firstWhere((element) => element.name == traps[i].toString());
        listToReturn.add(trap);
      }
    }
    // return upTo(listToReturn, 12);
    return listToReturn;
  }

  static List<dynamic> toListDynamic(List<Trap> traps) {
    List<dynamic> listToReturn = [];
    for (var i = 0; i < traps.length; i++) {
      if (traps[i].name != 'empty') {
        listToReturn.add(traps[i].name.toString());
      }
    }
    return listToReturn;
  }

  static List<Trap> upTo(List<Trap> traps, int num) {
    if (traps.length >= num) {
      return traps;
    } else {
      for (var i = 0; i < num; i++) {
        Trap trap = Trap(
            id: 0,
            name: 'empty',
            description: '',
            damage: 0,
            baff: 0,
            img: '',
            audio: '',
            cost: 0,
            used: false,
            weight: 0);
        traps.add(trap);
        if (traps.length >= num) {
          break;
        }
      }
      return traps;
    }
  }
}
