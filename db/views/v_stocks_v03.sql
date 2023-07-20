SELECT
    stocks.id AS stock_id
  , stocks.user_id
  , v_characters.category_name
  , v_characters.goods_name
  , v_characters.character_name
  , stocks.status
  , stocks.image
  , v_characters.category_id
  , v_characters.good_id
  , v_characters.character_id
FROM
  stocks
  INNER JOIN v_characters ON stocks.character_id = v_characters.character_id
ORDER BY
    user_id
  , v_characters.category_id
  , v_characters.good_id
  , v_characters.character_id
;
