ActiveAdmin.register Landing do
  menu parent: :themes, priority: 3

  includes :landing_topics, :landing_options

  ## Index
  #
  index do
    selectable_column
    column :slug do |l|
      div admin_link_to l
    end
    column I18n.t("activerecord.models.landing.one") do |l|
      div link_to l.title, landing_path(l.slug) if l.slug.present?
      div l.subtitle
      div l.logos&.truncate(50, separator: ', '), style: 'color: gray'
    end
    column :meta do |l|
      div l.meta_title
      div l.meta_description, style: 'color: gray'
    end
    column :landing_topics do |l|
      l.landing_topics.present? ? l.landing_topics.length : '-'
    end
    column :landing_options do |l|
      l.landing_options.present? ? l.landing_options.length : '-'
    end
    actions dropdown: true
  end

  ## Show
  #
  show title: :slug do
    attributes_table do
      row :slug do |l|
        div link_to l.slug, landing_path(l.slug) if l.slug.present?
      end
      row :created_at
      row :updated_at
    end

    attributes_table title: I18n.t("activerecord.attributes.landing.featured_on_home") do
      row :home_title
      row :home_description
      row :home_sort_order
      row :emphasis do |l|
        status_tag l.emphasis.to_bool
      end
    end

    panel I18n.t("activerecord.models.landing.one") do
      attributes_table_for landing do
        row :meta_title
        row :meta_description
      end

      attributes_table_for landing do
        row :title
        row :subtitle
        row :logos
      end
    end

    attributes_table title: I18n.t('activerecord.attributes.landing.landing_topics') do
      row :landing_topic_title
      row :message_under_landing_topics do |l|
        l.message_under_landing_topics&.html_safe
      end

      table_for landing.landing_topics.ordered_for_landing do
        column :title
        column :description do |topic|
          topic.description&.html_safe
        end
      end
    end

    attributes_table title: I18n.t('activerecord.attributes.landing.landing_options') do
      table_for landing.landing_options.ordered_for_landing do
        column :slug
        column :preselected_subject_slug
        column :preselected_institution_slug
        column :form_title
        column :form_description
      end
    end

    attributes_table title: I18n.t("landings.show_solicitation_form.form") do
      row :description_example
      row :form_bottom_message
      row :form_promise_message
      row :thank_you_message
    end
  end

  ## Form
  #
  landing_options_attributes = [
    :id, :slug, :landing_sort_order,
    :preselected_institution_slug, :preselected_subject_slug,
    :_destroy, :form_description, :form_title
  ]
  landing_topics_attributes = [:id, :title, :description, :landing_sort_order, :_destroy]
  permit_params :slug,
                :home_title, :home_description, :home_sort_order,
                *Landing::CONTENT_KEYS,
                landing_options_attributes: landing_options_attributes,
                landing_topics_attributes: landing_topics_attributes

  form title: :slug do |f|
    f.inputs do
      f.input :slug
    end

    f.inputs I18n.t("activerecord.attributes.landing.featured_on_home") do
      f.input :home_title
      f.input :home_description, input_html: { rows: 2 }
      f.input :home_sort_order, input_html: { style: 'width:80px' }
      f.input :emphasis, as: :boolean
    end

    panel I18n.t("activerecord.models.landing.one") do
      f.inputs do
        f.input :meta_title
        f.input :meta_description
      end

      f.inputs do
        f.input :title
        f.input :subtitle
        f.input :logos
      end
    end

    f.inputs I18n.t('activerecord.attributes.landing.landing_topics') do
      f.input :landing_topic_title, placeholder: t('landings.show_landing_topics.default_landing_topic_title').html_safe
      f.input :message_under_landing_topics, as: :text, input_html: { rows: 3 },
              placeholder: t('landings.show_landing_topics.default_message_under_landing_topics').html_safe

      f.has_many :landing_topics, sortable: :landing_sort_order, sortable_start: 1, allow_destroy: true, new_record: true do |t|
        t.input :title, input_html: { style: 'width:70%' }
        t.input :description, input_html: { style: 'width:70%', rows: 10 }
      end
    end

    f.inputs I18n.t('activerecord.attributes.landing.landing_options') do
      f.has_many :landing_options, sortable: :landing_sort_order, sortable_start: 1, allow_destroy: true, new_record: true do |o|
        o.input :slug, input_html: { style: 'width:70%' }
        o.input :preselected_subject_slug, input_html: { style: 'width:70%' }, as: :datalist, collection: Subject.pluck(:slug)
        o.input :preselected_institution_slug, input_html: { style: 'width:70%' }, as: :datalist, collection: Institution.pluck(:slug)
        o.input :form_title, input_html: { style: 'width:70%' }
        o.input :form_description, as: :text, input_html: { style: 'width:70%', rows: 10 }
      end
    end

    f.inputs I18n.t("landings.show_solicitation_form.form") do
      f.input :description_example, placeholder: t('landings.show_solicitation_form.description.default_example').html_safe
      f.input :form_bottom_message
      f.input :form_promise_message, placeholder: t('landings.show_solicitation_form.default_promise_message').html_safe
      f.input :thank_you_message, placeholder: t('landings.show_thank_you.default_thank_you_message').html_safe
    end

    f.actions
  end
end
