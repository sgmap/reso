ActiveAdmin.register Iframe do
  menu parent: :themes, priority: 4

  includes :landing_topics, :landing_options
  ## Form
  #
  permit_params :name, :partner, :partner_website, :landing_options, :landing_topics, :landing_ids, :format

  form do |f|
    f.inputs do
      f.input :format
      f.input :name
      f.input :partner
      f.input :partner_website
      f.input :landings, as: :ajax_select, data: { url: :admin_landings_path, search_fields: [:title] }
      # f.input :landing_topics, as: :ajax_select, data: { url: :admin_landing_topics_path, search_fields: [:slug] }
      # f.input :landing_options, as: :ajax_select, data: { url: :admin_landing_options_path, search_fields: [:slug] }
    end

    f.actions
  end
end
