SELECT
  -- 自分
    my_wants.user_id AS my_user_id
  -- 相手
  , your_stocks.user_id AS your_user_id
  , your_users.display_name AS your_user_name

  -- 商品情報
  , my_wants.category_id
  , my_wants.category_name
  , my_wants.good_id
  , my_wants.goods_name

  -- 自分の欲しいもの(=相手の譲るもの)
  , my_wants.want_id AS my_want_id
  , my_wants.character_id AS my_want_character_id
  , my_wants.character_name AS my_want_character_name
  , my_wants.status AS my_want_status
  , your_stocks.stock_id AS your_stock_id
  , your_stocks.image AS your_stock_image
  , your_stocks.status AS your_stock_status

  -- 相手の欲しいもの(=自分の譲るもの)
  , your_wants.want_id AS your_want_id
  , your_wants.character_id AS your_want_character_id
  , your_wants.character_name AS your_want_character_name
  , your_wants.status AS your_want_status
  , my_stocks.stock_id AS my_stock_id
  , my_stocks.status AS my_stock_status

FROM
  v_wants AS my_wants
  INNER JOIN v_stocks AS your_stocks ON my_wants.character_id = your_stocks.character_id AND my_wants.user_id <> your_stocks.user_id
  INNER JOIN v_wants AS your_wants ON your_wants.user_id = your_stocks.user_id AND my_wants.good_id = your_wants.good_id
  INNER JOIN v_stocks AS my_stocks ON my_wants.user_id = my_stocks.user_id AND my_wants.good_id = my_stocks.good_id AND your_wants.character_id = my_stocks.character_id
  INNER JOIN users AS your_users ON your_users.id = your_stocks.user_id
ORDER BY
    my_user_id
  , your_user_id
  , category_id
  , good_id
  , my_want_character_id
  , your_want_character_id
;
