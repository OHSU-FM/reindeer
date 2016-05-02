require 'rails_helper'

class DataMakerTest < ActiveSupport::TestCase

    test "should have records to test" do
        assert MetaAttribute::MetaAttributeQuestion.count > 0
    end

    test "should never crash" do
        MetaAttribute::MetaAttributeQuestion.where(:visible=>true)
            .where("data_type != 'text'")
            .includes(:meta_attribute_entity).each do |question| 
            unless question.meta_attribute_entity.visible
                next
            end
            
            data_maker = EdnaConsole::DataMaker.new [question]
            begin
                data_maker.dataset
                assert true
            rescue ActiveRecord::StatementInvalid => e
                puts 'IT CRASHED!'
                puts question.inspect
                puts data_maker.query
                assert false
            end
            puts 'Didnt crash'
        end
    end

end
