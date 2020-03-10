module EpaMastersHelper

  def hf_format_date (in_date)
    if !in_date.nil?
      in_date = in_date.strftime("%m/%d/%Y")
    else
      return ""
    end
  end

  def hf_redact_text (review_rec)
    str_html1 = ''
    str_html2 = ''

    if !review_rec.reviewer1.blank? and review_rec.reviewer2.blank?
        # redact review1 data

        # #str_html = review_rec.badge_decision1 + " / " +
        #             review_rec.reviewer1 + " / " +
        #             review_rec.general_comments1  + " / "
        #str_html = '<span class="redact">' + str_html + '</span>'
        str_html1 = 'EG Reviewer1 <span class="glyphicon glyphicon-ok" style="color:green;"></span>'

    end
    if review_rec.reviewer1.blank? and !review_rec.reviewer2.blank?
          # redact review2 data

          # str_html = review_rec.badge_decision2 + " / " +
          #             review_rec.reviewer2 + " / " +
          #             review_rec.general_comments2  + " / "
          # str_html = '<span class="redact" style="color:black">' + str_html + '</span>'
          str_html2 = 'EG Reviewer2 <span class="glyphicon glyphicon-ok" style="color:green;"></span>'

    end

    if !review_rec.reviewer1.blank? and !review_rec.reviewer2.blank?
      if review_rec.badge_decision1 == "Badge"
          str_html1 = '<span class="text-success">' + review_rec.badge_decision1 + '</span>'
      else
          str_html1 = '<span class="bg-danger text-white">' + review_rec.badge_decision1 + '</span>'
      end
      str_html1 = str_html1 + ' / ' + review_rec.reviewer1 + ' / ' + review_rec.general_comments1
      if review_rec.badge_decision2 == "Badge"
          str_html2 = '<span class="text-success">' + review_rec.badge_decision2 + '</span>'
      else
          str_html2 = '<span class="bg-danger text-white">' + review_rec.badge_decision2 + '</span>'
      end
      str_html2 = str_html2 + ' / ' + review_rec.reviewer2 + ' / ' + review_rec.general_comments2
    end

    return str_html1, str_html2

  end

end
