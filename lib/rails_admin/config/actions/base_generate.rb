module RailsAdmin
  module Config
    module Actions
      class BaseGenerate < RailsAdmin::Config::Actions::Base

        register_instance_option :only do
          Setup::Schema
        end

        register_instance_option :http_methods do
          [:get, :post]
        end

        register_instance_option :controller do
          proc do
            source = @object || params[:bulk_ids]
            options_config = RailsAdmin::Config.model(Forms::GenerateOptions)
            if options_params = params[options_config.abstract_model.param_key]
              options_params = options_params.select { |k, _| %w(override_data_types).include?(k.to_s) }.permit!
            else
              options_params = {}
            end
            @options = Forms::GenerateOptions.new(options_params)
            ok = false
            begin
              Cenit::Actions.generate_data_types(source, @options.attributes)
              ok = true
            rescue Exception => ex
              do_flash(:error, 'Error generating data types:', ex.message)
            end if params[:_generate]
            if ok
              redirect_to back_or_index
            else
              conflicting_data_types = []
              @new_data_types_count = 0
              (data_type_schemas = Cenit::Actions.data_type_schemas(source)).values.each do |h|
                @new_data_types_count += h.size
                conflicting_data_types += Setup::DataType.any_in(name: h.keys).to_a
              end
              @new_data_types_count -= conflicting_data_types.length
              @options.instance_variable_set(:@_to_override, conflicting_data_types)
              @object.instance_variable_set(:@_to_override, conflicting_data_types)
              @model_config = options_config
              render :generate
            end
          end
        end

        register_instance_option :link_icon do
          'icon-cog'
        end

        register_instance_option :pjax? do
          false
        end
      end
    end
  end
end
