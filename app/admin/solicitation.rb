ActiveAdmin.register Solicitation do
  menu priority: 7

  ## Index
  #
  scope :all, default: true

  index do
    selectable_column
    column :solicitation do |s|
      div admin_link_to(s)
      div l(s.created_at, format: '%Y-%m-%d %H:%M')
    end
    column :description do |s|
      div link_to s.slug, landing_path(s.slug) if s.slug
      options = s.selected_options
      if options.present?
        div t('activerecord.attributes.solicitation.selected_options') + ' : ' do
          options.each { |option| status_tag option }.join('')
        end
      end
      blockquote simple_format(s.description&.truncate(20000, separator: ' '))
    end

    column "#{t('attributes.coordinates')} | #{t('activerecord.attributes.solicitation.tracking')}" do |s|
      div do
        if s.siret.present?
          link_to s.siret, company_path(s.siret)
        else
          t('active_admin.solicitations.no_siret')
        end
      end
      div s.full_name
      div s.normalized_phone_number
      div mail_to(s.email)
      hr
      render 'solicitations/tracking', solicitation: s
      if s.partner_token.present?
        admin_attr(s, :institution)
      end
    end
  end

  ## CSV
  #
  csv do
    column :id
    column :created_at
    column :description
    column :siret
    column :full_name
    column :phone_number
    column :email
    Solicitation::FORM_INFO_KEYS.each{ |k| column k }
  end

  ## Show
  #
  show title: :to_s do
    panel I18n.t('attributes.description') do
      if solicitation.slug
        div link_to solicitation.slug, landing_path(solicitation.slug)
      end
      blockquote simple_format(solicitation.description)
    end

    attributes_table title: t('attributes.coordinates') do
      row :siret do |s|
        if s.siret.present?
          div link_to s.siret, company_path(s.siret)
        end
      end
      row :full_name
      row :phone_number
      row :email
    end

    attributes_table title: t('activerecord.attributes.solicitation.tracking') do
      row :tracking do |s|
        render 'solicitations/tracking', solicitation: s
      end
      row :institution
    end
  end

  sidebar I18n.t('activerecord.models.solicitation.one'), only: :show do
    attributes_table_for solicitation do
      row :created_at
      row :updated_at
    end
  end

  ## Form
  #
  permit_params :description, :siret, :full_name, :phone_number, :email
  form do |f|
    f.inputs do
      f.input :description, as: :text
      f.input :siret
      f.input :full_name
      f.input :phone_number
      f.input :email
    end

    f.actions
  end
end
