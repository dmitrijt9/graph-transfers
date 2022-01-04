LOAD CSV WITH HEADERS FROM 'file:///transfers.csv' AS row
MERGE (player:Player {name: row.player_name}) SET player.age=toInteger(row.age), player.position=row.position
MERGE (club:Club {name: row.club_name}) SET club.league=row.league_name
MERGE (transfer:Transfer {club:club.name, movement: row.transfer_movement, season: row.season, playerName: player.name }) SET transfer.fee=toFloat(row.fee_cleaned),transfer.clubInvolved=row.club_involved_name
WITH player,club,transfer,
  (CASE transfer.movement
  WHEN 'in' THEN 'BOUGHT'
  WHEN 'out' THEN 'SOLD'
  ELSE 'BOUGHT' END) AS clubPlayerRelation
CALL apoc.merge.relationship(club, clubPlayerRelation, {season: transfer.season},{}, player) YIELD rel
WITH player,club,transfer,
  (CASE transfer.movement
  WHEN 'in' THEN 'REALIZED_BUY'
  WHEN 'out' THEN 'REALIZED_SELL'
  ELSE 'REALIZED_BUY' END) AS clubTransferRelation
CALL apoc.create.relationship(club, clubTransferRelation,{}, transfer) YIELD rel
MERGE (player)-[r:INVOLVED_IN]->(transfer)
RETURN player,club,transfer
;