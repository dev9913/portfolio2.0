// import React from 'react';

// // Static skills array (no need for useState or useMemo)
// const skills = [
//   { icon: '☁️', title: 'Cloud', percent: 70 },
//   { icon: '🐳', title: 'Containers', percent: 80 },
//   { icon: '📜', title: 'IaC', percent: 80 },
//   { icon: '⚙️', title: 'CI/CD', percent: 70 },
//   { icon: '🐚', title: 'Scripting', percent: 60 },
//   { icon: '🗂️', title: 'Version Control', percent: 70 },
//   { icon: '🔒', title: 'Security', percent: 60 },
//   { icon: '📈', title: 'Monitoring', percent: 80 },
// ];

// const Skills = () => {
//   return (
//     <section id="skills">
//       <h2 className="section-title">My Skills</h2>
//       <div className="skills-grid">
//         {skills.map((skill, index) => (
//           <div key={index} className="skill-card">
//             <div className="skill-icon">{skill.icon}</div>
//             <h3>{skill.title}</h3>
//             <div className="skill-percentage">
//               <span>{skill.percent}%</span>
//             </div>
//           </div>
//         ))}
//       </div>
//     </section>
//   );
// };

// export default Skills;


// import { useEffect, useRef } from "react";

// const skills = [
//   { title: "Cloud", percent: 70 },
//   { title: "Containers", percent: 80 },
//   { title: "IaC", percent: 80 },
//   { title: "CI/CD", percent: 70 },
//   { title: "Scripting", percent: 60 },
//   { title: "Version Control", percent: 70 },
//   { title: "Security", percent: 60 },
//   { title: "Monitoring", percent: 80 },
// ];

// const Skills = () => {
//   const skillRefs = useRef([]);

//   useEffect(() => {
//     const observer = new IntersectionObserver(entries => {
//       entries.forEach(entry => {
//         if (entry.isIntersecting) {
//           entry.target.style.width = entry.target.dataset.percent + "%";
//         }
//       });
//     }, { threshold: 0.5 });

//     skillRefs.current.forEach(ref => observer.observe(ref));
//   }, []);

//   return (
//     <section id="skills">
//       <h2 className="section-title">My Skills</h2>
//       <div className="skills-grid">
//         {skills.map((skill, index) => (
//           <div key={index} className="skill-card">
//             <h3>{skill.title}</h3>
//             <div className="skill-bar">
//               <span ref={el => skillRefs.current[index] = el} data-percent={skill.percent}></span>
//             </div>
//             <span>{skill.percent}%</span>
//           </div>
//         ))}
//       </div>
//     </section>
//   );
// };

// export default Skills;
import React, { useEffect, useRef } from "react";

const skills = [
  { icon: "☁️", title: "Cloud", percent: 70 },
  { icon: "🐳", title: "Containers", percent: 80 },
  { icon: "📜", title: "IaC", percent: 80 },
  { icon: "⚙️", title: "CI/CD", percent: 70 },
  { icon: "🐚", title: "Scripting", percent: 60 },
  { icon: "🗂️", title: "Version Control", percent: 70 },
  { icon: "🔒", title: "Security", percent: 60 },
  { icon: "📈", title: "Monitoring", percent: 80 },
];

const Skills = () => {
  const circleRefs = useRef([]);

  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            const circle = entry.target.querySelector(".progress");
            const percent = circle.dataset.percent;
            const radius = circle.r.baseVal.value;
            const circumference = 2 * Math.PI * radius;
            const offset = circumference - (percent / 100) * circumference;
            circle.style.strokeDashoffset = offset;

            // Animate percentage number
            const numberSpan = entry.target.querySelector(".circle span");
            let current = 0;
            const interval = setInterval(() => {
              if (current < percent) {
                current++;
                numberSpan.textContent = current + "%";
              } else {
                clearInterval(interval);
              }
            }, 15);
          }
        });
      },
      { threshold: 0.5 }
    );

    circleRefs.current.forEach((el) => observer.observe(el));
  }, []);

  return (
    <section id="skills">
      <h2 className="section-title">My Skills</h2>
      <div className="skills-grid">
        {skills.map((skill, index) => (
          <div
            key={index}
            className="skill-card"
            ref={(el) => (circleRefs.current[index] = el)}
          >
            {/* Icon and Skill Name on top */}
            <div className="skill-top">
              <div className="skill-icon">{skill.icon}</div>
              <h3 className="skill-title">{skill.title}</h3>
            </div>

            {/* Circular progress below */}
            <div className="circle">
              <svg width="100" height="100">
                <circle cx="50" cy="50" r="45" />
                <circle
                  className="progress"
                  cx="50"
                  cy="50"
                  r="45"
                  data-percent={skill.percent}
                />
              </svg>
              <span>0%</span>
            </div>
          </div>
        ))}
      </div>
    </section>
  );
};

export default Skills;
