const MobileNavigationHook = {
  mounted() {
    console.log("MobileNavigation hook mounted");
    
    // Wait for DOM to be ready
    setTimeout(() => {
      this.initializeNavigation();
    }, 100);
  },

  initializeNavigation() {
    this.openNavButton = this.el.querySelector("#open-nav-button");
    this.closeNavButton = this.el.querySelector("#close-nav-button");
    this.menuModal = this.el.querySelector("#menu-modal");
    this.header = this.el;
    this.page = document.documentElement;

    console.log("Navigation elements:", {
      openButton: this.openNavButton,
      closeButton: this.closeNavButton,
      modal: this.menuModal
    });

    if (!this.openNavButton || !this.closeNavButton || !this.menuModal) {
      console.error("Navigation elements not found");
      return;
    }

    // Open menu function
    this.openMenu = () => {
      console.log("Opening menu");
      this.menuModal.classList.remove("hidden");
      this.menuModal.setAttribute("aria-hidden", "false");
      document.body.style.overflow = "hidden";
    };

    // Close menu function
    this.closeMenu = () => {
      console.log("Closing menu");
      this.menuModal.classList.add("hidden");
      this.menuModal.setAttribute("aria-hidden", "true");
      document.body.style.overflow = "";
    };

    // Event listeners
    this.openNavButton.addEventListener("click", (e) => {
      e.preventDefault();
      e.stopPropagation();
      this.openMenu();
    });

    this.closeNavButton.addEventListener("click", (e) => {
      e.preventDefault();
      e.stopPropagation();
      this.closeMenu();
    });

    // Close menu when clicking on links
    const menu = this.menuModal.querySelector("ul");
    if (menu) {
      menu.addEventListener("click", (event) => {
        if (event.target.tagName === "A") {
          this.closeMenu();
        }
      });
    }

    // Scroll event for fixed header behavior
    this.handleScroll = () => {
      if (this.header && this.page) {
        const d = this.page.clientHeight - this.page.scrollTop - this.header.offsetHeight;
        this.header.classList.toggle("fixed-header", d < 0);
      }
    };

    document.addEventListener("scroll", this.handleScroll);

    // Close menu on escape key
    this.handleKeyDown = (event) => {
      if (event.key === "Escape" && !this.menuModal.classList.contains("hidden")) {
        this.closeMenu();
      }
    };

    document.addEventListener("keydown", this.handleKeyDown);

    console.log("Navigation initialized successfully");
  },

  destroyed() {
    console.log("MobileNavigation hook destroyed");
    
    // Clean up event listeners
    if (this.openNavButton) {
      this.openNavButton.removeEventListener("click", this.openMenu);
    }

    if (this.closeNavButton) {
      this.closeNavButton.removeEventListener("click", this.closeMenu);
    }

    if (this.handleScroll) {
      document.removeEventListener("scroll", this.handleScroll);
    }
    
    if (this.handleKeyDown) {
      document.removeEventListener("keydown", this.handleKeyDown);
    }

    // Reset body overflow
    document.body.style.overflow = "";
  }
};

export default MobileNavigationHook;
