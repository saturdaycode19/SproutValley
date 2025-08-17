import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:sproutvalley/models/constants/render_priority.dart';

class CollisionBlock extends PositionComponent{
  late RectangleHitbox hitbox;

  CollisionBlock({super.position, super.size}){
    priority = RenderPriority.barrier;
    hitbox = RectangleHitbox(size: size, isSolid: true);
  }

  bool get isColliding => hitbox.isColliding;

  @override
  FutureOr<void> onLoad() {
    add(hitbox);
    return super.onLoad();
  }
}