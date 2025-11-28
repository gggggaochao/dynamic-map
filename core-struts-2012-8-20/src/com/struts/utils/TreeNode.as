
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
	
/**
 * XML Node Base Class
 *
 * @author Han.Zhou
 * @email zhouhan102@163.com || zhouhan@missiongroup.com.cn
 * @date 2012-5-3 下午06:01:45 
 *
 **/

public class TreeNode
{

	public var tagNode : String;
	
	public var childrenNodes : *;
	
	public var attributeNode : Object;
	
	public function TreeNode(tagNode : String,childrenNodes : * = null,attributeNode : Object = null)
	{
		this.tagNode = tagNode;
		this.childrenNodes = childrenNodes;
		this.attributeNode = attributeNode;
	}
	
}
}
















