
drop table teams;
drop table coaches_season;
drop table draft;
drop table players;
drop table player_rs_career;
drop table player_rs;


create table teams (tid varchar(30), location varchar(30), name varchar(30), league varchar(30), primary key (tid, league));

create table coaches_season (cid varchar(30), year int, yr_order int,firstname varchar(30), lastname varchar(30), season_win int, season_loss int, playoff_win int, playoff_loss int, tid varchar(30), primary key (cid, year, yr_order));

create table draft (draft_year int, draft_round int, selection int, tid varchar(30), firstname varchar(30), lastname varchar(30), ilkid  varchar(30), draft_from varchar(100), league varchar(30));

create table players (ilkid varchar(30), firstname varchar(30), lastname varchar(30), position varchar(1), first_season int, last_season int, h_feet int, h_inches real, weight real, college varchar(100), birthday varchar(30), primary key (ilkid)); 

create table player_rs_career (ilkid varchar(30), firstname varchar(30), lastname varchar(30), league varchar(10), gp int, minutes int, pts int, dreb int, oreb int, reb int, asts int, stl int, blk int, turnover int, pf int, fga int, fgm int, fta int, ftm int, tpa int, tpm int);

create table player_rs (ilkid varchar(30), year int, firstname varchar(30), lastname varchar(30), tid varchar(30), league varchar(10), gp int, minutes int, pts int, dreb int, oreb int, reb int, asts int, stl int, blk int, turnover int, pf int, fga int, fgm int, fta int, ftm int, tpa int, tpm int, primary key(ilkid, year, tid));

