import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:sproutvalley/models/constants/render_priority.dart';

class IntersectionBlock extends PositionComponent{

  late String name;
  late RectangleHitbox hitbox;

  IntersectionBlock({required this.name, super.position, super.size, super.anchor}){
    priority = RenderPriority.barrier;
  }

  @override
  FutureOr<void> onLoad() {
    hitbox = RectangleHitbox(
      size: size,
      collisionType: CollisionType.passive,
      isSolid: true
    );
    add(hitbox);
    return super.onLoad();
  }



}
