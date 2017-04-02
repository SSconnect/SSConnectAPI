ActiveAdmin.register Blog do
  permit_params :title, :url, :rss, :selector
  actions :all, except: [:new, :destroy]

  index do
    selectable_column
    id_column
    column :title
    column :url
    column :rss
    column :selector
    column :updated_at
    column :created_at
    actions
  end

  filter :title
  filter :url
  filter :rss
  filter :updated_at
  filter :created_at

end
