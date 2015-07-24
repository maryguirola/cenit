module RailsAdmin
  module Config
    module Actions
      class Execute < RailsAdmin::Config::Actions::Base

        register_instance_option :only do
          [Setup::Algorithm]
        end

        register_instance_option :member do
          true
        end

        register_instance_option :http_methods do
          [:post, :get]
        end

        register_instance_option :controller do
          proc do

            if @object.parameters.empty? || params[:_run]
              begin
                @output = @object.execute(@input = params.delete(:input))
              rescue Exception => ex
                @error = ex.message
              end
            end
            render :execute
          end
        end

        register_instance_option :link_icon do
          'icon-play'
        end

        register_instance_option :pjax do
          false
        end
      end
    end
  end
end