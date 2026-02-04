import React, { useEffect, useState } from "react";
import {
  DiDocker,
  DiJenkins,
  DiGithubBadge
} from "react-icons/di";
import {
  SiAmazon,
  // SiKubernetes,
  SiTerraform,
  SiVault,
  SiPrometheus,
  // SiGrafana,
  // SiAnsible,
  SiLinux
} from "react-icons/si";


const commands = [
  {
    cmd: "aws --version",
    icon: SiAmazon,
    output: ["AWS CLI"]
  },
  {
    cmd: "docker info",
    icon: DiDocker,
    output: ["Docker", "Kubernetes"]
  },
  {
    cmd: "jenkins --status",
    icon: DiJenkins,
    output: ["Jenkins", "GitHub Actions", "ArgoCD"]
  },
  {
    cmd: "terraform plan",
    icon: SiTerraform,
    output: ["Terraform", "Ansible"]
  },
  {
    cmd: "monitoring stack",
    icon: SiPrometheus,
    output: ["Prometheus", "Grafana"]
  },
  {
    cmd: "vault status",
    icon: SiVault,
    output: ["Vault"]
  },
  {
    cmd: "git status",
    icon: DiGithubBadge,
    output: ["GitHub"]
  },
  {
    cmd: "uname -a",
    icon: SiLinux,
    output: ["Linux"]
  }
];

const Skills = () => {
  const [visible, setVisible] = useState(0);

  useEffect(() => {
    if (visible < commands.length) {
      const timer = setTimeout(() => {
        setVisible(v => v + 1);
      }, 400);
      return () => clearTimeout(timer);
    }
  }, [visible]);

  return (
    <section id="skills" className="terminal-section">
      <h2 className="terminal-title">Skills</h2>

      <div className="terminal-window">
        <div className="terminal-header">
          <span className="dot red" />
          <span className="dot yellow" />
          <span className="dot green" />
        </div>

        <div className="terminal-body">
          {commands.slice(0, visible).map((item, i) => {
            const Icon = item.icon;
            return (
              <div key={i} className="terminal-line">
                <span className="prompt">$</span> {item.cmd}
                <div className="terminal-output">
                  <Icon className="terminal-icon" />
                  {item.output.join(", ")}
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
};

export default Skills;

