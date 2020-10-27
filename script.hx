//var answers : Array<{p:Player, a:Int}> = [];
var playerInfo : Array<{p:Player, units:Array<{kind:UnitKind, hired:Int, diedAt:Float}>}> = [];
var respawnTime : Int = 10;

function init()
{
	if(isHost() && state.time == 0)
	{
		var i = 0;
		for (p in state.startPlayers)
		{
			var info = {p: p, units: []};
			playerInfo.push(info);
			for(unit in p.getAvailableWarchiefs())
			{
				info.units.push({ kind: unit, hired: 0, diedAt: -1 });
			}
			//playerInfo[i].p = p;
			//playerInfo[i].hiredWarchief = 0;
			//playerInfo[i].warchiefDiedAt = -1;

			p.addResource(Resource.Iron, 30);
			p.addResource(Resource.Money, 1500);
			i++;
		}
	}
}

function regularUpdate(dt : Float) {
	if(isHost())
	{
		debug("" + state.time);
		for (info in playerInfo)
		{
			for(unitInfo in info.units)
			{
				//TODO: GetWarchiefs(), getAvailableWarchiefs(), handle horse, bear etc.
				var found = false;
				for(unit in info.p.units)
				{
					if(unit.kind == unitInfo.kind)
					{
						found = true;
					}
				}

				if(found)
				{
					if(unitInfo.hired == 0)
					{
						debug("player " + info.p + " hired warchief");
					}
					unitInfo.hired = 1;
				}
				else if(unitInfo.hired == 1 && unitInfo.diedAt == -1)
				{
					debug("player " + info.p + " warchief died");
					unitInfo.diedAt = state.time;
				}
				else if(unitInfo.hired == 1 && ((state.time - unitInfo.diedAt) >= respawnTime))
				{
					debug("player " + info.p + " warchief respawning");

					var hall = info.p.getTownHall();
					// For some reason addUnit doesn't work for the vanilla warchief
					if(unitInfo.kind == Unit.Warchief)
					{
						summonWarchief(info.p, hall.zone, hall.x + 10, hall.y + 10);
					}
					else
					{
						hall.zone.addUnit(unitInfo.kind, 1, info.p);
					}

					unitInfo.diedAt = -1;
				}
			}
		}
	}
}

function saveState() {
      state.scriptProps = {
            //myFloat : myFloat    // Your variable to save. Ensure the name of the variable is repeated twice here
      }
}