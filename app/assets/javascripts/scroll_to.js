$(function() {
  var scrollTo = $("body").attr("data-scroll-to");

  if (scrollTo && scrollTo.length > 0) {
    var elem = $('#' + scrollTo);
    $('html,body').scrollTop(elem.offset().top);
  }
})
