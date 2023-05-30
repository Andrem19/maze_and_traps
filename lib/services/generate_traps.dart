import '../models/trap.dart';

class TrapsGenerator {
  static List<Trap> getTraps() {
    var traps = [
      Trap(
          name: 'Frozen',
          description:
              'Trap your rival in a block of solid ice, dealing 5 damage and preventing them from moving 8 sec. ',
          damage: 5,
          baff: 0,
          img: 'assets/images/snowflake.jpg',
          cost: 3,
          weight: 2),
      Trap(
          name: 'Teleport',
          description:
              'Instantly teleport your rival, dealing 10 damage and giving you a momentary advantage.',
          damage: 10,
          baff: 0,
          img: 'assets/images/teleport.jpg',
          cost: 3,
          weight: 3),
      Trap(
          name: 'Bomb',
          description: 'Drop a bomb on your rival, dealing 15 damage.',
          damage: 20,
          baff: 0,
          img: 'assets/images/trap_default.png',
          cost: 3,
          weight: 3),
      Trap(
          name: 'Knife',
          description:
              'Throw a knife at your rival for 25 damage, but watch out for its high cost and weight.',
          damage: 30,
          baff: 0,
          img: 'assets/images/trap_default.png',
          cost: 12,
          weight: 5),
      Trap(
          name: 'Speed increase',
          description:
              'Give yourself a quick boost of speed, leaving your rival in the dust.',
          damage: 0,
          baff: 0,
          img: 'assets/images/trap_default.png',
          cost: 5,
          weight: 2),
      Trap(
          name: 'Go through the wall',
          description:
              'Skip an obstacle by teleporting yourself through solid walls.',
          damage: 0,
          baff: 0,
          img: 'assets/images/trap_default.png',
          cost: 8,
          weight: 3),
      Trap(
          name: 'Blindness',
          description:
              'Strike your rival with a blast of light, blinding them and dealing 5 damage.',
          damage: 10,
          baff: 0,
          img: 'assets/images/trap_default.png',
          cost: 2,
          weight: 1),
      Trap(
          name: 'Poison',
          description:
              'Put a deadly venom on their skin, dealing 10 damage and hampering their abilities.',
          damage: 15,
          baff: 0,
          img: 'assets/images/trap_default.png',
          cost: 10,
          weight: 3),
      Trap(
          name: 'Healing',
          description: 'Cast a spell that will heal 25 life.',
          damage: 0,
          baff: 25,
          img: 'assets/images/trap_default.png',
          cost: 12,
          weight: 5),
    ];
    return upTo12(traps);
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
    return upTo12(listToReturn);
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

  static List<Trap> upTo12(List<Trap> traps) {
    if (traps.length >= 12) {
      return traps;
    } else {
      for (var i = 0; i < 12; i++) {
        Trap trap = Trap(
            name: 'empty',
            description: '',
            damage: 0,
            baff: 0,
            img: '',
            cost: 0,
            weight: 0);
        traps.add(trap);
        if (traps.length >= 12) {
          break;
        }
      }
      return traps;
    }
  }
}
