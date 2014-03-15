$('.details-link').click(
    function() {
        $('#' + this.id.replace('l', 'a')).toggle();
    }
);