ActiveAdmin.register Page do


    permit_params :title, :content
  
    form do |f|
      f.inputs do
        f.input :title
        f.input :content
      end
      f.actions
    end

  
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
 
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :content]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
