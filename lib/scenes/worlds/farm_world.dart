import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:sproutvalley/models/blocks/collision_block.dart';
import 'package:sproutvalley/models/blocks/intersection_block.dart';
import 'package:sproutvalley/models/constants/global_constants.dart';
import 'package:sproutvalley/models/constants/interact_name.dart';
import 'package:sproutvalley/objects/characters/player/player_sprite.dart';
import 'package:sproutvalley/sprout_valley.dart';

class FarmWorld extends World
    with HasGameReference<SproutValley>{

  late TiledComponent mapTiled;
  late Vector2 tileMapSize;

  late PlayerSprite player;

  @override
  bool get debugMode => true;

  @override
  FutureOr<void> onLoad() async {
    await loadMaps();
    await loadCollision();
    await loadInteractCollision();
    await loadCharacters();
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size){
    super.onGameResize(size);
    setCameraBounds(size);
  }

  setCameraBounds(Vector2 size){
    game.cameraComponent.setBounds(
      Rectangle.fromLTRB(
          size.x / 2,
          size.y / 2,
          (tileMapSize.x - WORLD_SCALE) - size.x / 2,
          (tileMapSize.y - WORLD_SCALE) - size.y / 2)
    );
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
        position: Vector2(800, 800),
        size: Vector2(48, 48)
    );

    await add(player);

    game.cameraComponent.viewfinder.position = player.position.clone();
    game.cameraComponent.follow(player);
  }

  loadCollision()async{
    await loadWallCollision();
    await loadHouseWallCollision();
  }

  loadInteractCollision()async{
    await loadInteractHouseCollision();
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
  }

  loadHouseWallCollision()async{
    final objectLayer = mapTiled.tileMap.getLayer<ObjectGroup>('house_walls')!;
    for(final TiledObject object in objectLayer.objects){
      final block = CollisionBlock(
          position: Vector2(object.x * WORLD_SCALE, object.y * WORLD_SCALE),
          size: Vector2(object.width * WORLD_SCALE, object.height * WORLD_SCALE)
      );
      await add(block);
    }
  }

  loadInteractHouseCollision()async{
    final objectLayer = mapTiled.tileMap.getLayer<ObjectGroup>('house_door')!;
    for(final TiledObject object in objectLayer.objects){
      final block = IntersectionBlock(
          name: InteractName.farmDoorToHouse,
          position: Vector2(object.x * WORLD_SCALE, object.y * WORLD_SCALE),
          size: Vector2(object.width * WORLD_SCALE, object.height * WORLD_SCALE),
      );
      await add(block);
    }
  }

}