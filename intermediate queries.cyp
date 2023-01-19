// Multiple Match Clauses
MATCH (m:Movie) WHERE m.title = "Kiss Me Deadly"
MATCH (m)-[:IN_GENRE]->(g:Genre)<-[:IN_GENRE]-(rec:Movie)
MATCH (m)<-[:ACTED_IN]-(a:Actor)-[:ACTED_IN]->(rec)
RETURN rec.title, a.name

// Optional Match
MATCH (m:Movie)-[:IN_GENRE]->(g:Genre)
WHERE g.name = 'Film-Noir'
OPTIONAL MATCH (m)<-[:RATED]-(u:User)
RETURN m.title, u.name

// ORDERING AND FILTERING
MATCH (m:Movie)
WHERE m.imdbRating is not null
RETURN m.title
ORDER BY m.imdbRating DESC

// MULTIPLE ORDERING
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE m.imdbRating IS NOT NULL
RETURN p.name, m.imdbRating
ORDER BY m.imdbRating DESC,  p.born

// FIND LOWEST
MATCH (m:Movie)
WHERE m.imdbRating IS NOT NULL
RETURN m.imdbRating
ORDER BY m.imdbRating LIMIT 1

// Eliminating duplicate names
MATCH (p:Person)-[:ACTED_IN| DIRECTED]->(m)
WHERE m.title = 'Toy Story'
MATCH (p)-[:ACTED_IN]->()<-[:ACTED_IN]-(p2:Person)
WHERE p.name <> p2.name
RETURN  DISTINCT(p.name), p2.name

// COLLECTING NODES
MATCH (p:Person)-[:DIRECTED]->(m:Movie)
return p.name, size(collect(m.title)) as directedMovies
order by directedMovies DESC

// CREATING LISTS
MATCH (m:Movie) <-[:ACTED_IN]- (p:Person)
RETURN DISTINCT(m.title), size(collect(p.name)) as counActors
ORDER BY counActors DESC

// list comprehension
MATCH (n:Movie)
WHERE n.imdbRating IS NOT NULL and n.poster IS NOT NULL
WITH n{.title, .imdbRating, 
[(actor:Person)-[:ACTED_IN]->(n) | actor.name],
[(n)-[:IN_GENRE]->(gen) | gen.name]
}
ORDER BY n.imdbRating DESC LIMIT 4
RETURN collect(n)

// PIPELINING
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)<-[r:RATED]-(:User)
where p.name = 'Tom Hanks'
WITH avg(r.rating) as avgr, m
RETURN avgr, m.title
ORDER BY avgr DESC limit 1

// UNWIND
MATCH (m:Movie)
UNWIND m.countries as cnt
with m, trim(cnt) as country
with country, count(m.title) as movies
return country, movies 