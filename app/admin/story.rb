ActiveAdmin.register Story do
  permit_params :title, :last_posted_at, tags:[]

  index do
    selectable_column
    id_column
    column :title
    column :tag_list  # Show all tags AND checked already selected one (by relations through :tags - input must named :tags)
    column :last_posted_at
    column :updated_at
    column :created_at
    actions
  end

  form do |f|
    f.inputs "Main info" do
      f.input :title
      f.input :last_posted_at
      f.input :tags,  # Show all tags AND checked already selected one (by relations through :tags - input must named :tags)
              as: :select,
              multiple: :true,
              collection: ActsAsTaggableOn::Tag.select(:id, :name).all
    end
    f.actions
  end

  filter :title
  filter :tags,  # Show all tags AND checked already selected one (by relations through :tags - input must named :tags)
         collection: ActsAsTaggableOn::Tag.select(:id, :name)
  filter :last_posted_at
  filter :updated_at
  filter :created_at

end
