package helpers;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.addons.nape.FlxNapeSpace;
import nape.constraint.PivotJoint;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.BodyList;
import nape.space.Space;


/**
 * Enables grabbing and throwing of any dynamic bodies within space
 * @author Jonathan Snyder
 */
class DragThrowController extends FlxBasic {

	public var hand:PivotJoint;
	public var bodyList:BodyList;
	public var space:Space;
	public var filter:InteractionFilter;
	public var dragCenter:Bool;

	//mouse position
	private var mp:Vec2 = Vec2.get();
	private var mousePos:Vec2 = Vec2.get();

	public function new(space:Space, ?filter:InteractionFilter, dragCenter:Bool = true) {
		super();
		this.space = space;
		this.filter = filter;
		this.dragCenter = dragCenter;
		hand = new PivotJoint(space.world, null, Vec2.weak(), Vec2.weak());
		//hand.fre
		hand.active = false;
		hand.stiff = false;
		hand.space = space;
		
	}

	override public function update(elapsed:Float):Void {
		
		
		mousePos.setxy(FlxG.mouse.x, FlxG.mouse.y);
		
		if (FlxG.mouse.justPressed) {
			
			if (FlxNapeSpace.space == null) {
				return;
			}
			
			//FlxNapeSpace.shapeDebug
			mp.set(mousePos);
			bodyList = space.bodiesUnderPoint(mp, filter, bodyList);

			//will only grab the most top one
			for (body in bodyList) {
				if (body.isDynamic()) {
					hand.body2 = body;
					hand.anchor2 = dragCenter ? Vec2.weak() : body.worldPointToLocal(mp, true);
					hand.active = true;
					break;
				}
			}

			// recycle nodes.
			bodyList.clear();
		} else if (FlxG.mouse.justReleased) {
			hand.active = false;
			hand.body2 = null;
		}
		
		if (hand.active && hand.body2.space == null) {
			hand.active = false;
		}
		
		
		if (hand.active) {
			hand.anchor1.set(mousePos);
		}
		super.update(elapsed);
	}

	public function refreshBodyList():Void {
		bodyList.clear();
		space.bodiesUnderPoint(mp, filter, bodyList);
	}

	
	/**
	 * TODO: REMOVE
	 * @return
	 */
	public function filteredBodiesUnderMouse():BodyList {
		mp.set(mousePos);
		return space.bodiesUnderPoint(mp, filter);
	}
}
