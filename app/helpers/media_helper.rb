module MediaHelper

  def media_form(&block)
    semantic_form_for([@sem_app, @media]) do |f|
      concat hidden_field_tag(:origin_id, @origin_id)
      yield f
      concat render('media/form_actions', form: f)
    end
  end

end
