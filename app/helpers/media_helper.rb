module MediaHelper

  def media_form(&block)
    semantic_form_for([@sem_app, @media]) do |f|
      if params[:origin_id].present?
        concat hidden_field_tag(:origin_id, params[:origin_id])
      end

      if params[:scroll_to].present?
        concat hidden_field_tag(:scroll_to, params[:scroll_to])
      end

      yield f

      concat(
        f.inputs do
          f.input(:hidden, label: "Eintrag verstecken", as: :boolean, hint: "Wenn Sie den Haken setzen, wird der Eintrag für Ihre Studierenden nicht sichtbar sein.")
        end
      )

      concat render('media/form_actions', form: f)
    end
  end

end
