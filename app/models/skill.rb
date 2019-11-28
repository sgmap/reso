# == Schema Information
#
# Table name: skills
#
#  id          :bigint(8)        not null, primary key
#  description :text
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  subject_id  :bigint(8)        not null
#
# Indexes
#
#  index_skills_on_subject_id  (subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (subject_id => subjects.id)
#

class Skill < ApplicationRecord
  ## Associations
  #
  belongs_to :subject, inverse_of: :skills

  has_many :experts_skills, dependent: :destroy, inverse_of: :skill
  has_many :experts, through: :experts_skills, inverse_of: :skills
  has_many :matches, inverse_of: :skill

  ## Validations
  #
  validates :title, :subject, presence: true

  ## Through Associations
  #
  has_one :theme, through: :subject, inverse_of: :skills

  ## Scopes
  #
  scope :support_skills, -> do
    where(subject: Subject.support_subject)
  end

  ##
  #
  def to_s
    title
  end
end
