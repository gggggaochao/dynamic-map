package com.struts.interfaces
{
	
import flash.geom.Point;
import flash.geom.Rectangle;


/**
 *
 * 控件的放大、缩小、定位接口
 *  
 * @author ZhouHan
 * 
 */
public interface IZoom
{
	
	/**
	 * 
	 * 
	 * 显示可视区域
	 *  
	 * @return 
	 * 
	 */	
	function get showRect() : Rectangle;
	
	
	/**
	 *  缩放比例
	 * 
	 * */
	function set scale(value : Number) : void;
	function get scale() : Number;
	
	
	function zoomOut() : void;
	
	function zoomIn() : void;
	
	function get centerPoint() : Point;	
	
	/**
	 * 
	 *  画布剧中
	 * 
	 * */
	function toCenter() : void;		
	
	
	/**
	 * 
	 *  画布初始显示状态 
	 * 
	 * */
	function toNormal() : void;
	
	
	
	function toFull() : void;
	
	function centerAt(target : Object = null,showScale : Number = -1) : void;
	
	
	
	
	/**
	 * 
	 * 让画布移动到指定点
	 *  
	 * @param p
	 * 
	 */	
	function moveAtCenter(p : Point) : void 


}
}