package com.struts.utils
{

import flash.geom.Point;


/**
 *
 * 几何算法工具类
 *  
 * @author ZhouHan
 * 
 */
public class GeometryUtil
{
//	/**
//	 * 
//	 * 求三点连接后，两线之间的夹角中心角度
//	 *  
//	 * @param sp  开始点
//	 * @param mp  中间点
//	 * @param ep  结束点
//	 * @return 
//	 * 
//	 */		
//	public static function getAngleByThreePoint(sp : Point,mp : Point,ep : Point) : Number
//	{
//		var sAngle : Number = getAngle(mp,sp);
//		var eAngle : Number = getAngle(mp,ep);
//		
//		var offsetAngle : Number = Math.abs(sAngle-eAngle);
//		var mAngle : Number = offsetAngle / 2;
//		var angle : Number = Math.min(sAngle,eAngle) + mAngle;
//		
//		if(offsetAngle > 180)
//			angle = angle + 180;
//		
//		return angle;
//		
//	}
	
	/**
	 * 
	 * 根据x,y的中心圆点坐标，r为半径，得到角度为angle的坐标点
	 *  
	 * @param x     圆心X 坐标
	 * @param y     圆心y 坐标
	 * @param r     半径
	 * @param angle 角度
	 * @return 
	 * 
	 */		
	public static function getPointByAngle(x:Number, y:Number,r:Number,angle:Number) : Point
	{
		angle = angle * Math.PI / 180;
		return new Point(x + r * Math.cos(angle),y + r * Math.sin(angle));			
	}
	
	
	/**
	 *
	 * 根据中心点 x，y；半径r和R；角度angle，返回r和R分别对应的坐标点
	 * 
	 *  
	 * @param x
	 * @param y
	 * @param r
	 * @param R
	 * @param angle
	 * @return 
	 * 
	 */		
	public static function getSectorByRadius(x:Number, y:Number, r:Number, R:Number,angle:Number) : Array
	{
		if (Math.abs(angle) > 360)
		{
			angle=360;
		}
		
		angle = angle * Math.PI / 180;
		
		var rPonit : Point = new Point(x + r * Math.cos(angle),y + r * Math.sin(angle));
		var RPonit : Point = new Point(x + R * Math.cos(angle),y + R * Math.sin(angle));
		
		return [rPonit,RPonit];
	}
	
	
	
	/**
	 * 
	 * 获取两点之间的弧度  
	 * 
	 * @param pt     
	 * @param ptCenter  以该点角度
	 * @return 
	 * 
	 */		
	public static function getRotation(ptCenter:Point,pt:Point):Number  
	{  
		var dx:Number = pt.x - ptCenter.x;  
		var dy:Number = pt.y - ptCenter.y;            
		var dis:Number = Math.sqrt(dx*dx + dy*dy);                        
		
		if(dy > 0)  
			return Math.acos(dx/dis);  
		else   
			return (Math.PI*2 - Math.acos(dx/dis));  
	}  
	
	/**
	 * 
	 * 获取两点之间的角度
	 * 
	 * <pre>
	 * 
	 *   弧度=角度*Math.PI/180 
	 *	  角度=弧度*180/Math.PI 
	 * </pre>
	 *  
	 * @param pt
	 * @param ptCenter
	 * @return 
	 * 
	 */		
	public static function getAngle(ptCenter:Point,pt:Point) : Number
	{
		var rotation : Number = getRotation(ptCenter,pt);
		
		return rotation * 180 / Math.PI;
	}
	
	/**
	 *  
	 * 获取两点之间的长度
	 *  
	 * @param sp  起始点
	 * @param ep  结束点
	 * @return 
	 * 
	 */		
	public static function getDist(sp : Point,ep : Point) : Number
	{
		var dx : Number = sp.x - ep.x;
		var dy : Number = sp.y - ep.y;
		
		return Math.sqrt(dx*dx + dy*dy);
	}
	
	/**
	 *  斜截式:y=kx+b
		截距式:x/a+y/b=1
		两点式:(x-x1)/(x2-x1)=(y-y1)/(y2-y1)
		一般式:ax+by+c=0 
     
	 * @return 
	 * 
	 */	
//	public static function getDis() : Number
//	{
//	
//	}
}


}




















