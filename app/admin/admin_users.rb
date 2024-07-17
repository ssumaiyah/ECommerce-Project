ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, category_ids: []
  permit_params :name, :description, :price, :image
  permit_params :artisan_id, :name, :description, :price, :quantity_available

  
  
  filter :image
  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :categories, as: :check_boxes
    end
    f.actions
  end

end