-- 0. Under psql, load all the above tables with data obtained from the corresponding txt file using the `copy’ command like this:

/*\copy teams from '/home/raghunath/Desktop/Proj2/teams.txt' with delimiter ,
\copy coaches_season from '/home/raghunath/Desktop/Proj2/coaches_season.txt' with delimiter ,
\copy draft from '/home/raghunath/Desktop/Proj2/draft.txt' with delimiter ,
\copy players from '/home/raghunath/Desktop/Proj2/players.txt' with delimiter ,
\copy player_rs_career from '/home/raghunath/Desktop/Proj2/player_rs_career.txt' with delimiter ,
\copy player_rs from '/home/raghunath/Desktop/Proj2/player_rs.txt' with delimiter ,*/

-- Put your SQL statement under the following lines:

/*1. Find all the players who played in a Boston team and a Denver team (this does not have to happen in the same season). List their first names followed by their last names.*/	

SELECT DISTINCT firstname,lastname
FROM player_rs
WHERE ilkid IN (SELECT player_rs.ilkid
		FROM teams, player_rs
		WHERE teams.tid = player_rs.tid AND teams.location = 'Boston'
		INTERSECT
		SELECT player_rs.ilkid
		FROM teams, player_rs
		WHERE teams.tid = player_rs.tid AND teams.location = 'Denver');

/*
 firstname | lastname 
-----------+----------
 Bryant    | Stith
 Calbert   | Cheaney
 Charlie   | Scott
 Chauncey  | Billups
 Chris     | Herren
 Danny     | Fortson
 Doug      | Overton
 Eric      | Williams
 Joe       | Wolf
 Kenny     | Battle
 Mark      | Blount
 Mark      | Bryant
 Norm      | Cook
 Paul      | Silas
 Popeye    | Jones
 Raef      | Lafrentz
 Raef      | LaFrentz
 Rodney    | Rogers
 Ron       | Mercer
 Roy       | Rogers
 Shammond  | Williams
 Todd      | Lichti
 Tom       | Boswell
 Tony      | Battie
(24 rows)
*/



/*2. Find the players who only played between years 1990 to 1992, order the results by (last_name, first_name);*/

SELECT firstname,lastname
FROM players
WHERE (players.first_season=1990 OR players.first_season=1991 OR players.first_season=1992) AND (players.last_season=1990 OR players.last_season=1991 OR players.last_season=1992)
ORDER BY lastname, firstname;	

/*
 firstname |  lastname  
-----------+------------
 Milos     | Babic
 Cedric    | Ball
 Alex      | Blackwell
 Lance     | Blanks
 Ricky     | Blanton
 Myron     | Brown
 Demetrius | Calip
 Rick      | Calloway
 Dexter    | Cambridge
 Richard   | Coffey
 Tom       | Copa
 Radisav   | Curcic
 Patrick   | Eddie
 A.j.      | English
 Dan       | Godfread
 Jim       | Grandholm
 Brian     | Howard
 Cedric    | Hunter
 Mike      | Iuzzolino
 Les       | Jepsen
 Thomas    | Jordan
 Bo        | Kimble
 Kurk      | Lee
 Ian       | Lockhart
 Kevin     | Lynch
 Tharon    | Mayes
 Travis    | Mays
 Rodney    | Monroe
 Isaiah    | Morris
 Chris     | Munk
 Melvin    | Newbern
 Alan      | Ogg
 Matt      | Othick
 Keith     | Owens
 Walter    | Palmer
 Anthony   | Pullard
 Barry     | Stevens
 Lamont    | Strothers
 Charles   | Thomas
 Irving    | Thomas
 Stephen   | Thompson
 John      | Turner
 Gundars   | Vetra
 Joao      | Vianna
 Marcus    | Webb
 Kennard   | Winchester
 Howard    | Wright
 A.j.      | Wydner
(48 rows)
*/


/*3. Find those who happened to be a coach and a player in the same season, but in different teams. List their first names, last names, the season and the teams this happened;*/

SELECT coaches_season.firstname, coaches_season.lastname, coaches_season.year, coaches_season.tid
FROM coaches_season,player_rs
WHERE coaches_season.firstname=player_rs.firstname AND coaches_season.lastname=player_rs.lastname AND coaches_season.year=player_rs.year AND coaches_season.tid<>player_rs.tid;

/* 
 firstname |  lastname  | year | tid 
-----------+------------+------+-----
 Dick      | Fitzgerald | 1946 | TO1
 Ed        | Sadowski   | 1946 | TO1
 Ed        | Sadowski   | 1946 | TO1
 Paul      | Armstrong  | 1948 | DET
 Bruce     | Hale       | 1948 | INJ
 Bruce     | Hale       | 1948 | INJ
 Howie     | Schultz    | 1949 | AND
 Howie     | Schultz    | 1949 | AND
 Jack      | Smiley     | 1949 | WAT
 Jack      | Smiley     | 1949 | WAT
 Jerry     | Reynolds   | 1986 | SAC
 Jerry     | Reynolds   | 1987 | SAC
 Jerry     | Reynolds   | 1988 | SAC
 Jerry     | Reynolds   | 1989 | SAC
 Mike      | Dunleavy   | 2003 | LAC
(15 rows)
*/

/*4.For each year that appeared in the drafts table, find the college that sent the most drafts. For example, if in year 1992, Ohio State sent more drafts than any other college did, you should print out (1992, Ohio State);*/

SELECT DISTINCT d1.draft_year, d1.draft_from
FROM draft d1
GROUP BY d1.draft_year,d1.draft_from
HAVING COUNT(d1.draft_from) >= ALL (SELECT COUNT(d2.draft_from)
				    FROM draft d2
				    WHERE d1.draft_year = d2.draft_year
				    GROUP BY d2.draft_year,d2.draft_from);

/*
 draft_year |        draft_from        
------------+--------------------------
       1947 |  
       1948 | Arkansas
       1948 | Kentucky
       1948 | New York University
       1948 | North Carolina
       1948 | Western Kentucky
       1949 | Kentucky
       1949 | Notre Dame
       1950 | Wyoming
       1951 | Bradley
       1951 | Kansas State
       1952 | St. John's
       1953 | None
       1954 | Indiana
       1955 | Colorado
       1955 | Niagara
       1956 | Duke
       1956 | Kentucky
       1957 | Louisville
       1957 | North Carolina State
       1957 | Syracuse
       1958 | Dayton
       1958 | Kentucky
       1958 | North Carolina
       1958 | Temple
       1959 | George Washington
       1959 | Northwestern
       1960 | Kentucky
       1961 | Kentucky
       1961 | Louisville
       1961 | North Carolina
       1962 | Duquesne
       1962 | North Carolina
       1962 | Ohio State
       1962 | Xavier (OH)
       1963 | Illinois
       1963 | Iowa State
       1964 | Dayton
       1964 | Loyola (IL)
       1965 | Illinois
       1966 | San Francisco
       1967 | Pacific
       1967 | Providence
       1968 | South Carolina
       1969 | UCLA
       1970 | Stephen F. Austin
       1971 | Western Kentucky
       1972 | Pittsburgh
       1973 | Minnesota
       1974 | Chicago
       1974 | Long Beach State
       1975 | Kentucky
       1976 | Indiana
       1977 | Nevada-Las Vegas
       1978 | Marquette
       1978 | Nevada-Las Vegas
       1979 | UCLA
       1980 | North Carolina
       1981 | Indiana
       1981 | Louisiana State
       1981 | Maryland
       1981 | Notre Dame
       1981 | South Alabama
       1982 | Alabama-Birmingham
       1982 | Illinois
       1982 | North Carolina
       1982 | UCLA
       1983 | Indiana
       1983 | Oklahoma
       1984 | Kentucky
       1985 | La Salle
       1985 | Nevada-Las Vegas
       1985 | North Carolina State
       1985 | Oral Roberts
       1985 | South Alabama
       1985 | UCLA
       1985 | Villanova
       1985 | Virginia Commonwealth
       1986 | Duke
       1986 | Georgetown
       1986 | Michigan
       1986 | Notre Dame
       1987 | Alabama
       1987 | North Carolina
       1988 | Auburn
       1988 | Kentucky
       1989 | Iowa
       1990 | Michigan
       1991 | Nevada-Las Vegas
       1992 | Arkansas
       1993 | Arizona
       1993 | Cincinnati
       1993 | Duke
       1993 | Florida State
       1993 | Indiana
       1993 | Kansas
       1993 | Long Beach State
       1993 | Michigan
       1993 | Mississippi Valley State
       1993 | Seton Hall
       1993 | Utah
       1994 | Louisville
       1995 | UCLA
       1996 | Kentucky
       1997 | Villanova
       1998 | Arizona
       1998 | North Carolina
       1998 | UCLA
       1999 | Duke
       2000 | Cincinnati
       2001 | None
       2002 | Duke
       2002 | Fresno State
       2002 | Maryland
       2002 | Yugoslavia
       2003 | Serbia
       2004 | Connecticut
       2004 | CSKA Moscow (Russia) 
       2004 | Duke
       2004 | Georgia
       2004 | Slovenia
       2004 | Spain
       2004 | St. Joe's
       2004 | Xavier
(124 rows)
*/

/*5. Find the coach(es) (firstname and lastname) who have coached the maximum number of teams between the year 1981 to 2004;*/

SELECT  cs1.firstname, cs1.lastname
FROM coaches_season cs1
WHERE cs1.year>=1981 AND cs1.year<=2004
GROUP BY cs1.firstname, cs1.lastname
HAVING COUNT(cs1.tid) >= ALL (SELECT COUNT(cs2.tid)
			      FROM coaches_season cs2
			      WHERE cs2.year>=1981 AND cs2.year<=2004
			      GROUP BY cs2.firstname, cs2.lastname, cs2.cid);
/*
 firstname | lastname 
-----------+----------
 Lenny     | Wilkens
*/


/*6. Which college sent the second largest number of drafts to NBA?*/

SELECT d3.draft_from 
FROM draft d3
GROUP BY d3.draft_from 
HAVING COUNT(*) IN (SELECT MAX(d2.COUNT)
		    FROM (SELECT COUNT(*)
			  FROM draft
		 	  GROUP BY draft.draft_from
			  EXCEPT
			  SELECT MAX(dmax)
			  FROM (SELECT COUNT(*) AS dmax
				FROM draft
				GROUP BY draft.draft_from) AS t1) AS d2);

/*
draft_from 
------------
 Kentucky
*/


/*7.Who coached in all leagues? Use the method introduced in class with 'NOT EXISTS -- EXCEPT -- ...";*/

SELECT DISTINCT coaches_season.firstname, coaches_season.lastname
FROM coaches_season
WHERE NOT EXISTS ((SELECT COUNT(DISTINCT teams.league)
			      FROM teams)
			      EXCEPT
			      (SELECT COUNT(DISTINCT t1.league)
			       FROM coaches_season cs1, teams t1
			       WHERE cs1.tid = t1.tid AND coaches_season.cid = cs1.cid
			       GROUP BY cs1.cid));

/*
 firstname |  lastname   
-----------+-------------
 Alex      | Hannum
 Andrew    | Levane
 Andy      | Phillip
 Bernie    | Bickerstaff
 Bill      | Hanzlik
 Bob       | Bass
 Bob       | Hill
 Bob       | Leonard
 Bob       | Pettit
 Bob       | Weiss
 Cotton    | Fitzsimmons
 Dan       | Issel
 Dick      | Motta
 Dick      | Versace
 Donnie    | Walsh
 Doug      | Moe
 Ed        | Macauley
 Gene      | Littles
 George    | Irvine
 Gregg     | Popovich
 Harry     | Gallatin
 Isiah     | Thomas
 Jack      | McKinney
 Jack      | Ramsay
 Jeff      | Bzdelik
 Jerry     | Tarkanian
 John      | Lucas
 Kevin     | Loughery
 Larry     | Bird
 Larry     | Brown
 Mel       | Daniels
 Mike      | D'Antoni
 Mike      | Evans
 Morris    | McHone
 Paul      | Seymour
 Paul      | Westhead
 Red       | Holzman
 Rex       | Hughes
 Richie    | Guerin
 Rick      | Carlisle
 Slater    | Martin
 Stan      | Albeck
(42 rows)
*/

/*8. Same as in query 7, but use a different approach;*/

SELECT coaches_season.firstname, coaches_season.lastname
FROM coaches_season, teams 
WHERE coaches_season.tid = teams.tid
GROUP BY coaches_season.firstname, coaches_season.lastname
HAVING COUNT(DISTINCT teams.league) IN (SELECT COUNT(DISTINCT t1.league)
			       FROM teams t1);
/*
 firstname |  lastname   
-----------+-------------
 Alex      | Hannum
 Andrew    | Levane
 Andy      | Phillip
 Bernie    | Bickerstaff
 Bill      | Hanzlik
 Bob       | Bass
 Bob       | Hill
 Bob       | Leonard
 Bob       | Pettit
 Bob       | Weiss
 Cotton    | Fitzsimmons
 Dan       | Issel
 Dick      | Motta
 Dick      | Versace
 Donnie    | Walsh
 Doug      | Moe
 Ed        | Macauley
 Gene      | Littles
 George    | Irvine
 Gregg     | Popovich
 Harry     | Gallatin
 Isiah     | Thomas
 Jack      | McKinney
 Jack      | Ramsay
 Jeff      | Bzdelik
 Jerry     | Tarkanian
 John      | Lucas
 Kevin     | Loughery
 Larry     | Bird
 Larry     | Brown
 Mel       | Daniels
 Mike      | D'Antoni
 Mike      | Evans
 Morris    | McHone
 Paul      | Seymour
 Paul      | Westhead
 Red       | Holzman
 Rex       | Hughes
 Richie    | Guerin
 Rick      | Carlisle
 Slater    | Martin
 Stan      | Albeck
(42 rows)
*/

/*9. Find the tallest player (first name and last name) of each team in year 2003. Print out the team, firstname, last name and the height (in centimeters) of the player. Sort the result by the team name.*/

SELECT player_rs.tid, players.firstname, players.lastname, players.h_feet * 30.48+players.h_inches * 2.54 as height
FROM players, player_rs 
WHERE player_rs.year = 2003 AND players.ilkid = player_rs.ilkid
GROUP BY (players.h_feet * 30.48+players.h_inches * 2.54),player_rs.tid, players.firstname, players.lastname
HAVING (players.h_feet * 30.48+players.h_inches * 2.54) >= ALL (SELECT (players1.h_feet * 30.48+players1.h_inches * 2.54)
						    FROM players players1, player_rs player_rs1
						    WHERE player_rs1.year = 2003 AND players1.ilkid = player_rs1.ilkid AND player_rs.tid = player_rs1.tid
						    GROUP BY player_rs1.tid, (players1.h_feet * 30.48+players1.h_inches * 2.54))
ORDER BY player_rs.tid;

/*tid | firstname |   lastname   | height 
-----+-----------+--------------+--------
 ATL | Joel      | Przybilla    |  215.9
 BOS | Chris     | Mihm         | 213.36
 BOS | Mark      | Blount       | 213.36
 CHI | Tyson     | Chandler     |  215.9
 CLE | Zydrunas  | Ilgauskas    | 220.98
 DAL | Shawn     | Bradley      | 226.06
 DEN | Francisco | Elson        | 213.36
 DEN | Nikoloz   | Tskitishvili | 213.36
 DET | Darko     | Milicic      | 213.36
 GSW | Cherokee  | Parks        | 210.82
 GSW | Dan       | Langhi       | 210.82
 GSW | Erick     | Dampier      | 210.82
 GSW | Troy      | Murphy       | 210.82
 HOU | Yao       | Ming         | 226.06
 IND | Primoz    | Brezec       |  215.9
 LAC | Chris     | Kaman        | 213.36
 LAC | Zhizhi    | Wang         | 213.36
 LAL | Shaquille | O'neal       |  215.9
 MEM | Jake      | Tsakalidis   | 218.44
 MIA | Loren     | Woods        |  215.9
 MIL | Dan       | Santiago     |  215.9
 MIL | Joel      | Przybilla    |  215.9
 MIN | Michael   | Olowokandi   | 213.36
 NJN | Jason     | Collins      | 213.36
 NOH | Jamaal    | Magloire     | 210.82
 NOH | P.j.      | Brown        | 210.82
 NYK | Bruno     | Sundov       | 218.44
 NYK | Cezary    | Trybanski    | 218.44
 NYK | Dikembe   | Mutombo      | 218.44
 ORL | Steven    | Hunter       | 213.36
 PHI | Amal      | Mccaskill    | 210.82
 PHI | Samuel    | Dalembert    | 210.82
 PHI | Zendon    | Hamilton     | 210.82
 PHO | Cezary    | Trybanski    | 218.44
 POR | Slavko    | Vranes       | 223.52
 SAC | Brad      | Miller       | 210.82
 SAC | Jabari    | Smith        | 210.82
 SAC | Vlade     | Divac        | 210.82
 SAS | Kevin     | Willis       | 213.36
 SAS | Radoslav  | Nesterovic   | 213.36
 SAS | Tim       | Duncan       | 213.36
 SEA | Jerome    | James        | 213.36
 TOR | Mengke    | Bateer       | 210.82
 TOR | Robert    | Archibald    | 210.82
 TOT | Bruno     | Sundov       | 218.44
 TOT | Cezary    | Trybanski    | 218.44
 UTA | Greg      | Ostertag     | 218.44
 WAS | Brendan   | Haywood      | 213.36
(48 rows)
*/
						    


/*10. List the top 5 players who scored the most points in history. List their last and first names and the points they scored (hint: use "order by" to sort the results and 'limit xxx' to limit the number of rows returned);*/

SELECT player_rs_career.lastname, player_rs_career.firstname, pts
FROM player_rs_career
ORDER BY pts DESC LIMIT 5; 

/*
   lastname   | firstname |  pts  
--------------+-----------+-------
 Abdul-jabbar | Kareem    | 38387
 Malone       | Karl      | 36928
 Jordan       | Michael   | 32292
 Chamberlain  | Wilt      | 31419
 Malone       | Moses     | 27409
*/

/*11. List the name of the player who has the highest scoring efficiency (pts/minutes). List his name and scoring efficiency. Ignore those who played less than 50 minutes;*/

SELECT player.firstname, player.lastname, player.info
FROM (SELECT player_rs_career.firstname, player_rs_career.lastname, player_rs_career.pts, player_rs_career.minutes AS info
	FROM player_rs_career
	WHERE player_rs_career.minutes>50) player
	ORDER BY player.info DESC LIMIT 1;	

/*
 firstname |   lastname   | info  
-----------+--------------+-------
 Kareem    | Abdul-jabbar | 57446
*/

/*12. Suppose I want to compare the performance of Phil Jacksons and Allan Bristow in year 1994. List the name of the one who has more season win and the number of wins he got.*/

SELECT comp.firstname, comp.lastname, comp.season_win
FROM( SELECT DISTINCT * FROM coaches_season
      WHERE (coaches_season.firstname = 'Phil' AND coaches_season.lastname = 'Jacksons') OR (coaches_season.firstname = 'Allan' AND coaches_season.lastname = 'Bristow'))comp
WHERE comp.year = 1994
ORDER BY comp.season_win;

/*
 firstname | lastname | season_win 
-----------+----------+------------
 Allan     | Bristow  |     50
*/
