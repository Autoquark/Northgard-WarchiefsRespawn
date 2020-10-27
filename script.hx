//var answers : Array<{p:Player, a:Int}> = [];
var playerInfo : Array<{p:Player, hiredWarchief:Int, warchiefDiedAt:Float}> = [];
var respawnTime : Int = 10;

function init()
{
	if(isHost() && state.time == 0)
	{
		var i = 0;
		for (p in state.startPlayers)
		{
			playerInfo.push({p: p, hiredWarchief: 0, warchiefDiedAt: -1});
			//playerInfo[i].p = p;
			//playerInfo[i].hiredWarchief = 0;
			//playerInfo[i].warchiefDiedAt = -1;

			p.addResource(Resource.Iron, 15);
			p.addResource(Resource.Money, 150);
			i++;
		}
	}
}

// Just assign an index to a player
/*function playerId(p : Player) : Int{
      var i = 0;
      for(other in state.startPlayers){
            if(other == p)
                  return i;
            i++;
      }
      return -1;
}*/

function regularUpdate(dt : Float) {
	if(isHost())
	{
		debug("" + state.time);
		for (info in playerInfo)
		{
			//TODO: GetWarchiefs(), getAvailableWarchiefs(), handle horse, bear etc.
			if(info.p.getWarchief() != null)
			{
				if(info.hiredWarchief == 0)
				{
					debug("player " + info.p + " hired warchief");
				}
				info.hiredWarchief = 1;
			}
			else if(info.hiredWarchief == 1 && info.warchiefDiedAt == -1)
			{
				debug("player " + info.p + " warchief died");
				info.warchiefDiedAt = state.time;
			}
			else if(info.hiredWarchief == 1 && ((state.time - info.warchiefDiedAt) >= respawnTime))
			{
				debug("player " + info.p + " warchief respawning");
				//info.p.getTownHall().zone.addUnit(Unit.Warchief, 1, info.p);
				var hall = info.p.getTownHall();
				summonWarchief(info.p, hall.zone, hall.x + 10, hall.y + 10);

				info.warchiefDiedAt = -1;
			}
		}
	}
}

function saveState() {
      state.scriptProps = {
            //myFloat : myFloat    // Your variable to save. Ensure the name of the variable is repeated twice here
      }
}