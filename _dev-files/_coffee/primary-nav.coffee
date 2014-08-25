###
  We need to add a class of `responsive-nav--open` to
  `#js-responsive-nav` ONLY when the nav is clicked AND
  when we’re on a viewport of less than `responsiveNavBreakpoint`.
  It needs removing when someone re-clicks the nav icon, or
  when the viewport no longer matches `responsiveNavBreakpoint`.
###

siteNav = document.getElementById('js-primary-nav');
siteNavBreakpoint = 720;

siteNav.addEventListener 'click', () =>
  console.log 'open';
  if window.innerWidth < siteNavBreakpoint
    siteNav.classList.toggle 'primary-nav--open'