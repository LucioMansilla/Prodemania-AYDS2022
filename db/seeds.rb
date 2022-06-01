liga_argentina = Tournament.create(name: "Liga Argentina")
premier_league = Tournament.create(name: "Premier League")

fecha_1_arg = MatchDay.create(description: "Fecha 1", tournament: liga_argentina)
fecha_1_premier = MatchDay.create(description: "Match Day 1", tournament: premier_league)

boca = Team.create(name: "Boca")
river = Team.create(name: "River")
indep = Team.create(name: "Independiente")
racing = Team.create(name: "Racing")

liga_argentina.teams << [boca,river,indep, racing]

chelsea = Team.create(name: "Chelsea")
liverpool = Team.create(name: "Liverpool")
arsenal = Team.create(name: "Arsenal")
everton = Team.create(name: "Everton")

premier_league.teams << [chelsea, liverpool, arsenal, everton]

m1 = Match.create(home: boca, away: river, match_day: fecha_1_arg)
m2 = Match.create(home: indep, away: racing, match_day: fecha_1_arg)

m3 = Match.create(home: chelsea, away: liverpool, match_day: fecha_1_premier)
m4 = Match.create(home: arsenal, away: everton, match_day: fecha_1_premier)

p = Player.create(name:"Mateo", email: "mateo@correo.com", password: "12345", is_admin: true)
l = Player.create(name:"Lucio", email: "lucio@correo.com", password: "12345", is_admin: true)
b = Player.create(name:"Brenda", email: "brenda@correo.com", password: "12345", is_admin: true)