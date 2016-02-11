class CreateDashboard < ActiveRecord::Migration
  def change
    create_table :dashboards do |t|
        t.references :user
        t.text :theme
    end

    create_table :dashboard_widgets do |t|
        t.references :dashboard
        t.integer :position                     # - Nth position
        t.integer :sizex
        t.integer :sizey
        t.boolean :resizeable, :default=>true
        t.text :widget_type                     # - Polymorphic Association
        t.integer :widget_id                    # - ditto
    end

    create_table :content_slugs do |t|
        t.references :user
        t.text :content
        t.boolean :public
        t.integer :sizex
        t.integer :sizey
        t.boolean :resizeable, :default=>true
    end

  end
end
