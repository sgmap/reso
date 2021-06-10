# == Schema Information
#
# Table name: iframes
#
#  id              :bigint(8)        not null, primary key
#  css             :integer
#  format          :integer
#  name            :string
#  partner         :string
#  partner_website :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  institution_id  :bigint(8)
#
# Indexes
#
#  index_iframes_on_institution_id  (institution_id)
#
class Iframe < ApplicationRecord
  enum format: { full: 0, subjects: 1, form: 3 }

  has_many :landings
  has_many :landing_options
  has_many :landing_topics
  has_many :solicitations
end
