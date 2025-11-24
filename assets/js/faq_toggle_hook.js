const FaqToggleHook = {
  mounted() {
    console.log('FaqToggle hook mounted');
    
    this.el.addEventListener('click', (e) => {
      const button = e.target.closest('button[data-faq-id]');
      if (!button) return;
      
      e.preventDefault();
      
      const faqId = button.dataset.faqId;
      const content = document.getElementById(`content-${faqId}`);
      const icon = document.getElementById(`icon-${faqId}`);
      
      console.log('FAQ clicked:', faqId, 'Content found:', !!content, 'Icon found:', !!icon);
      
      if (!content || !icon) return;
      
      // Check if currently expanded
      const isExpanded = button.getAttribute('aria-expanded') === 'true';
      
      if (isExpanded) {
        // Collapse
        content.classList.remove('max-h-screen', 'opacity-100', 'pb-4', 'sm:pb-5', 'md:pb-6');
        content.classList.add('max-h-0', 'opacity-0');
        icon.classList.remove('rotate-180');
        button.setAttribute('aria-expanded', 'false');
      } else {
        // Expand
        content.classList.remove('max-h-0', 'opacity-0');
        content.classList.add('max-h-screen', 'opacity-100', 'pb-4', 'sm:pb-5', 'md:pb-6');
        icon.classList.add('rotate-180');
        button.setAttribute('aria-expanded', 'true');
      }
    });
  }
};

export default FaqToggleHook;
