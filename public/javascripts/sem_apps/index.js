(function($) {

  $(function() {
    $("a[rel]").overlay({
      // some expose tweaks suitable for modal dialogs
      expose: {
        color: '#333',
        loadSpeed: 550,
        opacity: 0.6
      },

      closeOnClick: false
    });
  });

})(jQuery)