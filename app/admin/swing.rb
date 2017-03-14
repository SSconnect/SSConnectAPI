ActiveAdmin.register Swing do
  permit_params :wrong,:correct,:created_at,:updated_at

  index do
    selectable_column
    id_column
    column :wrong
    column :correct
    column :created_at
    column :updated_at
    actions
  end

  filter :wrong
  filter :correct
  filter :created_at
  filter :updated_at

end
