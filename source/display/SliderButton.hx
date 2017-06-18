package display;

/**
 * ...
 * @author Jonathan Snyder
 */
class SliderButton extends UIButton
{

	public function new(AssetName:Dynamic, ?onClick:Function, ?onClickParams:Array<Dynamic>) 
	{
		super(AssetName,"splash", onClick, onClickParams);
		
	}
	
}