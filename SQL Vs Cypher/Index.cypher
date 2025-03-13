PROFILE
MATCH (n:Order)
WHERE n.shipName = "Hanari Carnes"
RETURN count(n)


CREATE INDEX order_index FOR (n:Order) ON (n.shipName)