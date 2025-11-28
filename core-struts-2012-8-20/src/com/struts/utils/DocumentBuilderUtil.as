
////////////////////////////////////////////////////////////////////////////////
//
//  MissionGroup Copyright 2012 All Rights Reserved.
//
//  NOTICE: MIT MissionGroup permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.struts.utils
{
	
import mx.collections.XMLListCollection;
import mx.utils.ObjectUtil;
	
/**
 * TreeNode 导入XML
 *
 * @author Han.Zhou
 * @email zhouhan102@163.com || zhouhan@missiongroup.com.cn
 * @date 2012-5-11 上午09:56:10 
 *
 **/

public class DocumentBuilderUtil
{
	
	public static function createDocument(element : TreeNode) : XML
	{
		//var xmlString : String = createNodeXMLString(element);
		
		return createChildNode(element);
	}
	
	public static function createChildNode(element : TreeNode) : XML
	{
		try
		{
			var properties : String;
			var properitesValue : String;
			var attribute : String;
			var value : *;
			var excludes : Array = ["tagNode","childrenNodes","attributeNode"];
			var classInfoProperties:Array = ObjectUtil.getClassInfo(element,excludes).properties as Array;
			var qName : QName;

			var tagNode : String = element.tagNode;
			var childrenNodes : * = element.childrenNodes;
			var attributeNode : Object = element.attributeNode;

			function getValue(v : *) : String
			{
				if(v == null)
					return null;
				
				return String(v);
			}
			
			
			var tree : XML = new XML("<"+tagNode+" />");
			
			for each(qName in classInfoProperties)
			{
				properties = qName.localName;
				properitesValue = getValue(element[properties]);
				if(properitesValue)
				{
					tree.@[properties] = properitesValue;
				}
			}
			
			if(attributeNode)
			{
				for (properties in attributeNode)
				{
					properitesValue = getValue(attributeNode[properties]);
					if(properitesValue)
					{
						tree.@[properties] = properitesValue;
					}
				}
			}
			
			function buildXMLNode(tempNode : *) : void
			{
				if(tempNode is XML || tempNode is XMLList)
				{
					tree.appendChild(tempNode)
				}
				else if(tempNode is XMLListCollection)
				{
					tree.appendChild(XMLListCollection(tempNode).source);
				}
				else if(tempNode is TreeNode)
				{
					tree.appendChild(createChildNode(TreeNode(tempNode)));
				}
			}
			
			if(childrenNodes is Array)
			{
				for each(var child : * in childrenNodes)
				{
					buildXMLNode(child);
				}
			}
			else
			{
				if(childrenNodes)
					buildXMLNode(childrenNodes);
			}
			
			return tree;
		}
		catch(e : Error)
		{
			
		}
		
		return null;
		
	}	
}
}























