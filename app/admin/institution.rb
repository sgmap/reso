# frozen_string_literal: true

ActiveAdmin.register Institution do
  menu parent: :experts, priority: 2

  show do
    attributes_table do
      row :name
      row :email
      row :phone_number
      row :created_at
      row :updated_at
    end

    panel I18n.t('activerecord.models.expert.other') do
      table_for institution.experts do
        column I18n.t('activerecord.attributes.expert.full_name'), (proc { |expert| link_to(expert, admin_expert_path(expert)) })
        column :email
      end
    end
  end

  filter :experts, collection: -> { Expert.ordered_by_names }
  filter :name
  filter :created_at
  filter :updated_at
  filter :qualified_for_commerce
  filter :qualified_for_artisanry
end
