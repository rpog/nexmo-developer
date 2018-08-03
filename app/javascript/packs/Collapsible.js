export default () => {
  $(document).on('click', '.Vlt-accordion__trigger', function() {
    const $element = $(this)
    const id = $element.data('collapsible-id')

    console.log('here')
    
    if ($element.hasClass('Vlt-accordion__trigger')) {
      $element.toggleClass('Vlt-accordion__trigger_active')
    } else {
      $element.parent('.Vlt-accordion__trigger').toggleClass('Vlt-accordion__trigger_active')
    }

    $(`#${id}`).toggleClass('Vlt-accordion__content_open')
  })
}
