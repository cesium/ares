export default {
  mounted() {
    // Auto-dismiss flash after 3 seconds
    const timeout = this.el.dataset.autoDismiss || 3000;
    
    setTimeout(() => {
      this.dismissFlash();
    }, parseInt(timeout));
  },

  dismissFlash() {
    // Fade out effect
    this.el.style.transition = 'opacity 0.3s ease-out';
    this.el.style.opacity = '0';
    
    // Remove from DOM after fade completes
    setTimeout(() => {
      this.el.remove();
    }, 300);
  }
};
