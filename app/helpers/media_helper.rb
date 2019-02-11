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
          concat f.input(:hidden, label: "Eintrag dauerhaft verstecken", required: false, as: :boolean, hint: "Solange der Harken gesetzt ist, wird der Eintrag für Ihre Studierenden nicht sichtbar sein.")
          concat f.input(:hidden_until, label: "Eintrag verstecken bis", required: false, as: :datetime_select, prompt: true, include_blank: false, minute_step: 5, labels: false, start_year: Date.today.year, hint: "Alternativ können Sie den Eintrag bis zu einem bestimmten Datum/Uhrzeit vor den Studierenden verstecken.")
        end
      )

      concat render('media/form_actions', form: f)
    end
  end

end
