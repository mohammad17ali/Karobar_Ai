import React, { useEffect } from 'react';
import './AboutUs.css';
function AboutUs() {
  useEffect(() => {
    const handleMouseMove = (e) => {
      const { clientX: x, clientY: y } = e;
      const width = window.innerWidth;
      const height = window.innerHeight;

      // Calculate the position percentage
      const xPercent = (x / width) * 100;
      const yPercent = (y / height) * 100;

      // Set the background style based on mouse position
      document.documentElement.style.setProperty('--gradient-x', `${xPercent}%`);
      document.documentElement.style.setProperty('--gradient-y', `${yPercent}%`);
    };

    window.addEventListener('mousemove', handleMouseMove);

    return () => {
      window.removeEventListener('mousemove', handleMouseMove);
    };
  }, []);

  return (
    <div className="about-us-container">
      <div className="animation-left"></div>
      <div className="about-us">
        <h1>About Us</h1>
        <p>
          KarobarAi is a pioneering Ai-powered ERP solution dedicated to transforming the Indian retail landscape by addressing the key challenges faced by retail traders. Our mission is to empower Indian retail traders by streamlining their operations, enhancing efficiency, and driving growth within the sector.
        </p>
        <p>
          Join us on our journey as we revolutionize the Indian retail sector and create a brighter future for all stakeholders involved.
        </p>
        <p>
        Mohammad Ali 
        Founder, Karobar Ai
        </p>
        <a href="https://www.linkedin.com/company/karobar-ai/" target="_blank" rel="noopener noreferrer">
          <button>Learn More</button>
        </a>
      </div>
      <div className="animation-right"></div>
    </div>
  );
}

export default AboutUs;
