const SOLID_CLASSES = ['bg-glass', 'backdrop-blur-sm'];

export const HeaderScroll = {
  mounted() {
    const hero = document.getElementById('hero');
    if (!hero) return;

    this.el.classList.remove(...SOLID_CLASSES);

    this.observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          this.el.classList.remove(...SOLID_CLASSES);
        } else {
          this.el.classList.add(...SOLID_CLASSES);
        }
      },
      { threshold: 0 }
    );

    this.observer.observe(hero);
  },

  destroyed() {
    this.observer?.disconnect();
  }
};
