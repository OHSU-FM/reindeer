class DashboardWidgetsController < ApplicationController
    layout 'full_width'

    def show_widget
        authorize! :read, @dash
        respond_to do |format|
            format.html{ render :layout=>false} # show
            format.json{ render :json=>{:dash=>@dash}}
        end

    end

    def new
        @dash = Dashboard.new
    end

    def create
        authorize! :create, Dashboard
        @dash = Dashboard.new(params[:dashboard])
        @dash.user_id = current_user.id
        respond_to do |format|
            if @dash.save
                format.html{ render :action=>:index  }
                format.json{ render :json=>{:dash=>@dash},
                    :status=>:ok
                }
            else
                format.html{ render :action => "new" }
                format.json{ render :json =>{:dash=>@dash},
                    :status => :unprocessable_entity
                }
            end
        end
    end

    def update
        @dash = Dashboard.find(params[:id].to_i)
        authorize! :update, @dash

        respond_to do |format|
            if @dash.update_attributes(params[:dashboard])
                format.html{ render :action=>:index}
                format.json{ render :json=>{:dash=>@dash},
                    :status=>:ok
                }
            else
                format.html{ render :action => :edit }
                format.json{ render :json =>{:dash=>@dash},
                    :status => :unprocessable_entity
                }
            end
        end
    end

end


