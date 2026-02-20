import React, { useState, useEffect } from "react";


const Navbar = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);

  // Handle scroll effect
  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 40);
    window.addEventListener("scroll", onScroll);
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  // Close mobile menu when resizing to desktop
  useEffect(() => {
    const handleResize = () => {
      if (window.innerWidth > 768) {
        setIsOpen(false);
      }
    };
    window.addEventListener("resize", handleResize);
    return () => window.removeEventListener("resize", handleResize);
  }, []);

  const navItems = ["hero", "about", "projects", "skills", "experience"];

  return (
    <header className={`navbar ${scrolled ? "scrolled" : ""}`}>
      {/* Logo */}
      <div className="logo">
        DevOps<span>Engineer</span>
      </div>

      {/* Mobile Toggle Icon (Switch between ☰ and ✕) */}
      <button
        className="menu-toggle"
        onClick={() => setIsOpen(!isOpen)}
        aria-label="Toggle navigation"
      >
        {isOpen ? "✕" : "☰"}
      </button>

      {/* Navigation Links */}
      <ul className={`nav-links ${isOpen ? "open" : ""}`}>
        {navItems.map((item) => (
          <li key={item}>
            <a
              href={`#${item}`}
              onClick={() => setIsOpen(false)} // Close menu on click
            >
              {item.charAt(0).toUpperCase() + item.slice(1)}
            </a>
          </li>
        ))}

        {/* External Contact Link */}
        <li>
          <a
            href="/api/contact"
            target="_blank"
            rel="noopener noreferrer"
            onClick={() => setIsOpen(false)}
          >
            Contact
          </a>
        </li>
      </ul>
    </header>
  );
};

export default Navbar;
