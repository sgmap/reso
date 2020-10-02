# == Schema Information
#
# Table name: experts_subjects
#
#  id                     :bigint(8)        not null, primary key
#  description            :string
#  role                   :integer          default("specialist"), not null
#  expert_id              :bigint(8)
#  institution_subject_id :bigint(8)
#
# Indexes
#
#  index_experts_subjects_on_expert_id                             (expert_id)
#  index_experts_subjects_on_expert_id_and_institution_subject_id  (expert_id,institution_subject_id) UNIQUE
#  index_experts_subjects_on_institution_subject_id                (institution_subject_id)
#  index_experts_subjects_on_role                                  (role)
#
# Foreign Keys
#
#  fk_rails_...  (expert_id => experts.id)
#  fk_rails_...  (institution_subject_id => institutions_subjects.id)
#

class ExpertSubject < ApplicationRecord
  self.table_name = 'experts_subjects' # Workaround a rubocop bug in UniqueValidationWithoutIndex. The rubocop `table_name` helper seems to fail with join tables.

  enum role: { specialist: 0, fallback: 1 }
  audited associated_with: :expert
  audited max_audits: 10

  ## Associations
  #
  belongs_to :expert
  belongs_to :institution_subject

  ## "Through" associations
  #
  has_one :subject, through: :institution_subject, inverse_of: :experts_subjects
  has_one :theme, through: :subject, inverse_of: :experts_subjects

  ## Validations
  #
  validates :role, presence: true
  validates :expert, uniqueness: { scope: :institution_subject_id }

  ## Scopes
  #
  scope :relevant_for, -> (need) do
    of_subject(need.subject)
      .in_commune(need.facility.commune)
  end

  scope :of_subject, -> (subject) do
    joins(:institution_subject)
      .where(institutions_subjects: { subject: subject })
  end

  scope :in_commune, -> (commune) do
    where(expert: commune.all_experts)
  end

  scope :of_institution, -> (institution) do
    joins(institution_subject: :institution)
      .where(institutions_subjects: { institution: institution })
  end

  scope :support_for, -> (diagnosis) do
    experts_in_commune = diagnosis.facility.commune.all_experts

    support.where(expert: experts_in_commune)
  end

  scope :support, -> { where(institution_subject: InstitutionSubject.support_subjects) }

  scope :ordered_for_interview, -> do
    joins(:subject)
      .merge(Subject.ordered_for_interview)
  end

  ## used for serialization in advisors csv
  #
  def csv_description
    description.presence || I18n.t('yes')
  end

  def csv_description=(value)
    if value.downcase.in? ['x', I18n.t('yes')]
      self.description = ''
    else
      self.description = value
    end
  end
end
