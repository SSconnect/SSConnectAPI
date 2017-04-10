ActiveAdmin.register Bracket do
  permit_params :title

  index do
    selectable_column
    id_column
    column :title
    column :updated_at
    column :created_at
    actions
  end

  filter :title
  filter :updated_at
  filter :created_at

end
