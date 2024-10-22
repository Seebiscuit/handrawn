package;

#if FLX_DEBUG
import com.goodidea.util.NapeUtil;
import flixel.system.debug.FlxDebugger.FlxDebuggerLayout;
#end

#if android
import extension.wakeLock.WakeLock;
#end

import com.goodidea.util.helpers.DragThrowController;
import display.AutoNapeSprite;
import display.CircleNapeSprite;
import display.HUD;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextFormat;
import flixel.addons.nape.FlxNapeSpace;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import openfl.display.CapsStyle;
import openfl.display.FPS;
import openfl.display.JointStyle;
import openfl.display.LineScaleMode;
import openfl.display.StageQuality;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Lib;
import system.Audio;
import system.Settings;

class MenuState extends FlxState {
	

	//TODO: move these to user settings
	var granularity:Int = 10;
	var thickness:Float = 30;
	var GRAVITY_FACTOR:Float = Settings.gravity.y;

	var drawing:Bool;
	var mousePos:FlxPoint;
	var ls:LineStyle;
	var ds:DrawStyle;
	var walls:Body;
	
	
	var hud:HUD;
	
	
	var bgSpr:FlxSprite;
	var g:Graphics;
	var fps:openfl.display.FPS;
	var drawSpr:Sprite;
	var dragThrowController:DragThrowController;
	public var drawSprite:FlxSprite;
	
	
	override public function create():Void {
		super.create();
		
		
		drawSpr = new Sprite();
		FlxG.addChildBelowMouse(drawSpr);
		drawSpr.scaleX = camera.totalScaleX;
		drawSpr.scaleY = camera.totalScaleY;
		
		camera.antialiasing = true;
		
		FlxG.mouse.useSystemCursor = true;
		FlxG.autoPause = false;
		
		add(bgSpr = new FlxSprite().makeGraphic(camera.width, camera.height, FlxColor.fromString('#804000')));
		fps = new FPS(10, 10, FlxColor.WHITE);
		//fps.defaultTextFormat.size = Std.int(60 / FlxG.camera.totalScaleX);
		fps.defaultTextFormat = new TextFormat("default", 20, FlxColor.WHITE);
		
		FlxG.addChildBelowMouse(fps);
		
		
		FlxNapeSpace.init();
		walls = FlxNapeSpace.createWalls();
		FlxNapeSpace.space.gravity.set(Settings.gravity);
		Settings.space = FlxNapeSpace.space;
		
		Settings.interationAmount = 25;
		trace(FlxNapeSpace.positionIterations + " - " + FlxNapeSpace.velocityIterations);
		
		dragThrowController = new DragThrowController(FlxNapeSpace.space, null, false);
		add(dragThrowController);
		
		add(drawSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT));
		
		ls = FlxSpriteUtil.getDefaultLineStyle();
		ls.thickness = thickness;
		
		
		add(Settings.hud = hud = new HUD());
		
		
		#if FLX_DEBUG
		
		FlxG.debugger.setLayout(FlxDebuggerLayout.RIGHT);
		FlxG.watch.add(DrawSettings, "quality", 'quality');
		FlxG.watch.add(DrawSettings, "simplification", 'simplification');
		
		
		#if (DRAW_DEBUG && desktop)
		FlxNapeSpace.drawDebug = true;
		FlxG.debugger.visible = true;
		#end
		
		
		FlxG.console.autoPause = false;
		
		FlxG.console.registerClass(NapeUtil);
		FlxG.console.registerObject('controller', dragThrowController);
		
		FlxG.watch.add(this, 'granularity', 'granular');
		FlxG.console.registerObject("cam", camera);
		FlxG.console.registerClass(FlxNapeSpace);
		
