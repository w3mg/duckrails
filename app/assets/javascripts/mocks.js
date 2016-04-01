var first_error_tab = null;

$(function(){
  $('form.mock-form').find('.tabs-content .content').each(function(index, element) {
    var $element = $(element);
    var elementId = $element.prop('id');
    var $tabLink = $('a[href="#' + elementId + '"]');

    if ($element.find('small.error').length) {
      $tabLink.addClass('error');

      if (!first_error_tab) {
        first_error_tab = $tabLink;
      }
    }
  });

  if (first_error_tab) {
    first_error_tab.trigger('click');
  }
});
