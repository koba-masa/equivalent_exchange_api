# frozen_string_literal: true

class VMatching < ApplicationRecord
  def self.candidate_matchings_by_want(my_user_id, my_want_id)
    where(my_user_id:, my_want_id:)
  end

  def self.find_candidate_matching(my_user_id, my_want_id, your_stock_id)
    find_by(my_user_id:, my_want_id:, your_stock_id:)
  end

  def image_url
    "#{Settings.stock.image.domain}/#{Settings.aws.s3.stock_image_prefix}/#{your_stock_image}"
  end
end
