export default () => {
  $(document).ready(function(){
    const smoothScroll = new SmoothScroll('a[href^="#"]', {
      offset: 10,
    })

    if(window.location.hash) {
      const anchor = document.querySelector(window.location.hash);
      if (anchor) {
         smoothScroll.animateScroll(anchor, undefined, { offset: 40 });
      }
    }

    const $body = $('.Vlt-main');
    const nav = $('.Nxd-header');
    const codeNav = $('.Nxd-api__code .tabs--code');

    $body.on('scroll', function(){   
      var scrollTop = $body.scrollTop();
      
      //navigation
      if (scrollTop > 50) {
        nav.addClass('Nxd-scroll-minify');
      } else {
        nav.removeClass('Nxd-scroll-minify');
      }

      //api code
      if (scrollTop > 70 && codeNav.length > 0) {
        codeNav.addClass('tabs--sticky');
      } else if(codeNav.length > 0) {
        codeNav.removeClass('tabs--sticky');
      }
    });
  })
}
