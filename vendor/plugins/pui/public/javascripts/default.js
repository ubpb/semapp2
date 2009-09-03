jQuery(function() {
    jQuery('.pui-button').hover(
        function() { jQuery(this).addClass('ui-state-hover'); },
        function() { jQuery(this).removeClass('ui-state-hover'); }
    );

    // Tooltips for PUI forms
    jQuery("form.puiform div.pui-tooltip").tooltip({
      position: ['center', 'right'],
      offset: [-2, 10],
      effect: 'toggle',
      opacity: 0.8
    });
});