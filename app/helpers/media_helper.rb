module MediaHelper

  def media_form(&block)
    semantic_form_for([@sem_app, @media]) do |f|
      concat hidden_field_tag(:origin_id, @origin_id)

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
