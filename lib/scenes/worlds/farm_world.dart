import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:sproutvalley/models/constants/global_constants.dart';
import 'package:sproutvalley/objects/characters/player/player_sprite.dart';
import 'package:sproutvalley/sprout_valley.dart';

class FarmWorld extends World with HasGameReference<SproutValley>{

  late TiledComponent mapTiled;
  late Vector2 tileMapSize;

  late PlayerSprite player;


  @override
  FutureOr<void> onLoad() async {
    await loadMaps();
    await loadCharacters();
    return super.onLoad();
  }

  loadMaps()async{
    var map = game.farmMap;
    var waterMap = game.waterFarmComponent;
    mapTiled = game.farmTiled;

    tileMapSize = Vector2(
        mapTiled.tileMap.map.width * WORLD_SCALE,
        mapTiled.tileMap.map.height * WORLD_SCALE
    );

    await addAll([map, waterMap]);
  }

  loadCharacters()async{
    player = PlayerSprite(
        position: Vector2(500, 500),
        size: Vector2(48, 48)
    );

    await add(player);

    game.cameraComponent.viewfinder.position = player.position.clone();
    game.cameraComponent.follow(player);
  }

}