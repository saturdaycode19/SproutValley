import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import 'package:sproutvalley/models/constants/global_constants.dart';
import 'package:sproutvalley/models/constants/render_priority.dart';
import 'package:sproutvalley/models/enums/direction.dart';
import 'package:sproutvalley/models/enums/object_state.dart';
import 'package:sproutvalley/sprout_valley.dart';

class PlayerSprite extends SpriteAnimationComponent with HasGameReference<SproutValley>{

  PlayerSprite({required Vector2 position, required Vector2 size}) : super(
    position: position,
    size: size,
    priority: RenderPriority.player,
    scale: Vector2(WORLD_SCALE, WORLD_SCALE)
  );

  late SpriteAnimation idleDownAnimation, idleUpAnimation, idleLeftAnimation, idleRightAnimation;
  late SpriteAnimation walkDownAnimation, walkUpAnimation, walkLeftAnimation, walkRightAnimation;

  Vector2 srcSize = Vector2(48, 48);

  double movementSpeed = 100;

  PlayerState state = PlayerState.idle;
  PlayerDirection direction = PlayerDirection.down;

  final Map<LogicalKeyboardKey, int> _keyWeight = {
    LogicalKeyboardKey.keyW : 0,
    LogicalKeyboardKey.keyA : 0,
    LogicalKeyboardKey.keyS : 0,
    LogicalKeyboardKey.keyD : 0
  };

  @override
  FutureOr<void> onLoad() async{
    await loadAssets();
    await loadInputs();
    return super.onLoad();
  }


  @override
  void update(double dt) {
    _playerMove(dt);
    super.update(dt);
  }

  loadAssets()async{
    idleDownAnimation = _createSpriteSheetAnimation("characters/players/idle/player_idle_down.png");
    idleUpAnimation = _createSpriteSheetAnimation("characters/players/idle/player_idle_up.png");
    idleLeftAnimation = _createSpriteSheetAnimation("characters/players/idle/player_idle_left.png");
    idleRightAnimation = _createSpriteSheetAnimation("characters/players/idle/player_idle_right.png");

    walkDownAnimation = _createSpriteSheetAnimation("characters/players/walk/player_walk_down.png");
    walkUpAnimation  = _createSpriteSheetAnimation("characters/players/walk/player_walk_up.png");
    walkLeftAnimation  = _createSpriteSheetAnimation("characters/players/walk/player_walk_left.png");
    walkRightAnimation  = _createSpriteSheetAnimation("characters/players/walk/player_walk_right.png");

    animation = idleDownAnimation;
  }

  _createSpriteSheetAnimation(String name, {int length = 7, double stepTime = 0.1}){
    return SpriteSheet(
      image: game.images.fromCache(name),
      srcSize: srcSize,
      spacing: 1
    ).createAnimation(row: 0, to: length, stepTime: stepTime);
  }

  loadInputs()async{
    await add(
      KeyboardListenerComponent(
        keyUp: {
          LogicalKeyboardKey.keyA : (key) =>
            _handleKey(LogicalKeyboardKey.keyA, false),
          LogicalKeyboardKey.keyW : (key) =>
              _handleKey(LogicalKeyboardKey.keyW, false),
          LogicalKeyboardKey.keyS : (key) =>
              _handleKey(LogicalKeyboardKey.keyS, false),
          LogicalKeyboardKey.keyD : (key) =>
              _handleKey(LogicalKeyboardKey.keyD, false),
        },
        keyDown: {
          LogicalKeyboardKey.keyA : (key) =>
              _handleKey(LogicalKeyboardKey.keyA, true),
          LogicalKeyboardKey.keyW : (key) =>
              _handleKey(LogicalKeyboardKey.keyW, true),
          LogicalKeyboardKey.keyS : (key) =>
              _handleKey(LogicalKeyboardKey.keyS, true),
          LogicalKeyboardKey.keyD : (key) =>
              _handleKey(LogicalKeyboardKey.keyD, true),
        }
      )
    );
  }

  _handleKey(LogicalKeyboardKey key, bool isDown){
    _keyWeight[key] = isDown ? 1 : 0;
    return true;
  }

  int get xInputKey =>
      _keyWeight[LogicalKeyboardKey.keyD]! - _keyWeight[LogicalKeyboardKey.keyA]!;
  int get yInputKey =>
      _keyWeight[LogicalKeyboardKey.keyS]! - _keyWeight[LogicalKeyboardKey.keyW]!;

  _playerMove(double dt){
    if(xInputKey == -1 && yInputKey == 0){
      _walkLeft(dt);
    }else if(xInputKey == 1 && yInputKey == 0){
      _walkRight(dt);
    }else if(xInputKey == 0 && yInputKey == 1){
      _walkDown(dt);
    }else if(xInputKey == 0 && yInputKey == -1){
      _walkUp(dt);
    }else{
      _idle(dt);
    }


  }

  _idle(dt){
    state = PlayerState.idle;
    switch(direction){
      case PlayerDirection.down:
        return _idleDown();
      case PlayerDirection.up:
        return _idleUp();
      case PlayerDirection.right:
        return _idleRight();
      case PlayerDirection.left:
        return _idleLeft();
      default:
        return _idleDown();

    }
  }

  _idleDown(){
    animation = idleDownAnimation;
  }

  _idleUp(){
    animation = idleUpAnimation;
  }

  _idleRight(){
    animation = idleRightAnimation;
  }

  _idleLeft(){
    animation = idleLeftAnimation;
  }

  _walkLeft(double dt){
    position.x += movementSpeed * dt * -1;
    animation = walkLeftAnimation;
    state = PlayerState.walk;
    direction = PlayerDirection.left;
  }

  _walkRight(double dt){
    position.x += movementSpeed * dt * 1;
    animation = walkRightAnimation;
    state = PlayerState.walk;
    direction = PlayerDirection.right;
  }

  _walkUp(double dt){
    position.y += movementSpeed * dt * -1;
    animation = walkUpAnimation;
    state = PlayerState.walk;
    direction = PlayerDirection.up;
  }

  _walkDown(double dt){
    position.y += movementSpeed * dt * 1;
    animation = walkDownAnimation;
    state = PlayerState.walk;
    direction = PlayerDirection.down;
  }
}