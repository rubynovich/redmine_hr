module HrCandidatesHelper
  def details_to_strings(details, no_html=false, options={})
    details.map do |detail|
      show_detail(detail, no_html, options)
    end
  end

  def show_detail(detail, no_html=false, options={})
    multiple = false
    field = detail.prop_key.to_s.gsub(/\_id$/, "")
    label = l(("field_" + field).to_sym)
    case detail.prop_key
      when 'due_date', 'birth_date'
        value = format_date(detail.value.to_date) if detail.value
        old_value = format_date(detail.old_value.to_date) if detail.old_value

      when 'project_id', 'status_id', 'tracker_id', 'assigned_to_id',
           'priority_id', 'category_id', 'fixed_version_id',
           'hr_status_id', 'hr_job_id'
        value = find_name_by_reflection(field, detail.value)
        old_value = find_name_by_reflection(field, detail.old_value)      
    end

    label ||= detail.prop_key
    value ||= detail.value
    old_value ||= detail.old_value

    unless no_html
      label = content_tag('strong', label)
      old_value = content_tag("i", h(old_value)) if detail.old_value
      old_value = content_tag("strike", old_value) if detail.old_value and detail.value.blank?
      value = content_tag("i", h(value)) if value
    end

    if detail.property == 'attr' && detail.prop_key == 'description'
      s = l(:text_journal_changed_no_detail, :label => label)
      unless no_html
        diff_link = link_to 'diff',
          {:controller => 'journals', :action => 'diff', :id => detail.journal_id,
           :detail_id => detail.id, :only_path => options[:only_path]},
          :title => l(:label_view_diff)
        s << " (#{ diff_link })"
      end
      s.html_safe
    elsif detail.value.present?
      if detail.old_value.present?
        l(:text_journal_changed, :label => label, :old => old_value, :new => value).html_safe
      elsif multiple
        l(:text_journal_added, :label => label, :value => value).html_safe
      else
        l(:text_journal_set_to, :label => label, :value => value).html_safe
      end
    else
      l(:text_journal_deleted, :label => label, :old => old_value).html_safe
    end
  end

  def find_name_by_reflection(field, id)
    association = HrCandidate.reflect_on_association(field.to_sym)
    if association
      record = association.class_name.constantize.find_by_id(id)
      return record.name if record
    end
  end
end


