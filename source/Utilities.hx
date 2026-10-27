package;

/**
 * A class that has basic functions that makes
 * other code easier to write. - Coma
 */

import openfl.utils.Assets;

using StringTools;

class Utilities
{
	public static var randomshit:Map<String, Dynamic> = [];

	public static function dataFromTextFile(path:String):Array<String>
	{
		var daList:Array<String> = [];

		if (Assets.exists(path))
			daList = Assets.getText(path).split('\n');

		return daList;
	}

	public static function getListFromArray(array:Array<String>):Array<String>{
		var returnThis = [];

		var data = array;

		for (i in 0...data.length)
		{
			var stuff:Array<String> = data[i].split(":");

			returnThis.push(stuff[0]);
		}

		return returnThis;
	}

	public static function grabThingFromText(thingtoget:String, filename:String, theonetosend:Int):String
	{
		var data = Utilities.dataFromTextFile(filename);
		var thingToSend:String = '';

		for (i in 0...data.length)
		{
			var stuff:Array<String> = data[i].split(":");
			if (stuff[0] == thingtoget)
			{
				thingToSend = stuff[theonetosend];
			}
		}

		return thingToSend;
	}
}