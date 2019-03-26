# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|

  config.wrappers :horizontal_form, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
      b.use :html5
      b.use :placeholder
      b.use :label, class: 'col-sm-2 control-label'

      b.wrapper tag: 'div', class: 'col-sm-2' do |ba|
        ba.use :input, class: 'form-control'
        ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
        ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
      end
    end

    config.wrappers :horizontal_file_input, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
      b.use :html5
      b.use :placeholder
      b.use :label, class: 'col-sm-2 control-label'

      b.wrapper tag: 'div', class: 'col-sm-4' do |ba|
        ba.use :input
        ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
        ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
      end
    end

    config.wrappers :horizontal_boolean, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
      b.use :html5
      b.use :placeholder

      b.wrapper tag: 'div', class: 'col-sm-offset-3 col-sm-9' do |wr|
        wr.wrapper tag: 'div', class: 'checkbox' do |ba|
          ba.use :label_input, class: 'col-sm-9'
        end

        wr.use :error, wrap_with: { tag: 'span', class: 'help-block' }
        wr.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
      end
    end

    config.wrappers :horizontal_radio_and_checkboxes, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
      b.use :html5
      b.use :placeholder

      b.use :label, class: 'col-sm-3 control-label'

      b.wrapper tag: 'div', class: 'col-sm-9' do |ba|
        ba.use :input
        ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
        ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
      end
    end

    # Wrappers for forms and inputs using the Bootstrap toolkit.
    # Check the Bootstrap docs (http://getbootstrap.com)
    # to learn about the different styles for forms and inputs,
    # buttons and other elements.

  # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
  # Check the Bootstrap docs (http://twitter.github.com/bootstrap)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :horizontal_form

end
