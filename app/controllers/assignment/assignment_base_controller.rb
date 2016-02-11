module Assignment
  class AssignmentBaseController < ApplicationController
    layout :check_layout

    protected
    def check_layout
      if params[:layout] == 'false'
        false
      else
        'full_width'
      end
    end

  end
end

