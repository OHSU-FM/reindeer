module RoleAggregatesHelper
    ##
    # Should we show the agg selector box?
    def hf_show_agg_selector? ra
        return show_fname?(ra, :agg_fieldname) && ra.agg_enum.size > 1 # Excluding ["All", '']
    end

    ##
    # Should we show the email selector box?
    def hf_show_email_selector? ra
        show_fname?(ra, :pk_fieldname) && ra.pk_enum.size > 1 # Excluding ["All", '']
    end

    ##
    # What options should be shown on the aggregates dropdown (if shown at all)
    def hf_agg_opts
        return options_for_select(@agg_enum, @agg)
    end

    ##
    # What options should be shown on the aggregates dropdown (if shown at all)
    def hf_email_opts
        return options_for_select(@email_enum, @agg)
    end

    protected
    ##
    # Does the role_aggregate have a value for this method?
    def show_fname? ra, fname
        fval = ra.send(fname).to_s
        return false if fval.empty?     # not specified in ra
        #return false if @hidden_fields.include?(fval)
        return true
    end

end