		#end

	}




	override public function update(elapsed:Float):Void {
		
		super.update(elapsed);
		
		
		#if mobile
		if (FlxG.accelerometer.isSupported) {
			
			
			//Inverting the x axis to align the device and the screen coordinates
			FlxNapeSpace.space.gravity.setxy(FlxG.accelerometer.y * GRAVITY_FACTOR, FlxG.accelerometer.x * GRAVITY_FACTOR);
		}
		#end

		/**
		 * ONLY WHEN RAIN BRUSH IS OFF
		 * When pressed, initiate draw
		 */
		if (FlxG.mouse.justPressed && !hud.rainButton.on) {
			Audio.draw.looped = true;
			Audio.draw.volume = 0;
			Audio.draw.play(true);
			
			///if there are no bodies under the mouse, then init draw. otherwise init object drag and throw
			if (FlxNapeSpace.space.bodiesUnderPoint(Vec2.weak(FlxG.mouse.x, FlxG.mouse.y)).filter(function(b:Body) return b.type != BodyType.STATIC).length == 0) {
				//Settings.togglePhysics();
				drawing = true;

				
				FlxG.stage.quality = StageQuality.LOW;
				FlxG.camera.antialiasing = false;
				
				
				ls.color = FlxG.random.color(FlxColor.fromString("white"), FlxColor.fromString("gray"), 255);
				
				if (mousePos == null) mousePos = FlxPoint.get();

				mousePos.set(drawSpr.mouseX, drawSpr.mouseY);
				
				g = drawSpr.graphics;
				g.lineStyle(ls.thickness, ls.color, 1, false, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND, 3);
				
				g.moveTo(mousePos.x, mousePos.y);
				Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMove);
				Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUp);
			}
			
			
		}
		
		
		/**
		 * for rain
		 */
		if (FlxG.mouse.pressed && hud.rainButton.on && !dragThrowController.hand.active && FlxNapeSpace.space.bodiesUnderPoint(Vec2.weak(FlxG.mouse.x, FlxG.mouse.y)).length == 0) {
			if (!Audio.blip.playing) {
				Audio.blip.looped = true;
				Audio.blip.play(true);
			}
			
			add(new CircleNapeSprite(FlxG.mouse.x, FlxG.mouse.y));
		}
		
		/**
		 * When rain is done
		 */
		if (FlxG.mouse.justReleased && hud.rainButton.on) {
			Audio.blip.stop();
		}
		
		
	}
	
	/**
	 * ONLY WHEN RAIN IS OFF
	 * If drawing, and the mouse has moved
	 * we need to draw a line
	 */
	private function stage_mouseMove(e:MouseEvent):Void {
		g.lineTo(mousePos.x, mousePos.y);
		g.moveTo(mousePos.x, mousePos.y);
		
		
		/**
		 * Distance between to use for controlling draw sound volume
		 */
		var distance:Float = Vec2.distance(Vec2.weak(mousePos.x, mousePos.y), Vec2.weak(drawSpr.mouseX, drawSpr.mouseY));
		Audio.draw.volume = FlxMath.bound(distance / (drawSpr.width / 2), 0, 1);
		
		FlxSpriteUtil.updateSpriteGraphic(drawSprite, {
			smoothing: false
		});
		
		//update current mouse position info
		mousePos.set(drawSpr.mouseX, drawSpr.mouseY);
		
		e.updateAfterEvent();
	}
	
	/**
	 * ONLY WHEN RAIN IS OFF
	 * Stop drawing when mouse is released
	 */
	private function stage_mouseUp(e:MouseEvent):Void {
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMove);
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUp);
		drawing = false;
		
		Audio.draw.stop();

		FlxG.stage.quality = StageQuality.BEST;
		FlxG.camera.antialiasing = true;
		//Settings.togglePhysics(false);
		//create body from trimmed bitmap
		extractDrawing();


		g.clear();

		
	}
	
	
	private function extractDrawing() {
		
		//var t = Lib.getTimer();
		drawSprite.pixels.draw(drawSpr);
		//get bounds of non-transparent pixels
		//exit if bounds is empty.
		var bounds = drawSprite.pixels.getColorBoundsRect(0xFF000000, 0x00000000, false);
		if (bounds.isEmpty()) {
			trace("bounds are empty, dont do anything");
			return;
		}
		
		
		var trimmed:BitmapData = new BitmapData(Std.int(bounds.width), Std.int(bounds.height), true, 0x80);
		trimmed.copyPixels(drawSprite.pixels, bounds, new Point());
		
		drawSprite.pixels.fillRect(new Rectangle(0, 0, drawSprite.width, drawSprite.height), 0x80);

		var spr:AutoNapeSprite = new AutoNapeSprite(bounds.x, bounds.y, trimmed, granularity, true, Settings.hud.stickyButton.on);
		
		//set a default material
		spr.body.setShapeMaterials(Settings.material);
		add(spr);
	}
	
	public inline function clearAdded():Void {
		forEachOfType(AutoNapeSprite, function(s:AutoNapeSprite) s.destroy());
	}
	
	
	override public function onResize(Width:Int, Height:Int):Void {
		super.onResize(Width, Height);

		bgSpr.makeGraphic(FlxG.width, FlxG.height, FlxColor.fromString('#2b3044'));
		
		walls.space = null;
		walls = null;
		walls = FlxNapeSpace.createWalls();

		drawSprite.makeGraphic(Std.int(Width / FlxG.scaleMode.scale.x), Std.int(Height / FlxG.scaleMode.scale.y), FlxColor.TRANSPARENT);

		drawSpr.x = drawSpr.y = 0;
		drawSpr.scaleX = FlxG.scaleMode.scale.x;
		drawSpr.scaleY = FlxG.scaleMode.scale.y;
		
	}
}
