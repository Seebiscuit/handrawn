package test;

class test.CannonState extends FlxState {
var circleNapeSprite:FlxNapeSprite;
var testCannon:CannonSprite;


override public function create():Void {
super.create();


FlxNapeSpace.init();
FlxNapeSpace.space.gravity.setxy(10, 1000);

var walls = FlxNapeSpace.createWalls();


var radius:Float = FlxG.width / 10;
circleNapeSprite = new FlxNapeSprite(FlxG.width / 2, FlxG.height / 2, "assets/images/ball.png", true, true);


testCannon = new CannonSprite();
add(testCannon);


testCannon.setPosition(100, 100);


add(circleNapeSprite);


	#if FLX_DEBUG

FlxG.console.registerClass(FlxNapeSpace);

	#end


}


override public function update(elapsed:Float):Void {
super.update(elapsed);
}


override public function destroy():Void {

super.destroy();
}
	
	
}