# app/admin/user.rb
ActiveAdmin.register User do
  permit_params :name, :email,:password, :password_confirmation

  filter :name

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :encrypted_password
    actions
  end

  filter :name
  filter :email

  form do |f|
    f.inputs "User Details" do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
      
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :email
      row :encrypted_password
      row :created_at
      row :updated_at
      row :province
    end
    active_admin_comments
  end
  
end
