package com.goodidea.util;

/**
 * ...
 * @author Jonathan Snyder
 */
import flash.display.Bitmap;
import flash.display.BitmapData;
import nape.geom.AABB;
import nape.geom.GeomPolyList;
import nape.geom.IsoFunction.IsoFunctionDef;
import nape.geom.MarchingSquares;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.shape.Polygon;


class NapeUtil {

	//public static var bitmapIso:BitmapDataIso;
	
	public static function bitmapToBody(bd:BitmapData, granularity:Int = 8, quality:Int = 2, simplification:Float = 1.5):Body {
		var bitmapIso:BitmapDataIso = new BitmapDataIso(bd, 0x80);
		
		#if !flash
		return IsoBody.run(bitmapIso.iso, bitmapIso.bounds, Vec2.weak(granularity, granularity), quality, simplification);
		#else
		return IsoBody.run(bitmapIso, bitmapIso.bounds, Vec2.weak(granularity, granularity), quality, simplification);
		#end
	}
	
}


class BitmapDataIso #if flash implements nape.geom.IsoFunction #end {
	public var bitmap:BitmapData;
	public var alphaThreshold:Float;
	public var bounds:AABB;
	
	
	public function new(bitmap:BitmapData, alphaThreshold:Float = 0x80) {
		this.bitmap = bitmap;
		this.alphaThreshold = alphaThreshold;
		bounds = new AABB(0, 0, bitmap.width, bitmap.height);
		
	}
	
	
	public function graphic():Bitmap {
		return new Bitmap(bitmap);
	}
	
	
	public function iso(x:Float, y:Float) {
		/**
		 * Take 4 nearest pixels to interpolate linearly.
		 * This gives us a smooth iso-function for which we
		 * can use a lower quality in MarchingSquares for the root finding.
		 */
		

		var ix:Int = Std.int(x);
		var iy:Int = Std.int(y);

		//clamp in-case of numerical inaccuracies
		if (ix < 0) ix = 0; if (iy < 0) iy = 0;
		if (ix > bitmap.width) ix = bitmap.width - 1;
		if (iy > bitmap.height) iy = bitmap.height - 1;

		//iso-function values at each pixel center
		var a11 = alphaThreshold - (bitmap.getPixel32(ix, iy) >>> 24);
		var a12 = alphaThreshold - (bitmap.getPixel32(ix + 1, iy) >>> 24);
		var a21 = alphaThreshold - (bitmap.getPixel32(ix, iy + 1) >>> 24);
		var a22 = alphaThreshold - (bitmap.getPixel32(ix + 1, iy + 1) >>> 24);

		//Bilinear interpolation for sample point (x,y)
		var fx = x - ix;
		var fy = y - iy;

		return a11 * (1 - fx) * (1 - fy) + a12 * fx * (1 - fy) + a21 * (1 - fx) * fy + a22 * fx * fy;


	}
	
	
}


class IsoBody {
	public static function run(iso:IsoFunctionDef, bounds:AABB, ?granularity:Vec2, quality:Int = 2, simplification:Float = 1.5):Body {
		var body:Body = new Body();
		
		if (granularity == null) granularity = Vec2.weak(8, 8);

		var polys = MarchingSquares.run(iso, bounds, granularity, quality);
		for (p in polys) {

			var qolys:GeomPolyList = p.simplify(simplification).convexDecomposition(true);

			for (q in qolys) {
				body.shapes.add(new Polygon(q));
				//Recycle GeomPoly and it's vertices
				q.dispose();
			}
			
			//Recylce the list nodes
			qolys.clear();
			
			//Recycle GeomPoly and it's vertices
			p.dispose();


		}

		polys.clear();
		
		/**
		 * If there are no shapes
		 * return a null object
		 */
		if (body.shapes.length == 0) return null;
		
		/**
		 * Align body with it's center of mass.
		 * Keeping track of our required graphic offset
		 */
		var pivot = body.localCOM.copy();
		//body.translateShapes(pivot);
		body.userData.graphicOffset = pivot;
		body.align();
		
		return body;
	}
}