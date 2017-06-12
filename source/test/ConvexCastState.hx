package test;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.nape.FlxNapeSpace;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import nape.geom.ConvexResult;
import nape.geom.ConvexResultList;
import nape.phys.Body;
import nape.space.Space;
import system.Settings;

/**
 * ...
 * @author Jonathan Snyder
 */
class ConvexCastState extends FlxState {
	var c:TestCircle;
	var result:ConvexResultList;
	var stepper:Body;
	var raySpr:FlxSprite;
	var stepperSpace:Space;
	var space:Space;

	override public function create():Void {
		super.create();
		
		
		raySpr = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		add(raySpr);
		
		FlxNapeSpace.init();
		FlxNapeSpace.space.gravity.y = 3000;
		FlxNapeSpace.createWalls();
		Settings.space = space = FlxNapeSpace.space;
		
		c = new TestCircle(FlxG.width / 2, FlxG.height / 2);
		add(c);
		
		
		#if DRAW_DEBUG
		FlxG.debugger.visible = true;
		
		FlxNapeSpace.drawDebug = true;
		//FlxNapeSpace.shapeDebug.
		
		
		add(new DragThrowController(FlxNapeSpace.space, null, false));
		#end
	}
	
	
	override public function update(elapsed:Float):Void {
		
		/**
		 * Do a Convext multi cast
		 */
		if (FlxG.keys.justPressed.SPACE) {
			pause();
			
			stepper = c.body.copy();
			//stepper.space = Settings.space;
			
			stepperSpace = new Space(Settings.space.gravity);
			stepperSpace.worldAngularDrag = Settings.space.worldAngularDrag;
			stepperSpace.worldLinearDrag = Settings.space.worldLinearDrag;
			stepper.space = stepperSpace;
			
			
			if (result == null) {
				result = new ConvexResultList();
			} else {
				result.clear();
			}
			
			
			var r:ConvexResult = result.at(0);
			var totalTime:Float = r.toi;
			var totalIterations:Int = 20;


			for (i in 0...totalIterations) {
				stepperSpace.step(elapsed, FlxNapeSpace.velocityIterations, FlxNapeSpace.positionIterations);

				FlxSpriteUtil.drawCircle(raySpr, stepper.position.x, stepper.position.y, c._shape.radius);
			}
			trace(totalTime);


			#if FLX_DEBUG
			FlxG.console.registerObject("result", result);
			FlxG.console.registerObject("stepper", stepper);
			//DataSaver.serializeToFile(result, "../../../../info.json", true, false);

			#end
		}
		
		
		super.update(elapsed);
	}
	
	
	public function pause():Void {
		FlxNapeSpace.space = null;
	}
	
	public function resume():Void {
		FlxNapeSpace.space = Settings.space;
	}
}