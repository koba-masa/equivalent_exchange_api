SELECT
    wants.id AS want_id
  , wants.user_id
  , v_characters.category_name
  , v_characters.goods_name
  , v_characters.character_name
  , v_characters.category_id
  , v_characters.good_id
  , v_characters.character_id
FROM
  wants
  INNER JOIN v_characters ON wants.character_id = v_characters.character_id
ORDER BY
    user_id
  , v_characters.category_id
  , v_characters.good_id
  , v_characters.character_id
;
