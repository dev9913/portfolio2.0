import React from "react";

const skills = [
  { icon: "☁️", title: "Cloud", level: "70%" },
  { icon: "🐳", title: "Containers", level: "80%" },
  { icon: "📜", title: "IaC", level: "80%" },
  { icon: "⚙️", title: "CI/CD", level: "70%" },
  { icon: "🐚", title: "Scripting", level: "60%" },
  { icon: "🗂️", title: "Version Control", level: "70%" },
  { icon: "🔒", title: "Security", level: "60%" },
  { icon: "📈", title: "Monitoring", level: "80%" },
];

const Skills = () => {
  return (
    <section id="skills">
      <h2 className="section-title">My Skills</h2>

      <div className="skills-wheel">
        {skills.map((skill, index) => (
          <div className="skill-item" key={index}>
            <div className="skill-icon">{skill.icon}</div>
            <h3>{skill.name}</h3>
            <div className="skill-level">{skill.level}</div>
          </div>
        ))}
      </div>
    </section>
  );
};

export default Skills;
