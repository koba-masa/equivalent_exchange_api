SELECT
    characters.id AS character_id
  , categories.name AS category_name
  , goods.name AS goods_name
  , characters.name AS character_name
  , categories.id AS category_id
  , goods.id AS good_id
FROM
  characters
  INNER JOIN goods ON characters.good_id = goods.id
  INNER JOIN categories ON goods.category_id = categories.id
ORDER BY
    category_id
  , good_id
  , character_id
;
