require 'date'

Review.delete_all
Source.delete_all

t=DateTime.new(2013, 7, 1).to_time
r = Review.create(user: User.first,
                  title: "Faculty Review FY15",
                  clinical_fte: 0.9,
                  research_fte: 0.0,
                  research_grant_fte: 0.0,
                  research_dept_fte: 0.0,
                  administrative_fte: 0.0,
                  total_fte: 0.9,
                  hire_date: t
                 )

Source.create(review: r, sourceable: RoleAggregate.first)
