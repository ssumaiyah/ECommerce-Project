# app/admin/user.rb
ActiveAdmin.register User do
  permit_params :name, :email, :password_digest

  filter :name

  index do
    selectable_column
    id_column
    column :name
    column :email
    actions
  end

  filter :name
  filter :email

  form do |f|
    f.inputs "User Details" do
      f.input :name
      f.input :email
      f.input :password_digest
    end
    f.actions
  end
end
