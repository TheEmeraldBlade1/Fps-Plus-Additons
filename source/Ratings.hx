import flixel.FlxG;

class Ratings
{
	public static function GenerateLetterRank(accuracy:Float) // generate a letter ranking
	{
		var ranking:String = "N/A";

		if (PlayState.misses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods == 0) // Marvelous (SICK) Full Combo
			ranking = "";
		else if (PlayState.misses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
			ranking = "";
		else if (PlayState.misses == 0) // Regular FC
			ranking = "";
		else if (PlayState.misses < 10) // Single Digit Combo Breaks
			ranking = "";
		else
			ranking = "";

		// WIFE TIME :)))) (based on Wife3)

		var wifeConditions:Array<Bool> = [
			accuracy >= 99.9935, // AAAAA
			accuracy >= 99.980, // AAAA:
			accuracy >= 99.970, // AAAA.
			accuracy >= 99.955, // AAAA
			accuracy >= 99.90, // AAA:
			accuracy >= 99.80, // AAA.
			accuracy >= 99.70, // AAA
			accuracy >= 99, // AA:
			accuracy >= 96.50, // AA.
			accuracy >= 93, // AA
			accuracy >= 90, // A:
			accuracy >= 85, // A.
			accuracy >= 80, // A
			accuracy >= 70, // B
			accuracy >= 60, // C
			accuracy < 60 // D
		];

		for (i in 0...wifeConditions.length)
		{
			var b = wifeConditions[i];
			if (b)
			{
				switch (i)
				{
					case 0:
						ranking += "Perfect!!";
					case 1:
						ranking += "Sick!";
					case 2:
						ranking += "Great";
					case 3:
						ranking += "Good";
					case 4:
						ranking += "Nice";
					case 5:
						ranking += "Meh";
					case 6:
						ranking += "Ok";
					case 7:
						ranking += "Non Gamer";
					case 8:
						ranking += "Noob";
					case 9:
						ranking += "Bruh";
					case 10:
						ranking += "Bad";
					case 11:
						ranking += "Shit";
					case 12:
						ranking += "Medium Shit!";
					case 13:
						ranking += "BIG SHIT!!";
					case 14:
						ranking += "MEGA SHIT!!!";
					case 15:
						ranking += "GIGA SHIT!!!!";
				}
				break;
			}
		}

		if (accuracy == 0)
			ranking = "N/A";

		return ranking;
	}
}