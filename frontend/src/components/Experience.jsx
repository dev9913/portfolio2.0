import React, { useState } from 'react';

const Experience = () => {
  const [activeTab, setActiveTab] = useState('education-tab');

  return (
    <section id="experience">
      <h2 className="section-title">Experience & Education</h2>
      <div className="tab-buttons">
        <button className={`tab-btn ${activeTab === 'education-tab' ? 'active' : ''}`} onClick={() => setActiveTab('education-tab')}>Education</button>
        <button className={`tab-btn ${activeTab === 'experience-tab' ? 'active' : ''}`} onClick={() => setActiveTab('experience-tab')}>Experience</button>
      </div>
      <div className={`tab-content ${activeTab === 'education-tab' ? 'active' : ''}`} id="education-tab">
        <div className="card-grid">
          <div className="exp-card">
            <div className="card-icon">🎓</div>
            <h3>Bachelor of Computer Application</h3>
            <span className="card-subtitle">S.S.G PAREEK PG COLLEGE | 2023 - 2026</span>
            <p>Focus on cloud computing, scripting, and software deployment best practices.</p>
          </div>
        </div>
      </div>
      <div className={`tab-content ${activeTab === 'experience-tab' ? 'active' : ''}`} id="experience-tab">
        <div className="exp-card">
          <h3>Still Finding Internship</h3>
        </div>
      </div>
    </section>
  );
};

export default Experience;

// src/components/Experience.jsx

// import React, { useState } from 'react';

// const timeline = [
//   {
//     id: 1,
//     title: "Bachelor of Computer Application",
//     date: "2023 - 2026",
//     description: "Focus on cloud computing, scripting, and software deployment best practices."
//   },
//   {
//     id: 2,
//     title: "Looking for Internship",
//     date: "2025",
//     description: "Currently seeking opportunities in DevOps and cloud automation."
//   }
// ];

// const Experience = () => {
//   const [active, setActive] = useState(null);

//   return (
//     <section id="experience">
//       <h2 className="section-title">Experience & Education</h2>
//       <div className="timeline">
//         {timeline.map(item => (
//           <div key={item.id} className="timeline-item">
//             <div className="timeline-date">{item.date}</div>
//             <div
//               className="timeline-content"
//               onClick={() => setActive(active === item.id ? null : item.id)}
//             >
//               <h3>{item.title}</h3>
//               {active === item.id && <p>{item.description}</p>}
//             </div>
//           </div>
//         ))}
//       </div>
//     </section>
//   );
// };

// export default Experience;
