module ActiveModel
  module Translation
    # CarDealer.sales_count -> s_('CarDealer|Sales count') -> 'Sales count' if no translation was found
    def human_attribute_name(attribute, *args)
      s_(gettext_translation_for_attribute_name(attribute))
    end

    def gettext_translation_for_attribute_name(attribute)
      attribute = attribute.to_s
      if attribute.ends_with?('_id')
        humanize_class_name(attribute)
      else
        "#{owner_in_class_hierarchy(attribute)}|#{attribute.split('.').map! {|a| a.humanize }.join('|')}"
      end
    end

    def owner_in_class_hierarchy(attribute)
      superclass = self.superclass

      if superclass.class_has_attribute?(attribute)
        superclass.owner_in_class_hierarchy(attribute)
      else
        self
      end
    end

    def class_has_attribute?(attribute)
      self != ActiveRecord::Base && !self.abstract_class? && self.column_names.include?(attribute)
    end

    def humanize_class_name(name=nil)
      name ||= self.to_s
      name.underscore.humanize
    end
  end
end
