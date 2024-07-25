ActiveAdmin.register Product do
  filter :image_attachment_id
  permit_params :name, :description, :price, :quantity_available, :artisan_id, :image, category_ids: [], new_category_name: nil

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

    f.inputs 'Categories' do
      f.input :category_ids, as: :check_boxes, collection: Category.all.map { |c| [c.name, c.id] }
      f.input :new_category_name, as: :string, input_html: { value: params.dig(:product, :new_category_name) }, label: 'Add New Category'
    end

    f.actions
  end

  controller do
    def create
      new_category_name = params.dig(:product, :new_category_name)
      if new_category_name.present?
        new_category = Category.find_or_create_by(name: new_category_name)
        params[:product][:category_ids] ||= []
        params[:product][:category_ids] << new_category.id unless params[:product][:category_ids].include?(new_category.id.to_s)
      end

      super
    end

    def update
      new_category_name = params.dig(:product, :new_category_name)
      if new_category_name.present?
        new_category = Category.find_or_create_by(name: new_category_name)
        params[:product][:category_ids] ||= []
        params[:product][:category_ids] << new_category.id unless params[:product][:category_ids].include?(new_category.id.to_s)
      end

      super
    end
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
      row :categories do |product|
        product.categories.map(&:name).join(', ')
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
    column :categories do |product|
      product.categories.map(&:name).join(', ')
    end 
    actions
  end
end
