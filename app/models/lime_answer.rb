class LimeAnswer < ActiveRecord::Base

   attr_accessor :mystring


   self.inheritance_column = nil
   self.primary_key = :qid, :code
   belongs_to :lime_question, primary_key: "qid", :foreign_key=>:qid, :inverse_of=>:lime_answers
   has_one :lime_group, :through=>:lime_question, :inverse_of=>:lime_answers

    rails_admin do
        navigation_label "Lime Survey"
    end

   def my_column_name(question)
	@my_column_name ||= "#{lime_question.sid}X#{lime_question.gid}X#{lime_question.qid}"
    result = @my_column_name
	# add suffix to questions that are actually subquestions
	if question.is_sq?
		result += "#{question.title}"
	end
	return result
   end

   def text_data(question)
	q_name = my_column_name(question)
       	r_data = lime_group.dataset.find{|tt|tt[q_name]}
    	return r_data
   end


end

