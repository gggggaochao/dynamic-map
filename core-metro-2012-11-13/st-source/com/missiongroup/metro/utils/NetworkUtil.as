package com.missiongroup.metro.utils
{
	
import flash.net.InterfaceAddress;
import flash.net.NetworkInfo;
import flash.net.NetworkInterface;

public class NetworkUtil
{
	/**
	 *
	 * 获取本地IP
	 *  
	 * @return 
	 * 
	 */	
	public static function address(ipVersion : String = "IPv4") : String
	{
		
		var addressVector : Vector.<InterfaceAddress> = new Vector.<InterfaceAddress>();
		
		var ni:NetworkInfo = NetworkInfo.networkInfo;
		var interfaceVector:Vector.<NetworkInterface> = ni.findInterfaces();
		
		var interfaceAddressVector : Vector.<InterfaceAddress>;
		var interfaceAddress : InterfaceAddress;
		
		for each (var networkInterface : NetworkInterface in interfaceVector)
		{
			if(networkInterface.active && networkInterface.hardwareAddress)
			{
				interfaceAddressVector = networkInterface.addresses;
				
				for each (interfaceAddress in interfaceAddressVector)
				{
					if(interfaceAddress.ipVersion == ipVersion)
						addressVector.push(interfaceAddress);		
					
				}		
			}
		}
		
		if(addressVector.length > 0)
		{
			return addressVector[0].address;
		}

		return "127.0.0.1";
	}
}
}