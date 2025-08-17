import 'dart:async';

import 'package:flame/cache.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame_tiled_utils/flame_tiled_utils.dart';
import 'package:flutter/material.dart';
import 'package:sproutvalley/models/constants/global_constants.dart';
import 'package:sproutvalley/models/constants/render_priority.dart';
import 'package:sproutvalley/scenes/worlds/farm_world.dart';

class SproutValley extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection{

  late BuildContext gameContext;
  late CameraComponent cameraComponent;
  late RouterComponent router;

  late TiledComponent farmTiled;
  late PositionComponent farmMap;

  late SpriteAnimationComponent waterFarmComponent;

  final imageCompiler = ImageBatchCompiler();

  void initWithBuildContext(BuildContext context){
    gameContext = context;
  }

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    await preRenderWorld();
    await loadRouterWorld();
    return super.onLoad();
  }

  loadRouterWorld()async{
    cameraComponent = CameraComponent();
    router = RouterComponent(routes: {
      'farm' : WorldRoute(
        () {
          final farmWorld = FarmWorld();
          cameraComponent.world = farmWorld;
          return farmWorld;
        },
        maintainState: false
      ),
    }, initialRoute: 'farm', );

    await addAll([cameraComponent, router]);
  }

  preRenderWorld()async{
    await renderFarm();
  }

  renderFarm()async{
    farmTiled = await TiledComponent.load(
        'farm/farm.tmx',
        Vector2.all(WORLD_TILE_SIZE),
        images: Images(prefix: 'assets/images/resources/'),
        priority: RenderPriority.ground
    );

    farmTiled.tileMap.map.height *= 16;
    farmTiled.tileMap.map.width *= 16;

    farmMap = imageCompiler.compileMapLayer(
        tileMap: farmTiled.tileMap,
        layerNames: [
          'ground'
        ]
    );
    farmMap.priority = RenderPriority.ground;

    final animationCompiler = AnimationBatchCompiler();
    await TileProcessor.processTileType(
        tileMap: farmTiled.tileMap,
        processorByType: <String, TileProcessorFunc>{
          'water' : ((tile, position, size) async {
            return animationCompiler.addTile(position, tile, useRelativePath: true);
          })
        },
        layersToLoad: ['water']);

    waterFarmComponent = await animationCompiler.compile();
    waterFarmComponent.scale = Vector2.all(WORLD_SCALE);
    waterFarmComponent.priority = RenderPriority.water;
  }

}