module ActiveAdminImportable
  module DSL
    def active_admin_importable(&block)
      importable(:convert_save, &block)
    end
    
    def active_admin_importable_with_end_block(&block)
      importable(:convert_save_with_end_block, &block)
    end
    
    def importable(convert_save_method, &block)
      action_item :only => :index do
        link_to "Import #{active_admin_config.resource_name.to_s.pluralize}", :action => 'upload_csv'
      end
      
      collection_action :upload_csv do
        render "admin/csv/upload_csv"
      end
      
      collection_action :import_csv, :method => :post do
        CsvDb.send(convert_save_method ,active_admin_config.resource_class, params[:dump][:file], &block)
        redirect_to :action => :index, :notice => "#{active_admin_config.resource_name.to_s} imported successfully!"
      end
    end
  end
end
