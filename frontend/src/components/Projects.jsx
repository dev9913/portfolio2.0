import React, { useEffect, useRef } from "react";


const projects = [
  {
    title: "CI/CD Pipeline",
    desc: "Automated build, test, security scan, and deployment using GitHub Actions.",
    tech: ["GitHub Actions", "Docker", "Linux"],
    link: "https://github.com/dev9913/GithubAction-project"
  },
  {
    title: "Kubernetes Microservices",
    desc: "Scalable microservices with autoscaling and observability.",
    tech: ["Kubernetes", "Helm", "Prometheus"],
    link: "https://github.com/dev9913/Proshop"
  },
  {
    title: "Terraform on AWS",
    desc: "Reusable Terraform modules for multi-env cloud infrastructure.",
    tech: ["Terraform", "AWS", "Git"],
    link: "https://github.com/dev9913/Terraform-aws"
  },
  {
    title: "Dockerized Web App",
    desc: "Production-ready containerized application.",
    tech: ["Docker", "Nginx", "CI/CD"],
    link: "https://github.com/dev9913/Mood-App-React"
  }
];

const Projects = () => {
  const itemsRef = useRef([]);

  useEffect(() => {
    const observer = new IntersectionObserver(
      entries => {
        entries.forEach(e => {
          if (e.isIntersecting) {
            e.target.classList.add("reveal");
          }
        });
      },
      { threshold: 0.25 }
    );

    itemsRef.current.forEach(el => el && observer.observe(el));
    return () => observer.disconnect();
  }, []);

  return (
    <section id="projects" className="project-stories">
      <h2 className="project-title"> Projects </h2>

      <div className="project-list">
        {projects.map((p, i) => (
          <a
            href={p.link}
            target="_blank"
            rel="noreferrer"
            key={i}
            ref={el => (itemsRef.current[i] = el)}
            className="project-row"
          >
            <span className="arrow">→</span>

            <div className="project-content">
              <h3>{p.title}</h3>
              <p>{p.desc}</p>

              <div className="tech-row">
                {p.tech.map(t => (
                  <span key={t}>{t}</span>
                ))}
              </div>
            </div>
          </a>
        ))}
      </div>
    </section>
  );
};

export default Projects;

