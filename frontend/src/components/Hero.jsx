import devImage from "../assets/devimg.jpeg";
import devresume from "../assets/Dev_Resume.pdf";

const Home = () => {
  return (
    <section id="hero" className="home">
      <div className="home-text">
        <h1>Dev Jangir</h1>
        <h2>DevOps Engineer | Cloud | CI/CD</h2>
        <p>I build automated, scalable, and secure systems.</p>

        <div className="home-actions">
          <a href={devresume} className="btn primary">Download Resume</a> 
	  <a href="#projects" className="btn secondary">Projects</a>
          <a href="#contact" className="btn secondary">Contact Me</a>
        </div>
      </div>

      <div className="home-img">
        <img src={devImage} alt="Dev" />
      </div>
    </section>
  );
};

export default Home;

