ActiveAdmin.register ActsAsTaggableOn::Tag do
  permit_params :name, :taggings_count

  index do
    selectable_column
    id_column
    column :name
    column :taggings_count
    column :updated_at
    column :created_at
    actions
  end

  form do |f|
    f.inputs "Main info" do
      f.input :name
      f.input :taggings_count
    end
    f.actions
  end

  filter :name
  filter :taggings_count

end
