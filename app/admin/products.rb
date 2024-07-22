# app/admin/product.rb

ActiveAdmin.register Product do

  filter :image_attachment_id
  permit_params :name, :description, :price, :quantity_available, :artisan_id, :image

  form do |f|
    f.semantic_errors *f.object.errors.full_messages

    f.inputs 'Product Details' do
      f.input :name
      f.input :description
      f.input :price
      f.input :quantity_available
      f.input :artisan_id, as: :select, collection: Artisan.all.map { |a| [a.name, a.id] }
      f.input :image, as: :file, hint: f.object.image.attached? ? image_tag(f.object.image.variant(resize_to_limit: [100, 100])) : content_tag(:span, "No image yet")
    end

    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :price
      row :quantity_available
      row :artisan
      row :image do |product|
        image_tag product.image.variant(resize_to_limit: [100, 100]) if product.image.attached?
      end
    end
    active_admin_comments
  end

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :price
    column :quantity_available
    column :artisan
    column :image do |product|
      image_tag product.image.variant(resize_to_limit: [50, 50]) if product.image.attached?
    end
    actions
  end
end
