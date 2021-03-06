package net.rrm.ehour.ui.common.panel.datepicker;

import net.rrm.ehour.ui.common.component.ValidatingFormComponentAjaxBehavior;
import org.apache.wicket.ajax.AjaxRequestTarget;
import org.apache.wicket.ajax.form.AjaxFormComponentUpdatingBehavior;
import org.apache.wicket.behavior.SimpleAttributeModifier;
import org.apache.wicket.markup.html.IHeaderContributor;
import org.apache.wicket.markup.html.IHeaderResponse;
import org.apache.wicket.markup.html.form.TextField;
import org.apache.wicket.model.IModel;
import org.apache.wicket.util.convert.IConverter;
import org.apache.wicket.validation.ValidationError;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.util.Date;
import java.util.Locale;

public class DateInputField extends TextField<Date> implements IHeaderContributor {

    private static final DateTimeFormatter FORMATTER = DateTimeFormat.forStyle("S-");

    public DateInputField(String id, IModel<Date> dateIModel) {
        super(id, dateIModel);

        add(new ValidatingFormComponentAjaxBehavior());
    }

    @Override
    public IConverter getConverter(Class<?> type) {
        return new IConverter() {
            @Override
            public Object convertToObject(String value, Locale locale) {
                try {
                    return FORMATTER.parseDateTime(value).toDate();
                } catch (IllegalArgumentException iae) {
                    AjaxRequestTarget target = AjaxRequestTarget.get();

                    if (target != null) {
                        DateInputField.this.add(new RedBorderModifier());
                        target.addComponent(DateInputField.this);
                    }

                    error("failure");
                    return null;
                }


            }

            @Override
            public String convertToString(Object value, Locale locale) {
                return FORMATTER.print(new DateTime(value));
            }
        };
    }

    @Override
    public void renderHead(IHeaderResponse response) {
        if (isVisible()) {
            response.renderOnDomReadyJavascript(enableDatePickerJavascript());
        }
    }

    public String enableDatePickerJavascript() {
        return String.format("$('#%s').datepicker({changeMonth:true,changeYear:true})", getMarkupId());
    }

    private static class RedBorderModifier extends SimpleAttributeModifier {
        public RedBorderModifier() {
            super("style", "width: 5em;border-color: #ff0000");
        }

        @Override
        public boolean isTemporary() {
            return true;
        }
    }
}
