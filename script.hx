var playerInfo : Array<{p:Player, units:Array<{kind:UnitKind, hired:Int, diedAt:Float}>}> = [];
//var respawnTime : Int = 120;
var DEBUG = false;

function init()
{
	if(state.time == 0)
	{
		if(isHost())
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

				if(DEBUG)
				{
					p.addResource(Resource.Iron, 30);
					p.addResource(Resource.Money, 1500);
				}
				i++;
			}
		}
	}
}

function regularUpdate(dt : Float) {
	if(isHost())
	{
		for (info in playerInfo)
		{
			for(unitInfo in info.units)
			{
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
						debugPrint("player " + info.p + " hired " + unitInfo.kind);
					}
					unitInfo.hired = 1;
				}
				else if(unitInfo.hired == 1 && unitInfo.diedAt == -1)
				{
					debugPrint("player " + info.p + " " + unitInfo.kind + " died");
					unitInfo.diedAt = state.time;
				}
				//else if(unitInfo.hired == 1 && ((state.time - unitInfo.diedAt) >= respawnTime))
				else if(unitInfo.hired == 1 && info.p.getCooldownHero(unitInfo.kind) <= state.time)
				{
					debugPrint("player " + info.p + " " + unitInfo.kind + " respawning");

					var hall = info.p.getTownHall();
					// For some reason addUnit doesn't work for the vanilla warchief
					if(unitInfo.kind == Unit.Warchief)
					{
						summonWarchief(info.p, hall.zone, hall.x + 10, hall.y + 10);
					}
					else
					{
						hall.zone.addUnit(unitInfo.kind, 1, info.p, true);
					}

					unitInfo.diedAt = -1;
				}
			}
		}
	}
}

function debugPrint(string : String)
{
	if(DEBUG)
	{
		debug(string);
	}
}