use ipl;
#1.	#Show the percentage of wins of each bidder in the order of highest to lowest percentage
with win as (
select BIDDER_ID, 
sum(case when BID_STATUS like '%won%' then 1 else null end) as won 
from `ipl_bidding_details` group by BIDDER_ID)
select a.BIDDER_ID, 
(win.won/count(a.BID_STATUS))*100 as win_percentage 
from ipl_bidding_details a 
join win on a.BIDDER_ID = win.BIDDER_ID 
group by a.BIDDER_ID 
order by win_percentage desc;

 
 #2.	Display the number of matches conducted at each stadium with 
 #stadium name, city from the database.
 SELECT s.STADIUM_ID,s.STADIUM_NAME,s.CITY ,Count(ms.stadium_id) as matches_conducted
 FROM ipl_stadium as s 
 left join
 ipl_match_schedule as ms 
 on 
 s.stadium_id=ms.stadium_id
 group by s.STADIUM_ID;

#3.	In a given stadium, what is the percentage of wins by a team which has won the toss?
with wins as(
select MATCH_ID from ipl_match 
where TOSS_WINNER = MATCH_WINNER),
total as (
select STADIUM_ID, 
count(MATCH_ID)cnt 
from ipl_match_schedule group by STADIUM_ID)
select a.STADIUM_ID, 
(count(a.MATCH_ID)/total.cnt)*100 as win_percent 
from ipl_match_schedule a 
join wins on a.MATCH_ID = wins.MATCH_ID
join total on a.STADIUM_ID= total.STADIUM_ID 
group by a.STADIUM_ID;

 #4.	Show the total bids along with bid team and team name.
 select b.BID_TEAM, c.TEAM_NAME, 
count(a.NO_OF_BIDS) tot_bid
from ipl_bidder_points a join 
ipl_bidding_details b 
on a.BIDDER_ID = b.BIDDER_ID 
join ipl_team c on b.BID_TEAM = c.TEAM_ID
group by BID_TEAM;
#5.	Show the team id who won the match as per the win details.
SELECT TEAM_ID1,TEAM_ID2,WIN_DETAILS,
CASE
    WHEN WIN_DETAILS like "%CSK%" THEN '1'
    WHEN WIN_DETAILS like "%DD%" THEN '2'
    WHEN WIN_DETAILS like "%KXIP%" THEN '3'
    WHEN WIN_DETAILS like "%KKR%" THEN '4'
    WHEN WIN_DETAILS like "%MI%" THEN '5'
    WHEN WIN_DETAILS like "%RR%" THEN '6'
    WHEN WIN_DETAILS like "%RCB%" THEN '7'
    WHEN WIN_DETAILS like "%SRH%" THEN '8'
    ELSE 'Unknown Team'
END AS Winner_ID
FROM ipl_match;


#6.	Display total matches played,
 #total matches won and total matches lost by team along with its team name

 with won as (
select case when MATCH_WINNER = 1 then TEAM_ID1 else TEAM_ID2 end as teams, count(*) matches_won from ipl_match group by teams),
ma1 as (
select TEAM_ID1, count(TEAM_ID1) as onee from ipl_match group by TEAM_ID1),
ma2 as (
select TEAM_ID2, count(TEAM_ID2) as two from ipl_match group by TEAM_ID2)
select won.teams, c.TEAM_NAME, ma1.onee + ma2.two as total_matches, won.matches_won, (ma1.onee + ma2.two) - won.matches_won as lost
from ma1 join ma2 on ma1.TEAM_ID1 = ma2.TEAM_ID2 join won on ma2.TEAM_ID2  = won.teams join ipl_team c on won.teams = c.TEAM_ID;

 
 #7.	Display the bowlers for Mumbai Indians team.
 select tp.TEAM_ID,tp.PLAYER_ID,tp.PLAYER_ROLE,p.PLAYER_NAME
 from ipl_team_players as tp
 join 
 ipl_player as p
 on tp.PLAYER_ID=p.PLAYER_ID
 where tp.team_id=5 and tp.player_role="Bowler"
 group by tp.player_id;
 
#8.	How many all-rounders are there in each team, Display the teams with more than 4 
#all-rounder in descending order.
 select tp.TEAM_ID,tp.PLAYER_ROLE,
count(tp.PLAYER_ROLE) as All_rounder 
 from ipl_team_players as tp
 join 
 ipl_player as p
 on tp.PLAYER_ID=p.PLAYER_ID
 where  tp.player_role="All-Rounder"  
group by tp.TEAM_ID 
having All_rounder > 4 
order by All_rounder desc ;
 

 
