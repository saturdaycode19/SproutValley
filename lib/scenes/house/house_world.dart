import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:sproutvalley/models/blocks/collision_block.dart';
import 'package:sproutvalley/models/constants/global_constants.dart';
import 'package:sproutvalley/objects/characters/player/player_sprite.dart';
import 'package:sproutvalley/sprout_valley.dart';

class HouseWorld extends World
    with HasGameReference<SproutValley>{

  late TiledComponent mapTiled;
  late Vector2 tileMapSize;

  late PlayerSprite player;

  @override
  FutureOr<void> onLoad() async {
    await loadMaps();
    await loadCollision();

    return super.onLoad();
  }

  loadMaps()async{
    var map = game.houseMap;
    mapTiled = game.houseTiled;

    tileMapSize = Vector2(
        mapTiled.tileMap.map.width * WORLD_SCALE,
        mapTiled.tileMap.map.height * WORLD_SCALE
    );

    await loadCharacters();

    game.cameraComponent.viewfinder.position = player.position.clone();
    game.cameraComponent.follow(player);

    await addAll([map]);
  }

  loadCollision()async{
    await loadWallCollision();
  }

  loadWallCollision()async{
    final objectLayer = mapTiled.tileMap.getLayer<ObjectGroup>('walls')!;
    for(final TiledObject object in objectLayer.objects){
      final block = CollisionBlock(
          position: Vector2(object.x * WORLD_SCALE, object.y * WORLD_SCALE),
          size: Vector2(object.width * WORLD_SCALE, object.height * WORLD_SCALE)
      );
      await add(block);
    }

    final objectLayer2 = mapTiled.tileMap.getLayer<ObjectGroup>('furnitures')!;
    for(final TiledObject object in objectLayer2.objects){
      final block = CollisionBlock(
          position: Vector2(object.x * WORLD_SCALE, object.y * WORLD_SCALE),
          size: Vector2(object.width * WORLD_SCALE, object.height * WORLD_SCALE)
      );
      await add(block);
    }

  }

  loadCharacters()async{
    player = PlayerSprite(position: Vector2(500, 500), size: Vector2.all(48));
    await add(player);
  }
}