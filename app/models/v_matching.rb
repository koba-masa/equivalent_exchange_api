# frozen_string_literal: true

class VMatching < ApplicationRecord
  # これいる？交換テーブルから引っ張ってくるじゃだめ？
  # 懸念：レスポンスの形式が変わってしまう
  # 懸念：最終的な交換の履歴・変遷はどのように管理する
  scope :untrading, -> { where(my_want_status: 0, your_stock_status: 0, your_want_status: 0, my_stock_status: 0) }

  def self.candidate_matchings_by_want(my_user_id, my_want_id)
    where(my_user_id:, my_want_id:)
  end

  def self.find_candidate_matching!(my_user_id, my_want_id, your_stock_id, your_want_id, my_stock_id)
    find_by!(my_user_id:, my_want_id:, your_stock_id:, your_want_id:, my_stock_id:)
  end

  def image_url
    "#{Settings.stock.image.domain}/#{Settings.aws.s3.stock_image_prefix}/#{your_stock_image}"
  end
end
