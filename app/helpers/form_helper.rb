module FormHelper
  class ActionView::Helpers::FormBuilder
    def custom_text_field(field_name, label_name)
      object_name = self.object.class.name.downcase
      err = self.object.errors.on field_name
      ret = []
      if err
        ret << %Q(<p class="inputRow fieldWithErrors">)
      else
        ret << %Q(<p class="inputRow">)
      end
      ret << %Q(<label for="#{object_name}_#{field_name}">#{label_name}</label>)
      ret << %Q(<input id="#{object_name}_#{field_name}" class="bigText" name="#{object_name}[#{field_name}]" />)
      if err
        ret << %Q(<span>#{err}</span>)
      end
      ret << %Q(</p>)
      ret.join
    end
  end
end
