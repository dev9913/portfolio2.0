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
          
            <div className="skill-top">
              <div className="skill-icon">{skill.icon}</div>
              <h3 className="skill-title">{skill.title}</h3>
            </div>

            
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
