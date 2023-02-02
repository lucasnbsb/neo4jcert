// MODELING THE RATING 

MATCH (sandy:User {name: 'Sandy Jones'})
MATCH (clinton:User {name: 'Clinton Spencer'})
MATCH (apollo:Movie {title: 'Apollo 13'})
MATCH (sleep:Movie {title: 'Sleepless in Seattle'})
MATCH (hoffa:Movie {title: 'Hoffa'})
MERGE (sandy)-[:RATED {rating:5}]->(apollo)
MERGE (sandy)-[:RATED {rating:4}]->(sleep)
MERGE (clinton)-[:RATED {rating:3}]->(apollo)
MERGE (clinton)-[:RATED {rating:3}]->(sleep)
MERGE (clinton)-[:RATED {rating:3}]->(hoffa)

// Testing the instance model
MATCH (:Person) RETURN count(*)
MATCH (:Movie) RETURN count(*)
MATCH ()-[:DIRECTED]->() RETURN count(*)
match ()-[:ACTED_IN]->() return count(*)


// Adding labels
MATCH (p:Person) WHERE exists ((p)-[:DIRECTED]-()) SET p:Director

// REFACTORING WITH UNWIND
MATCH (m:Movie)
UNWIND m.languages AS language
WITH  language, collect(m) AS movies
MERGE (l:Language {name:language})
WITH l, movies
UNWIND movies AS m
WITH l,m
MERGE (m)-[:IN_LANGUAGE]->(l);
MATCH (m:Movie)
SET m.languages = null

// REFACTORING LIST PROPERTIES INTO NODES
MATCH (m:Movie)
UNWIND m.genres AS genre
MERGE (g:Genre {name: genre})
MERGE (m)-[:IN_GENRE]->(g)
SET m.genres = null

// REFACTORING FOR INTEMEDIARY NODES
MATCH (a:Actor)-[r:ACTED_IN]->(m:Movie)
MERGE (role:Role {name: r.role})
MERGE (a)-[:PLAYED]->(role)
MERGE (role)-[:IN_MOVIE]->(m)