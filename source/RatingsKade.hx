import flixel.FlxG;

class RatingsKade
{
	public static function GenerateLetterRank(accuracy:Float) // generate a letter ranking
	{
		var ranking:String = "?";
		
		ranking = "";

		// WIFE TIME :)))) (based on Wife3)

		var wifeConditions:Array<Bool> = [
			accuracy >= 99, // AAAAA
			accuracy >= 75, // AAAA:
			accuracy >= 70, // AAAA.
			accuracy >= 65, // AAAA
			accuracy >= 60, // AAA:
			accuracy >= 55, // AAA.
			accuracy >= 50, // AAA
			accuracy >= 45, // AA:
			accuracy >= 40, // AA.
			accuracy >= 35, // AA
			accuracy >= 30, // A:
			accuracy >= 25, // A.
			accuracy >= 20, // A
			accuracy >= 15, // B
			accuracy >= 10, // C
			accuracy < 5 // D
		];

		for (i in 0...wifeConditions.length)
		{
			var b = wifeConditions[i];
			if (b)
			{
				switch (i)
				{
					case 0:
						ranking += "AAAAA";
					case 1:
						ranking += "AAAA:";
					case 2:
						ranking += "AAAA.";
					case 3:
						ranking += "AAAA";
					case 4:
						ranking += "AAA:";
					case 5:
						ranking += "AAA.";
					case 6:
						ranking += "AAA";
					case 7:
						ranking += "AA:";
					case 8:
						ranking += "AA.";
					case 9:
						ranking += "AA";
					case 10:
						ranking += "A:";
					case 11:
						ranking += "A.";
					case 12:
						ranking += "A";
					case 13:
						ranking += "B";
					case 14:
						ranking += "C";
					case 15:
						ranking += "D";
				}
				break;
			}
		}

		if (accuracy == 0)
			ranking = "?";

		return ranking;
	}
}