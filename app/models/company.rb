# frozen_string_literal: true

class Company < ApplicationRecord
  has_many :contacts
  has_many :facilities

  validates :name, presence: true
  validates :siren, uniqueness: { allow_nil: true }

  scope :ordered_by_name, (-> { order(:name) })

  def to_s
    name
  end

  def name_short
    name.first(40)
  end
end
