export const HeaderScroll = {
  mounted() {
    // Mark the link to the current page; in the dock and the mobile menu, styled via `current:`.
    for (const a of document.querySelectorAll('nav a')) {
      if (a.origin === location.origin && a.pathname === location.pathname) a.setAttribute('aria-current', 'page');
    }
  }
};
