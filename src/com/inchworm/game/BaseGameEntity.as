/**
 * Created by IntelliJ IDEA.
 * User: RobDodson
 * Date: 9/8/11
 * Time: 6:09 PM
 * To change this template use File | Settings | File Templates.
 */
package com.inchworm.game
{
import flash.display.Sprite;
import flash.geom.Point;

public class BaseGameEntity extends Sprite implements IGameEntity
{
	//--------------------------------------------
	// every entity has a unique identifying number
	private var _ID						:int;

	// every entity has a type associated with it (health, troll, ammo etc)
	private var _entityType				:int;

	// a generic flag
	private var _tag					:Boolean;

	// this is the next valid id. each time a game entity
	// is created this value is updated
	private static var nextValidID		:int;

	// it's 2D location in the environment
	private var _pos                  	:Point;

	private var _scale					:Point;

	private var _boundingRadius			:Number;

	//--------------------------------------------

	public function BaseGameEntity(pos:Point, radius:Number)
	{
		_ID = BaseGameEntity.nextValidID++;
		_entityType = 1;
		_tag = false;
		_pos = pos;
		_scale = new Point(1, 1);
		_boundingRadius = radius;

	}

	public function get ID():int
	{
		return _ID;
	}

	public function update():void
	{
	}

	public function render():void
	{
	}


	public function get pos():Point
	{
		return _pos;
	}

	public function set pos(value:Point):void
	{
		_pos = value;
	}

	public function get boundingRadius():Number
	{
		return _boundingRadius;
	}

	public function set boundingRadius(value:Number):void
	{
		_boundingRadius = value;
	}

	public function get scale():Point
	{
		return _scale;
	}

	public function set scale(value:Point):void
	{
		_boundingRadius *= (Math.max(value.x, value.y) / Math.max(_scale.x, _scale.y));
		_scale = value;
	}

	public function get tag():Boolean
	{
		return _tag;
	}

	public function set tag(value:Boolean):void
	{
		_tag = value;
	}
}
}
