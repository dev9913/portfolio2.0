// import React, { useState, useRef } from 'react';

// const Navbar = () => {
//   const [isOpen, setIsOpen] = useState(false);
//   const navLinksRef = useRef(null);

//   const toggleMenu = () => setIsOpen(!isOpen);
//   const closeMenu = () => setIsOpen(false);

//   return (
//     <header id="header">
//       <nav className="navbar">
//         <div className="logo">DevOps<span>Engineer</span></div>
//         <ul className={`nav-links ${isOpen ? 'open' : ''}`} ref={navLinksRef} id="navLinks">
//           <li><a href="#hero" onClick={closeMenu}>Home</a></li>
//           <li><a href="#about" onClick={closeMenu}>About</a></li>
//           <li><a href="#projects" onClick={closeMenu}>Projects</a></li>
//           <li><a href="#skills" onClick={closeMenu}>Skills</a></li>
//           <li><a href="#experience" onClick={closeMenu}>Experience</a></li>
//           <li><a href={`${process.env.REACT_APP_API_URL}/contact`} onClick={closeMenu}>Contact</a></li>

//         </ul>
//         <div className="menu-toggle" id="menuToggle" onClick={toggleMenu}>
//           <i className="fas fa-bars"></i>
//         </div>
//       </nav>
//     </header>
//   );
// };

// export default Navbar;


// import React, { useState, useEffect } from "react";

// const Navbar = () => {
//   const [isOpen, setIsOpen] = useState(false);
//   const [scrolled, setScrolled] = useState(false);

//   useEffect(() => {
//     const onScroll = () => setScrolled(window.scrollY > 40);
//     window.addEventListener("scroll", onScroll);
//     return () => window.removeEventListener("scroll", onScroll);
//   }, []);

//   const navItems = ["home", "about", "projects", "skills", "experience"];

//   return (
//     <header className={`navbar ${scrolled }? "scrolled" : ""}`}>
//       <div className="logo">
//         DevOps<span>Engineer</span>
//       </div>

//       <ul className={`nav-links ${isOpen ? "open" : ""}`}>
//         {navItems.map((item) => (
//           <li key={item}>
//             <a href={`#${item}`} onClick={() => setIsOpen(false)}>
//               {item.charAt(0).toUpperCase() + item.slice(1)}
//             </a>
//           </li>
//         ))}

//         {/* External link for Contact */}
//         <li>
//           <a
//             href={`${process.env.REACT_APP_API_URL}/contact`}
//             target="_blank"
//             rel="noopener noreferrer"
//             onClick={() => setIsOpen(false)}
//           >
//             Contact
//           </a>
//         </li>
//       </ul>

//       <div className="menu-toggle" onClick={() => setIsOpen(!isOpen)}>
//         ☰
//       </div>
//     </header>
//   );
// };

// export default Navbar;

import React, { useState, useEffect } from "react";

const Navbar = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 40);
    window.addEventListener("scroll", onScroll);
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  const navItems = ["home", "about", "projects", "skills", "experience"];

  return (
    <header className={`navbar ${scrolled ? "scrolled" : ""}`}>
      <div className="logo">
        DevOps<span>Engineer</span>
      </div>

      <ul className={`nav-links ${isOpen ? "open" : ""}`}>
        {navItems.map((item) => (
          <li key={item}>
            <a href={`#${item}`} onClick={() => setIsOpen(false)}>
              {item.charAt(0).toUpperCase() + item.slice(1)}
            </a>
          </li>
        ))}

        <li>
          <a
            href={`${process.env.REACT_APP_API_URL}/contact`}
            target="_blank"
            rel="noopener noreferrer"
            onClick={() => setIsOpen(false)}
          >
            Contact
          </a>
        </li>
      </ul>

      <div className="menu-toggle" onClick={() => setIsOpen(!isOpen)}>
        ☰
      </div>
    </header>
  );
};

export default Navbar;
