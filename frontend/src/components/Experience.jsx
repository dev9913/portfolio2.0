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
          <h3>Looking For Internship Opportunity .</h3>
        </div>
      </div>
    </section>
  );
};

export default Experience;
