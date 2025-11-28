package com.struts.utils
{
import flash.display.BitmapData;
import flash.display.CapsStyle;
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.LineScaleMode;
import flash.display.Shape;
import flash.geom.Matrix;
import flash.geom.Point;

import mx.core.INavigatorContent;
	
	public final class DrawUtil
	{	   	
		/**
		 * 绘制虚线线条
		 * 
		 * 
		 * @param graphics  绘制对象
		 * @param fP   开始点坐标
		 * @param tP   结束点坐标
		 * @param dashlen  单线长度
		 * @param gaplen    间隔长度
		 * @param linethickness
		 * @param linecolor
		 * @param linealpha
		 * 
		 */		
	    public static function drawLineByDashlen(graphics:Graphics,fP:Point,tP:Point,dashlen:Number=3, gaplen:Number=1,
												 linethickness : Number = 1,
												 linecolor : Number = 0xEAEAEA,
												 linealpha : Number = 1) : void
	    {    
	    	 var x1 : Number = fP.x;
	    	 var y1 : Number = fP.y;
	    	 var x2 : Number = tP.x;
	    	 var y2 : Number = tP.y;
	         if((x1 != x2) || (y1 != y2))
	         {
		          var incrlen:Number = dashlen + gaplen;
		          var len:Number = Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
		          var angle:Number = Math.atan((y2 - y1) / (x2 - x1));
		          var steps:uint = len / (dashlen + gaplen);
		          var dashstepx:Number = dashlen * Math.cos(angle);
		          if(x2 < x1)
		              dashstepx *= -1;

		          var dashstepy:Number = dashlen * Math.sin(angle);
		          var gapstepx:Number = gaplen * Math.cos(angle);
		          
		          if (x2 < x1)
		              gapstepx *= -1;
		          
		          var gapstepy:Number = gaplen * Math.sin(angle);
		          var stepcount:uint = 0;
				  
				  graphics.lineStyle(linethickness, linecolor,linealpha,false,LineScaleMode.NONE);
		          while((stepcount++) <= steps)
		          {       
		              var dashstartx:Number;
		              var dashstarty:Number;
		              var dashendx:Number;
		              var dashendy:Number;
					  
		              if(x1 == x2 && y1 != y2)
		              {
		                  dashstartx = dashendx = x1;
		                  if(y2 > y1)
		                  {
		                      dashstarty = y1 + ((stepcount-1) * (dashlen + gaplen));             
		                      dashendy = dashstarty + dashlen;
		                  }
		                  else
		                  {
		                      dashstarty = y1 - ((stepcount-1) * (dashlen + gaplen));             
		                      dashendy = dashstarty - dashlen;
		                  }
		              }
		              else if(y1 == y2 && x1 != x2)
		              {
		                  dashstarty = dashendy = y1;
		                  if(x2 > x1)
		                  {
		                      dashstartx = x1 + ((stepcount-1) * (dashlen + gaplen));
		                      dashendx = dashstartx + dashlen;
		                  }
		                  else
		                  {
		                      dashstartx = x1 - ((stepcount-1) * (dashlen + gaplen));
		                      dashendx = dashstartx - dashlen;
		                  }
		               }	   
					  
//					   dashendx = stepcount != steps ? dashendx : tP.x;
//					   dashendy = stepcount != steps ? dashendy : tP.y;
  
					   graphics.moveTo(dashstartx, dashstarty);
					   graphics.lineTo(dashendx, dashendy);
		               
		               graphics.endFill();
		          }
	         }
	     }
	     
		
		/**
		 * 绘制虚线线条   比 方法 drawLineByDashlen 速度快。
		 * 
		 * 
		 * @param graphics  绘制对象
		 * @param fP   开始点坐标
		 * @param tP   结束点坐标
		 * @param dashlen  单线长度
		 * @param gaplen    间隔长度
		 * @param linethickness
		 * @param linecolor
		 * @param linealpha
		 * 
		 */			
	    public static function drawFreeLine(graphics : Graphics,fP:Point,tP:Point,
											dashlen:Number=3,
											gaplen:Number=1,
											linethickness : Number = 1,
											linecolor : Number = 0xEAEAEA,
											linealpha : Number = 1):void 
		{  
			 graphics.lineStyle(linethickness, linecolor,linealpha,false,LineScaleMode.NONE,CapsStyle.SQUARE);
			 //计算两点之间的角度
             var lineAngle:Number = Math.atan2(tP.y - fP.y,tP.x - fP.x) * 180 / Math.PI;  
			 
			 var len:Number = GeometryUtil.getDist(fP,tP);
			 
			 var slen : uint = 0;
			 var elen : uint = dashlen;
			 
			 var formPoint : Point = new Point(fP.x,fP.y);
			 var toPoint : Point = GeometryUtil.getPointByAngle(fP.x,fP.y,elen,lineAngle);
			 
			 
			 while(true)
			 {

				 graphics.moveTo(formPoint.x, formPoint.y);  
				 graphics.lineTo(toPoint.x, toPoint.y);
				 
				 
				 slen = elen + gaplen;
				 
				 if(slen >= len)
					 break;
				 
				 formPoint = GeometryUtil.getPointByAngle(fP.x,fP.y,slen,lineAngle);
				 
				 elen = slen + dashlen;
			     
				 
				 if(elen >= len)
				 {
					 toPoint = GeometryUtil.getPointByAngle(fP.x,fP.y,len,lineAngle);
					 graphics.moveTo(formPoint.x, formPoint.y);  
					 graphics.lineTo(toPoint.x, toPoint.y);
					 break;
				 }
				 
				 toPoint = GeometryUtil.getPointByAngle(fP.x,fP.y,elen,lineAngle);
				 			 
			 }
         } 
		
		
		
		/**
		 *
		 * 绘制多段线
		 *  
		 * @param graphics   绘制对象
		 * @param toPs       点集合
		 * @param linethickness
		 * @param linecolor
		 * @param linealpha
		 * 
		 */		
		public static function drawPolyline(graphics : Graphics,ps : Array,
											linethickness : Number = 1,
											linecolor : Number = 0xEAEAEA,
											linealpha : Number = 1) : void
		{
			if(ps && ps.length > 1)
			{	
				graphics.lineStyle(linethickness, linecolor,linealpha,false,LineScaleMode.NONE,CapsStyle.SQUARE);
				graphics.moveTo(ps[0].x,ps[0].y);
				for (var i : Number = 1;i<ps.length;i++)
				{
					graphics.lineTo(ps[i].x,ps[i].y);
				}
				graphics.moveTo(ps[0].x,ps[0].y);
			}			
		}
		
		/**
		 * 
		 * 绘制带圆角的多段线
		 *  
		 * @param graphics
		 * @param toPs
		 * @param round
		 * @param linethickness
		 * @param linecolor
		 * @param linealpha
		 * 
		 */		
		public static function drawPolyLineRound(graphics : Graphics,ps : Array,
												 round : Number = 5,
												 linethickness : Number = 1,
												 linecolor : Number = 0xEAEAEA,
												 linealpha : Number = 1) : void
		{
		
			var psCount : int = ps.length;
			if(psCount<2)
				return;
			
			var index : int = 1;
			var sp : Point = ps[0];
			var mp : Point;
			var ep : Point;
			
			var dist : Number;
			var drawDist : Number;
			var angle : Number;
			
			var drawPonits : Array = new Array();
			graphics.lineStyle(linethickness, linecolor,linealpha,false,LineScaleMode.NONE,CapsStyle.SQUARE);
			graphics.moveTo(sp.x,sp.y);
			for (var i : int = 1;i<psCount - 1;i++)
			{
				sp = ps[i - 1];
				mp = ps[i];
				ep = ps[i+1];

				dist = GeometryUtil.getDist(sp,mp);
				drawDist = dist - round;
				angle = GeometryUtil.getAngle(sp,mp);
				var p1 : Point = GeometryUtil.getPointByAngle(sp.x,sp.y,drawDist,angle);
				
				dist = GeometryUtil.getDist(ep,mp);
				drawDist = dist - round;
				angle = GeometryUtil.getAngle(ep,mp);
				var p2 : Point = GeometryUtil.getPointByAngle(ep.x,ep.y,drawDist,angle);
				
				var drawBean : Object = {s : p1,e : p2};
				drawPonits.push();
				graphics.lineTo(p1.x,p1.y);
				graphics.curveTo(mp.x,mp.y,p2.x,p2.y);
				//graphics.lineTo(ep.x,ep.y);
			}
			ep = ps[psCount-1];
			graphics.lineTo(ep.x,ep.y);
		}
		

		
		
		/**
		 *
		 * 绘制虚线多段线
		 *  
		 * @param graphics   绘制对象
		 * @param toPs       点集合
		 * @param linethickness
		 * @param linecolor
		 * @param linealpha
		 * @param dashlen  单线长度
		 * @param gaplen    间隔长度
		 */	
		public static function drawPolyDashline(graphics : Graphics,toPs : Array,
											linethickness : Number = 1,
											linecolor : Number = 0xEAEAEA,
											linealpha : Number = 1,
											dashlen:Number=3,
											gaplen:Number=1) : void
		{
			
			if(toPs && toPs.length > 1)
			{	
				graphics.lineStyle(linethickness, linecolor,linealpha,false,LineScaleMode.NONE,CapsStyle.NONE);
				
				var fP : Point = new Point(toPs[0].x,toPs[0].y);
				var tP : Point;
				
				var lineAngle:Number;
				var len:Number; 
				
				var slen : uint;
				var elen : uint;
				
				var isGap : Boolean = false;
				var surlen : Number = 0;
				
				var formPoint : Point;
				var toPoint : Point;
				
				for (var i : Number = 1;i<toPs.length;i++)
				{
					tP = new Point(toPs[i].x,toPs[i].y);
					
					
					drawFreeLine(graphics,fP,tP,dashlen,gaplen,linethickness,linecolor,linealpha);
//					lineAngle = Math.atan2(tP.y - fP.y,tP.x - fP.x) * 180 / Math.PI;  
//					
//					len = GeometryUtil.getDist(fP,tP);
//					
//					if(surlen == 0)
//					{
//						slen = 0;
//						elen = dashlen;
//					}
//					else
//					{
//						slen = isGap ? surlen : 0;
//						elen = isGap ? dashlen : surlen;						
//					}
//					
//					formPoint = slen ? GeometryUtil.getPointByAngle(fP.x,fP.y,slen,lineAngle) : new Point(fP.x,fP.y); 
//					toPoint = GeometryUtil.getPointByAngle(fP.x,fP.y,elen,lineAngle);
//					
//					
//					while(true)
//					{
//						
//						graphics.moveTo(formPoint.x, formPoint.y);  
//						graphics.lineTo(toPoint.x, toPoint.y);
//						
//						
//						slen = elen + gaplen;
//						
//						if(slen >= len)
//						{
//							isGap = true;
//							surlen = slen - len;
//							break;
//						}
//						
//						formPoint = GeometryUtil.getPointByAngle(fP.x,fP.y,slen,lineAngle);
//						
//						elen = slen + dashlen;
//						
//						
//						if(elen >= len)
//						{
//							toPoint = GeometryUtil.getPointByAngle(fP.x,fP.y,len,lineAngle);
//							graphics.moveTo(formPoint.x, formPoint.y);  
//							graphics.lineTo(toPoint.x, toPoint.y);
//							
//							isGap = false;
//							surlen = elen - len;
//							break;
//						}
//						
//						toPoint = GeometryUtil.getPointByAngle(fP.x,fP.y,elen,lineAngle);
//						
//					}
//					
					fP = tP;
				}
			}			
		}
		
		
		/**
		 *
		 * 绘制格子
		 *  
		 * @param graphics
		 * @param w
		 * @param h
		 * @param distance
		 * @param index
		 * @param linecolor
		 * @param linethickness
		 * @param indexLinecolor
		 * @param indexLinethickness
		 * 
		 */		
		public static function drawGrid(graphics : Graphics,w : Number,h : Number,
										distance : Number = 10,
										index : Number = 5,
										linecolor : Number = 0xEAEAEA,
										linethickness : Number = 1,
										indexLinecolor : Number = 0xEAEAEA,
										indexLinethickness : Number = 2) : void
		{
			var HCount : Number = Math.floor(h / distance);
			var VCount : Number = Math.floor(w / distance);
			var _fromX : Number = 0;
			var _fromY : Number = 0;
			var _toX : Number = 0;
			var _toY : Number = 0;
			var i : Number = 0;
			
			for(i = 1;i<=HCount;i++)
			{
				if(i % index == 0 )
				{
					graphics.lineStyle(indexLinethickness, indexLinecolor,1,false,LineScaleMode.NONE);
				}
				else
				{
					graphics.lineStyle(linethickness, linecolor,1,false,LineScaleMode.NONE);
				}
				
				_fromY += distance;
				_toY += distance;
				_toX = w;
				graphics.moveTo(_fromX,_fromY);
				graphics.lineTo(_toX, _toY);
				
			}
			
			_fromX = _fromY = _toX = _toY = 0;
			for(i = 1;i<=VCount;i++)
			{
				if(i % index == 0 )
				{
					graphics.lineStyle(indexLinethickness, indexLinecolor);
				}
				else
				{
					graphics.lineStyle(linethickness, linecolor);
				}
				
				_toX += distance;
				_fromX += distance;
				_toY = h;
				graphics.moveTo(_fromX,_fromY);
				graphics.lineTo(_toX, _toY);
				
			}			
			
		}
		
		/**
		 *  绘制线段
		 *  
		 * @param graphics
		 * @param fromP
		 * @param toP
		 * @param linethickness
		 * @param linecolor
		 * @param linealpha
		 * 
		 */		
		public static function drawLine(graphics : Graphics,fromP : Point,toP : Point,
										linethickness : Number = 1,
										linecolor : Number = 0xEAEAEA,
										linealpha : Number = 1) : void
		{
			graphics.lineStyle(linethickness, linecolor,linealpha);
			graphics.moveTo(fromP.x,fromP.y);	
			graphics.lineTo(toP.x, toP.y);		
		}		
		
		

		
		/**
		 *
		 * 扇形绘制
		 * 以 x,y为中心圆点，startA 为起始角度，旋转angle后，将绘制扇形区域
		 *  
		 * @param graphics Graphics   
		 * @param x     圆心X 坐标
		 * @param y     圆心y 坐标
		 * @param r     内圆半径
		 * @param R     外圆半径
		 * @param angle     旋转角度
		 * @param startA    开始绘制的角度
		 * @param linethickness  线条宽度
		 * @param linecolor    线条颜色
		 * @param fillcolor    填充颜色
		 * @param fillalpha    填充透明度
		 * 
		 */
		public static function drawSector(graphics : Graphics,x:Number, y:Number, r:Number, R:Number, angle:Number, startA:Number,
				linethickness : Number = 1,linecolor : Number = 0xEAEAEA,fillcolor : Number = 0x999999,fillalpha : Number = 1) : void
		{
		        //graphics.clear();
		        	            
				graphics.lineStyle(linethickness, linecolor);
				graphics.beginFill(fillcolor, fillalpha);
	
				if (Math.abs(angle) > 360)
				{
					angle=360;
				}
				var n:Number = Math.ceil(Math.abs(angle) / 45);
				var angleA:Number=angle / n;
				angleA = angleA * Math.PI / 180;
				startA = startA * Math.PI / 180;
				var startB:Number = startA;
				
				
//				var addAngle  : Number = angle;
//				var centerStart : Number = startA + addAngle;
//				var centerR : Number = r + ( R - r ) / 2; 
//				var center : Point = new Point(x + centerR * Math.cos(centerStart),
//											   y + centerR * Math.sin(centerStart));
				
				//起始边
				graphics.moveTo(x + r * Math.cos(startA), y + r * Math.sin(startA));
				graphics.lineTo(x + R * Math.cos(startA), y + R * Math.sin(startA));
				//外圆弧
				for (var i:uint=1; i <= n; i++)
				{
					startA += angleA;
					var angleMid1:Number=startA - angleA / 2;
					var bx:Number = x + R / Math.cos(angleA / 2) * Math.cos(angleMid1);
					var by:Number = y + R / Math.cos(angleA / 2) * Math.sin(angleMid1);
					var cx:Number = x + R * Math.cos(startA);
					var cy:Number = y + R * Math.sin(startA);
					graphics.curveTo(bx, by, cx, cy);
				}
				//内圆起点
				graphics.lineTo(x + r * Math.cos(startA),y + r * Math.sin(startA));
				//内圆弧
				for (var j:uint = n; j >= 1; j--)
				{
					startA-= angleA;
					var angleMid2:Number=startA + angleA / 2;
					var bx2:Number=x + r / Math.cos(angleA / 2) * Math.cos(angleMid2);
					var by2:Number=y + r / Math.cos(angleA / 2) * Math.sin(angleMid2);
					var cx2:Number=x + r * Math.cos(startA);
					var cy2:Number=y + r * Math.sin(startA);
					graphics.curveTo(bx2, by2, cx2, cy2);
				}
				//内圆终点
				graphics.lineTo(x + r * Math.cos(startB),y + r * Math.sin(startB));
				//完成填充
				graphics.endFill();	
				
				//return center;
		}
		
		
		/**
		 *
		 * 扇形线条绘制
		 * 
		 * <p>
		 * 以 x,y为中心圆点，angle 为绘制角度，将绘制从r到R 的线条
		 * </p> 
		 * 
		 * @param graphics Graphics   
		 * @param x     圆心X 坐标
		 * @param y     圆心y 坐标
		 * @param r     内圆半径
		 * @param R     外圆半径
		 * @param angle     旋转角度
		 * @param startA    开始绘制的角度
		 * @param linethickness  线条宽度
		 * @param linecolor    线条颜色
		 * 
		 * @return Object  起始点和结束点 
		 *                 {start : startPonit,end : endPonit}
		 * 
		 */
		
		public static function drawSectorLine(graphics : Graphics,x:Number, y:Number, r:Number, R:Number, 
											  angle:Number,linethickness : Number = 1,linecolor : Number = 0xEAEAEA,linealpha : Number = 1) : void
		{
			       
				var points : Array = GeometryUtil.getSectorByRadius(x,y,r,R,angle);				
				var startPonit : Point = points[0];
				var endPonit : Point = points[1];
				
				graphics.lineStyle(linethickness, linecolor,linealpha,false,LineScaleMode.NONE);
				graphics.moveTo(startPonit.x,startPonit.y);
				graphics.lineTo(endPonit.x,endPonit.y);
				graphics.endFill();	
				
		}
		
		
		/**
		 * 
		 *  绘制虚线多段线
		 * 
		 * 
		 * */
		public static function drawDashPolyline(graphics : Graphics,pts : Array,
												thickness : Number = 1,
												color : Number = 0xEAEAEA,
												alpha : Number = 1,
												dashlen:Number=3,
												gaplen:Number=1) : void
		{
			
			drawPolyDashline(graphics,pts,thickness,color,alpha,dashlen,gaplen);		
		}
		
		/**
		 *   绘制实线圆形
		 * 
		 * */
		public static function drawCircle(graphics : Graphics,x : Number,y : Number,r : Number,
										  thickness : Number = 1,color : Number = 0x000000,alpha : Number = 1,
										  fillColor : Number = 0xededed,fillAlpha : Number = 1) : void
		{
			if(graphics)
			{
				graphics.lineStyle(thickness,color,alpha,false,LineScaleMode.NONE);
				graphics.beginFill(fillColor,fillAlpha);
				graphics.drawCircle(x,y,r);
				graphics.endFill();	
			}
		}
		
		/**
		 *
		 * 绘制虚线 
		 *  
		 * <p>
		 *  这种方法绘制虚线效率很高，算法复杂度与虚线样式无关；但是当线宽设置较大时，效果比较差，请根据实际情况进行取舍。
		 * </p>
		 * 
		 * @param graphics  绘制对象 
		 * @param pts  折线点数组  
		 * @param lengths  实线，虚线的长度数组。格式为实线长度，虚线长度，实线长度，虚线长度
		 * @param thickness 线宽
		 * @param color 线色  
		 * @param alpha  透明度 
		 * 
		 */		
		public static function drawDashedPolyline(graphics:Graphics,pts:Array,
												  lengths:Array,
												  thickness:Number = 1,color:uint = 0x999999,alpha:Number = 1):void  
		{  
			//点数小于2，则返回  
			var len:int = pts.length;  
			if(len < 2) return;            
			
			var bmData:BitmapData = getDashedElementBitMapData(lengths,thickness,color,alpha);//获取虚线配置单元          
			var sumLength:Number = 0;//累积长度  
			var surplus:Number;//虚线单元配置后多余的长度         
			graphics.moveTo(pts[0].x,pts[0].y);  
			for(var i:int = 1; i < len;i++)  
			{  
				surplus = sumLength % bmData.width;  
				sumLength += Point.distance(pts[i-1],pts[i]);  
				var matrix:Matrix = new Matrix();  
				matrix.translate(-surplus,bmData.height/2);//先去除虚线配置后多余的长度    
				matrix.rotate(GeometryUtil.getRotation(pts[i-1],pts[i]));//旋转到线段前行方向  
				matrix.translate(pts[i-1].x,pts[i-1].y);//平移到线段的起点处  
				
				graphics.lineStyle(thickness);//设置线宽  
				graphics.lineBitmapStyle(bmData,matrix);//配置虚线单元                 
				graphics.lineTo(pts[i].x,pts[i].y);//绘制线段    
			}  
		} 
		
		/**
		 * 
		 * 获取虚线配置单元  
		 * 
		 * 
		 * */  
		private static function getDashedElementBitMapData(lengths:Array,width:Number,color:uint,alpha:Number = 1):BitmapData  
		{  
			var sum:Number = 0;  
			var len:int = lengths.length;  
			var shp:Shape = new Shape();  
			var g:Graphics = shp.graphics;            
			for(var i:int = 0; i < len;i++)  
			{  
				if(i%2 == 0)//绘制实线部分，这里端点样式需采用CapsStyle.NONE；线宽乘以2，是为了避免旋转可能出现的空白  
				{  
					g.lineStyle(width*2,color,alpha,false,"none",CapsStyle.NONE);  
					g.moveTo(sum,width);  
					sum += lengths[i];  
					g.lineTo(sum,width);                                      
				}  
				else  
					sum += lengths[i];  
			}         
			var bd:BitmapData = new BitmapData(sum,width*2,true,0x00FFFFFF);//空白处为透明  
			bd.draw(shp);  
			return bd;  
		}  
		
		

		
		/**
		 * 
		 *   绘制虚线圆形
		 * 
		 *  graphics  : 绘制对象  
		 *  x         : 圆点x坐标    
		 *  y         : 圆点y坐标  
		 *  thickness : 线宽  
		 *  color     : 线色  
		 *  alpha     : 透明度   
		 *  
		 * */
		public static function drawDashLineCircle(graphics : Graphics,x : Number,y : Number,r : Number,
												  thickness : Number = 1,color : Number = 0xEAEAEA,alpha : Number = 1,
												  dashAngle : Number = 20,
												  gapAngle : Number = 40) : void	
			
		{
			
			var angle : Number = 360;
			var startA : Number = 0;
			
			drawDashArc(graphics,x,y,r,startA,angle,thickness,color,alpha,dashAngle,gapAngle);	
		}
		
		
		public static function drawDashArc(graphics : Graphics,
										   x : Number,y : Number,
										   r : Number,
										   startA : Number = 0,angle : Number = 360,
										   dashAngle : Number = 20,
										   gapAngle : Number = 40,
										   thickness : Number = 1,color : Number = 0xEAEAEA,alpha : Number = 1) : void
		{
			var addAngle : Number =  360 / 60 * dashAngle / 60;
			var addGap : Number = 360 / 60 * gapAngle / 60;
			
			var eAngle : Number = 0;
			while(startA <= angle)
			{
				if((startA + addAngle) > angle)
					addAngle = addAngle - ((startA + addAngle) - angle);
				
				drawArc(graphics,x,y,r,addAngle,startA,thickness,color,alpha);
				
				startA = startA + addAngle + addGap;
				

			}	
		}
		
		/**
		 * 
		 *   绘制圆形虚点
		 * 
		 *  graphics  : 绘制对象  
		 *  x         : 圆点x坐标    
		 *  y         : 圆点y坐标  
		 *  thickness : 线宽  
		 *  color     : 线色  
		 *  alpha     : 透明度   
		 *  
		 * */
		public static function drawDashPointCircle(graphics : Graphics,x : Number,y : Number,r : Number,
												   thickness : Number = 1,color : Number = 0x000000,alpha : Number = 1,
												   dashAngle : Number =4,
												   gapAngle : Number = 6,
												   fillColor : Number = 0xededed,fillAlpha : Number = 1) : void	
			
		{
			
			var angle : Number = 360;
			var startA : Number = 0;
			
			var addAngle : Number =   dashAngle;
			var addGap : Number =  gapAngle;
			while(startA < 360)
			{
				drawDashPoint(graphics,x,y,r,addAngle,startA,thickness,color,alpha,fillColor,fillAlpha);
				
				startA = startA + addAngle + addGap;
			}	
		}
		
		
		/**
		 *
		 * 在指定的角度上，半径为r上，绘制大小为size的圆
		 * 
		 *  
		 * @param graphics
		 * @param x
		 * @param y
		 * @param r
		 * @param startA
		 * @param size
		 * @param thickness
		 * @param color
		 * @param alpha
		 * @param fillColor
		 * @param fillAlpha
		 * 
		 */		
		public static function drawCircleByAngle(graphics : Graphics,
												 x:Number, y:Number,r:Number,
												 startA:Number,size : Number = 0.6,
												 thickness : Number = 1,color : Number = 0x000000,alpha : Number = 1,
												 fillColor : Number = 0xededed,fillAlpha : Number = 1) : void
		{
			graphics.lineStyle(thickness,color,alpha,false,LineScaleMode.NONE);
			graphics.beginFill(fillColor,fillAlpha);
			
			startA = startA * Math.PI / 180;
			var startB:Number = startA;
			
			var _x : Number = x + r * Math.cos(startA);
			var _y : Number = y + r * Math.sin(startA);
			
			//起始边
			graphics.moveTo(x + r * Math.cos(startA), y + r * Math.sin(startA));
			graphics.drawCircle(_x, _y,size);
			graphics.endFill();
		}
		
		
		public static function drawDashPoint(graphics : Graphics,
											 x:Number, y:Number,r:Number,
											 angle:Number, startA:Number,
											 thickness : Number = 1,color : Number = 0x000000,alpha : Number = 1,
											 fillColor : Number = 0xededed,fillAlpha : Number = 1) : void
		{
			graphics.lineStyle(thickness,color,alpha,false,LineScaleMode.NONE);
			graphics.beginFill(fillColor,fillAlpha);
			
			if (Math.abs(angle) > 360)
			{
				angle=360;
			}
			var n:Number = Math.ceil(Math.abs(angle) / 45);
			var angleA:Number=angle / n;
			angleA = angleA * Math.PI / 180;
			startA = startA * Math.PI / 180;
			var startB:Number = startA;
			
			//起始边
			graphics.moveTo(x + r * Math.cos(startA), y + r * Math.sin(startA));
			
			for (var j:uint = n; j >= 1; j--)
			{
				startA-= angleA;
				var angleMid2:Number=startA + angleA / 2;
				var bx2:Number=x + r / Math.cos(angleA / 2) * Math.cos(angleMid2);
				var by2:Number=y + r / Math.cos(angleA / 2) * Math.sin(angleMid2);
				var cx2:Number=x + r * Math.cos(startA);
				var cy2:Number=y + r * Math.sin(startA);
				
				graphics.drawCircle(bx2, by2,0.6);
			}	
			graphics.endFill();
		}
		
		
		/**
		 * 
		 * 绘制任意的圆心的圆弧
		 *  
		 * @param graphics
		 * @param x
		 * @param y
		 * @param r
		 * @param angle
		 * @param startA
		 * @param thickness
		 * @param color
		 * @param alpha
		 * 
		 */		
		public static function drawArc(graphics : Graphics,
										x:Number, y:Number,r:Number,
										angle:Number, startA:Number,
										thickness : Number = 1,
										color : Number = 0xEAEAEA,
										alpha : Number = 1) : void
		{
			
			graphics.lineStyle(thickness,color,alpha,false,LineScaleMode.NONE,CapsStyle.SQUARE);
			
			if (Math.abs(angle) > 360)
			{
				angle=360;
			}
			var n:Number = Math.ceil(Math.abs(angle) / 45);
			var angleA:Number=angle / n;
			angleA = angleA * Math.PI / 180;
			startA = startA * Math.PI / 180;
			var startB:Number = startA;
			
			//起始边
			graphics.moveTo(x + r * Math.cos(startA), y + r * Math.sin(startA));
			
			for (var i:uint=1; i <= n; i++)
			{
				startA += angleA;
				var angleMid1:Number=startA - angleA / 2;
				var bx:Number = x + r / Math.cos(angleA / 2) * Math.cos(angleMid1);
				var by:Number = y + r / Math.cos(angleA / 2) * Math.sin(angleMid1);
				var cx:Number = x + r * Math.cos(startA);
				var cy:Number = y + r * Math.sin(startA);
				graphics.curveTo(bx, by, cx, cy);
			}
		}
		
	}
	
}



















