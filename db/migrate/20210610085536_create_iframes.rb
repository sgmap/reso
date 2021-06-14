class CreateIframes < ActiveRecord::Migration[6.1]
  def change
    create_table :iframes do |t|
      t.string :name
      t.string :partner
      t.string :partner_website
      t.integer :format
      t.integer :css
      t.references :institution

      t.timestamps
    end

    add_reference :landings, :iframe, index: true, foreign_key: true
    add_reference :landing_options, :iframe, index: true, foreign_key: true
    add_reference :landing_topics, :iframe, index: true, foreign_key: true
    add_reference :solicitations, :iframe, index: true, foreign_key: true
    add_column :institutions, :css, :string
  end
end
