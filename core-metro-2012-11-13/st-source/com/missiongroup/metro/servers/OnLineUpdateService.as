package com.missiongroup.metro.servers
{

import com.missiongroup.metro.command.consts.Command;
import com.missiongroup.metro.components.UpgradeProgress;
import com.missiongroup.metro.events.UpgradeEvent;
import com.missiongroup.metro.utils.zip.ZipEntry;
import com.missiongroup.metro.utils.zip.ZipFile;
import com.struts.WebSite;
import com.struts.core.WebApp;
import com.struts.data.DataService;
import com.struts.events.AppEvent;
import com.struts.utils.ArrayUtil;
import com.struts.utils.ComponentsUtil;
import com.struts.utils.DateUtil;
import com.struts.utils.HashTable;
import com.struts.utils.SQLUtil;

import flash.desktop.NativeApplication;
import flash.desktop.NativeProcess;
import flash.desktop.NativeProcessStartupInfo;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLStream;
import flash.system.Capabilities;
import flash.utils.ByteArray;
import flash.utils.IDataInput;
import flash.utils.setTimeout;

import mx.collections.ArrayCollection;
import mx.controls.ProgressBar;
import mx.utils.StringUtil;
import mx.utils.UIDUtil;
import mx.utils.URLUtil;

import spark.components.WindowedApplication;

/**
 *
 * 
 *  升级步骤<br/>
 * 
 * <p>
 * 1、解析通信协议 <br/>
 * 2、下载升级包<br/>
 * 3、解压缩升级包<br/>
 * 4、更新文件<br/>
 * 5、比较版本<br/>
 * 6、卸载新版本当前对应的模块<br/>
 * 7、初始化系统<br/>
 * 8、清空临时文件夹<br/>
 * 9、扫描插件文件夹的所有模块<br/>
 * </p>
 * <br/>
 * 
 *  
 *  
 * @author ZhouHan
 * 
 */
public class OnLineUpdateService extends DownLoadService
{
	private static const MODULE_PATH  : String = "plugins";

	private static const FACE_PATH : String = "face";

	private static const FILE_VERSION  : String = "version.mit";
	
	private static const FILE_MODULE  : String = "Module.swf";
	
	private static const FILE_ICON  : String = "icon.png";
	
	
	/**
	 * 
	 *  模块路径 
	 *  
	 */	
	private var pluginsFolder : String;
	
	private var skinsFolder : String;
	
	private var root : String;
	
	private var currVersionHas : HashTable;
	
	/**
	 *  加载升级文件参数 
	 */	
	private var autoUpdates : ArrayCollection;
	
	private var progress : UpgradeProgress;
	
	private var fileStream : FileStream;
	
	
	/**
	 * 是否更新主程序 
	 */	
	private var isUpdateFramework : Boolean = false;
	
	
	/**
	 * 是否重启exe 
	 */	
	private var isReStart : Boolean = false;
	
	public function OnLineUpdateService(cmds : Array)
	{
		super(cmds);
		
		progress = new UpgradeProgress();
		fileStream = new FileStream();
		currVersionHas = new HashTable();
		
		var sys : String = Capabilities.os.toLowerCase();
		if(sys.indexOf("win") != -1) {
			root = File.applicationDirectory.nativePath;
		}
		else {
			root = File.applicationStorageDirectory.nativePath;
		}
		
		
		
		
		
		pluginsFolder = root + "\\" + MODULE_PATH;
		
		skinsFolder   = root + "\\" + FACE_PATH;
			
		
		/**
		 *  初始化本地exe 
		 * 
		 */	
		
		var applicationID : String = NativeApplication.nativeApplication.applicationID + ".exe";
		initProcess(root + "\\" + applicationID);
		
		
		//WebSite.addEventListener(AppEvent.OPEN_ALL_MODULE_COMPLETE,openAllModuleHandler);
	}
		
	/**
	 * 
	 *  重新启动应用系统 
	 * 
	 */	
	private function restart() : void
	{
		if(closeWindowedApplication())
		{	
			process.start(nativeProcessStartupInfo);
		}
	}

	
	private function recordCurrVersion() : void
	{
		currVersionHas.clear();
		
		if(autoUpdates && autoUpdates.length)
		{
			for each(var item : Object in autoUpdates)
			{
				currVersionHas.add(item.name,item);
			}
		}
	}
	
	
	/**
	 * 
	 * 查询上一次版本 
	 * @return 
	 * 
	 */	
	private function selectOldVersion() : Array
	{
		return dao.getQuery("SELECT name FROM MIT_Sys_Moudles ORDER BY ClickCount");
	}
	
	/**
	 * 
	 * 通信协议的处理
	 *  
	 * @param data
	 * 
	 */	
	override public function commandHandler() : void
	{

		if(WebApp.hasEventListener(UpgradeEvent.UPDATEING))
		   WebApp.dispatch(UpgradeEvent.UPDATEING);

		
		var updateFileName : String = command.Content.fileName;
		
		
		if(updateFileName)
		{
			isReStart = isUpdateFramework = false;
	
			downloadUpdatepackage(updateFileName);
		}

	}
	
	/**
	 * 
	 * 下载升级包或文件
	 *  
	 * @param fileName
	 * 
	 */	
	private function downloadUpdatepackage(fileName : String) : void
	{
		try
		{
			
			ComponentsUtil.addToApplication(progress);
			progress.setProgress(0,0,"正在下载升级包",0);
			
			var hasHttp : Boolean = URLUtil.isHttpURL(fileName);
			var lastIndex : int = fileName.lastIndexOf("/");
			progress.upgradeFileName = hasHttp ? fileName.slice((lastIndex + 1)) : fileName;
			

			var url : String = hasHttp ? fileName : setting.FileLoadUrl + fileName;
			
			downloadFile(url);
			
		}
		catch(e : Error)
		{
			logger.error(e.getStackTrace());

			restart();
		}
	}	
	
	override public function downloadError():void
	{
		ComponentsUtil.removeFromApplication(progress);
		
		restart();	
	}

	/**
	 * 
	 *  升级步骤
	 * 
	 * 1、解析通信协议
	 * 2、下载升级包
	 * 3、解压缩升级包
	 * 4、更新文件
	 * 5、比较版本
	 * 6、卸载新版本当前对应的模块
	 * 7、初始化系统
	 * 
	 *  
	 * @param event
	 * 
	 */	
	override public function downloadHandler(data : IDataInput) : void
	{
		
		dao.close();
		
		var zip  : ZipFile = new ZipFile(data);
		progress.upgradeFileSize = zip.fileSize;
		unzip(zip,zip.size);	
	}
	
	/**
	 * 
	 * 解压缩文件到临时目录
	 * 
	 * @param zip   ZipFile
	 * @param fileTotal  文件总数
	 * 
	 */	
	private function unzip(zip : ZipFile,fileTotal : Number) : void
	{
		try
		{
			if(zip.size)
			{
				var zipEntry : ZipEntry = zip.entries[0] as ZipEntry;
				zip.entries.splice(0, 1);
				
				var zipName : String = zipEntry.name;
				var val : Number = fileTotal - zip.size;

				if(!isReStart && zipName == "iPis3.swf")
					isReStart = true;
				
				if(!isUpdateFramework && zipName == FACE_PATH + "/")
					isUpdateFramework = true;
								
				if(!zipEntry.isDirectory())
				{
					
					var byteArray : ByteArray = zip.getInput(zipEntry);
					
					if(byteArray.length)
					{
						
						var temp : File = createNewFile(root,zipName);
						
						fileStream.open(temp,FileMode.WRITE);
						fileStream.writeBytes(byteArray,0,byteArray.length);
						fileStream.close();		
						
					}
				}			
				
				var nextZipEntry: ZipEntry = zipEntry;
				
				if(zip.size > 1)
				{
					nextZipEntry = zip.entries[0] as ZipEntry;
				}
				
				progress.setProgress(val,fileTotal,nextZipEntry.name,nextZipEntry.size);
				setTimeout(unzip,200,zip,fileTotal);
			}
			else
			{
				unzipComplete();
			}
		}
		catch(e : Error)
		{
			logger.error(e.getStackTrace());
			
			replyToServer(e.message,0);			
			
			restart();
		}
	}
	
	
	private function createNewFile(path : String,fileName : String) : File
	{
		var newFile : File = new File(path + "\\" + fileName);
		var extension : String = newFile.extension.toLowerCase();
		if(extension == "flv" || extension == "f4v")
		{
			var newFileName : String = UIDUtil.createUID() + "." +newFile.extension;
			fileName = fileName.replace(newFile.name,newFileName);	
			return new File(path + "\\" + fileName);		
		}
		
		return newFile;
	}
	
	/**
	 *  解压缩完成后 
	 * 
	 */	
	private function unzipComplete() : void
	{
		
		ComponentsUtil.removeFromApplication(progress);
		
		replyToServer("升级完成");
		
		var file : String = progress.upgradeFileName;
		
		
		var fileIndex : Number = file.indexOf(".");
		var logInfo : Object = new Object();
		logInfo.FILEID = file.substr(0,fileIndex);
		logInfo.FILENAME = file;
		
		var str : String = "UPDATETIME="+DateUtil.dateToString(new Date()) + "#" +URLUtil.objectToString(logInfo,"#");
		
		logger.log("ULOG",str);
		
		restart();
	}
	

	
	
	
	/**
	 *  
	 * 启动时调用 
	 * 
	 */	
	override public function run() : void
	{
		
		var folder: File = new File(skinsFolder);
		
		var isExists : Boolean = folder.exists;
		
		if(isExists)
		{
			resetSkins();
		
			loadSkinAndPlugins();	
		}
		
		openAllModuleHandler(null);
	}
	
	private function openAllModuleHandler(event : Event) : void
	{
		complete();	
	}
	
	
	/**
	 * 
	 * 	扫描本地组件模块目录，获取模块版本
	 * 
	 *  模块目录中 必须有  version.mit,Module.swf和icon.png 三个文件
	 *  
	 * */
	private function scanningLocalPlugins() : void
	{
		autoUpdates = readFolder(pluginsFolder);

		udpateCurrVersion();
	}
	
	
	/**
	 *  
	 *  加载皮肤和功能插件
	 *  
	 *  @param a
	 * 
	 */	
	private function loadSkinAndPlugins() : void
	{

		scanningLocalPlugins();
		
		loadSkinAndPluginsComplete();
		
	}
	
	/**
	 * 
	 *  重置皮肤模块 
	 * 
	 */	
	private function resetSkins() : void
	{
		var skinModule : Object = new Object();
		skinModule.url  = FACE_PATH + "/" + FILE_MODULE;
		skinModule.name = FACE_PATH;
		
		WebApp.dispatchEvent(new AppEvent(AppEvent.MODULE_SKINS_CHANGE,[skinModule]));			
	}

	
	/**
	 * 
	 * 返回文件中的有效插件
	 * 
	 * @param path 文件路径
	 * @return 
	 * 
	 */	
	private function readFolder(path : String) : ArrayCollection
	{
		
		var list : ArrayCollection = new ArrayCollection();
		
		var folder: File = new File(path);
 
		var files : Array = folder.getDirectoryListing();	
		
		var autoFiles : Array;
		var versionFile : File;
		var isUpdatePackage : Boolean;
		
		//var fileStream : FileStream = new FileStream();
		var versionXMLString : String;
		
		for each(var plugin : File in files)
		{
			if(plugin.isDirectory)
			{
				autoFiles  = plugin.getDirectoryListing();	
				
				isUpdatePackage =  checkFilePackage(autoFiles);
				
				if(isUpdatePackage)
				{
					versionFile = new File(path + "\\" + plugin.name + "\\" + FILE_VERSION);
					
					fileStream.open(versionFile,FileMode.READ);
					versionXMLString = fileStream.readUTFBytes(fileStream.bytesAvailable);
					fileStream.close();
					
					var wgt : Object = createWgt(versionXMLString,plugin.name);
					
					list.addItem(wgt);
				}
			}		
		}
		
		return list;
	}
	

	
	
	/**
	 * 
	 * 检查升级文件包是否有效
	 * 
	 * 文件包中 必须有  version.mit,Module.swf和icon.png 三个文件 为有效文件
	 *  
	 * @param files 文件目录列表
	 * 
	 * @return  
	 * 
	 */	
	private function checkFilePackage(files : Array) : Boolean
	{
		
		var hasVersionFile : Boolean = false;
		var hasModuleFile : Boolean = false;
		var hasIconFile : Boolean = false;
		for each(var file : File in files)
		{
			if(!file.isDirectory)
			{
				if(file.name == FILE_MODULE)
					hasModuleFile = true;
				else if(file.name == FILE_VERSION)
					hasVersionFile = true;
				else if(file.name == FILE_ICON)
					hasIconFile = true
			}
		}		
		
		return hasVersionFile && hasModuleFile && hasIconFile;
	}
	
	
	
	private function createWgt(xmlString : String,pluginFileName : String) : Object
	{
		var doc : XML = new XML(xmlString);
		
		var title : String = doc.title;
		var subTitle : String = doc.subTitle;
		var titleE : String = doc.titleE;
		var subTitleE : String = doc.subTitleE;
		var version : String = doc.version;
		var remark : String = doc.remark;
		var order : String = doc.order;
		
		
		var wgt : Object = new Object();
		wgt.name = pluginFileName;
		wgt.icon = MODULE_PATH + "/" + pluginFileName + "/" + FILE_ICON;
		wgt.url =  MODULE_PATH + "/" + pluginFileName + "/" + FILE_MODULE;
		wgt.title = title;
		wgt.subTitle = subTitle;
		wgt.titleE = titleE;
		wgt.subTitleE = subTitleE;
		wgt.version = Number(version);
		wgt.order = order ?  Number(order) : 0;
		wgt.remark = remark;	
		
		return wgt;
	}
	
	/**
	 * 
	 *  更新当前版本 
	 * 
	 */	
	private function udpateCurrVersion() : void
	{

		recordCurrVersion();
		
		var currVers : Array = currVersionHas.toArray();
		var oldVers : Array = selectOldVersion() || new Array();
		var isUpdate : Boolean = true;
		
		var item : Object;
		var sqls : Array = new Array();
		for each(var wgt : Object in currVers)
		{
			isUpdate = isHaveVersion(wgt.name,oldVers)
			item = saveOrUpdateModule(wgt,isUpdate);
			sqls.push(item);
		}
		
		
		dao.executeTransaction(sqls);
		
	}
	
	
	private function isHaveVersion(name : String,oldVers : Array) : Boolean
	{
		if(oldVers.length)
		{
			for each(var item : Object in oldVers)
			    if(item.name == name)
					return true;
		}
		
		return false;
	}
	
	/**
	 * 
	 *  加载皮肤和插件完成时 
	 * 
	 */	
	private function loadSkinAndPluginsComplete() : void
	{
		ArrayUtil.sort(autoUpdates,["order"]);
		
		WebSite.addShareData("allPlugins",autoUpdates);	
		
		WebSite.dispatchEvent(new AppEvent(AppEvent.MODULE_WIDGET_CHANGE,autoUpdates.toArray()));

		//WebSite.dispatch(AppEvent.OPEN_ALL_MODULE);
	}
	
	
	
	
	private function saveOrUpdateModule(wgt : Object,isUpdate : Boolean = true) : String
	{

		var upgradTime : String = DateUtil.dateToString(new Date());
		
		var _object : Object = new Object();
		_object.name = wgt.name;
		_object.title = wgt.title;
		_object.version = wgt.version;
		_object.upgradTime = upgradTime;

		if(isUpdate)
		{
			return SQLUtil.createUpdateSQL(_object,"MIT_Sys_Moudles","Name");
		}

		_object.clickCount = 0;	
		return SQLUtil.createInsertSQL(_object,"MIT_Sys_Moudles","Name");
	}
	
}

}







































