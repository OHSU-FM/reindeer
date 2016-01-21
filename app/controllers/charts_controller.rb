class ChartsController < ApplicationController
    layout 'full_width_margins'

    def index
        redirect_to(:action=>:new) unless current_user.id
        @charts = Chart.
            where(:user_id=>current_user.id).
            order('created_at DESC')

        if @charts.size == 0
            redirect_to :action=>:new
        end
    end

    def new
        # Allow pre-building of a chart
        @chart = Chart.new(params[:chart])
        @chart.chart_series.build if @chart.chart_series.size == 0
        @chart.user = current_user
        add_default_col_rows
        respond_to do |format|
            format.html{ render :layout=>show_layout?} # show
            format.json{ render json: {:chart=>@chart} }
        end
    end

    def show
        @chart = Chart.find(params[:id].to_i)
        # Show changes in attributes without making any saves
        @chart.assign_attributes(params[:chart])
        @chart.valid?
        respond_to do |format|
            format.html{ render :layout=>show_layout?} # show
            format.json{ render :json=>{:chart=>@chart}}
        end
    end

    def edit
        @chart = Chart.find(params[:id].to_i)
        # Show changes in attributes without making any saves
        @chart.assign_attributes(params[:chart])
        @chart.valid?
        add_default_col_rows
        # Show changes in attributes without making any saves
        respond_to do |format|
            format.html{ render :layout=>show_layout?} # show
            format.json{ render :json=>{:chart=>@chart}}
        end
    end

    def create
        @chart = Chart.new(params[:chart])
        @chart.user_id = current_user.id

        respond_to do |format|
            if @chart.save
                flash[:success] = "Chart Created"
                format.html{ redirect_to edit_chart_path(@chart) }
                format.json{ render :json=>@chart,
                    :status=>:ok,
                    :include=>:chart_series
                }
            else
                flash.now[:error] = 'Unable to create chart.'
                debugger
                format.html{ render :action => "new", :layout=>show_layout?}
                format.json{ render :json =>@chart,
                    :include=>:chart_series,
                    :status => :unprocessable_entity
                }
            end
        end
    end

    def update
        @chart = Chart.includes(:chart_series).find(params[:id].to_i)
        respond_to do |format|
            if @chart.update_attributes(params[:chart])
                flash[:notice] = 'Chart Updated'
                format.html{ redirect_to edit_chart_path(@chart) }
                format.json{ render :json=>@chart,
                    :status=>:ok,
                    :include=>:chart_series
                }
            else
                flash.now[:error] = 'Unable to update chart'
                raise err
                format.html{ render :action => :edit, :layout=>show_layout?}
                format.json{ render :json =>@chart,
                    :status => :unprocessable_entity
                }
            end
        end
    end

    def destroy
        @chart = Chart.find(params[:id])
        @chart.destroy
        simple_redirect :to=>charts_path,
            :json=>[@chart, :status=>:ok]
    end

    private
    def show_layout?
        case params[:layout]
            when 'false'
                return false
            when 'widget'
                return 'widget'
            else
                return true
        end
    end

    ##
    # Add a column or row if there is a new series that has been finished
    def add_default_col_rows
        series = @chart.chart_series.select{|cs| cs.ready_for_data? }
        return if series.empty?
        if @chart.cols.empty?
            @chart.cols.push series.first.attribute_name
        elsif @chart.rows.empty?
            @chart.rows.push series.first.attribute_name
        end
    end

end
