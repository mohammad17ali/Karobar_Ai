import React from 'react';
import './AboutUs.css';

function AboutUs() {
  return (
    <div className="about-us-container">
      <div className="animation-left"></div>
      <div className="about-us">
        <h1>About Karobar Ai</h1>
        <p>
          KarobarAi is a pioneering Ai-powered ERP solution dedicated to transforming the Indian retail landscape by addressing the key challenges faced by retail traders. Our mission is to empower Indian retail traders by streamlining their operations, enhancing efficiency, and driving growth within the sector.
        </p>
        <p>
          With the Indian retail sector accounting for over 10% of the country's GDP and around 8% of the workforce, the challenges in this space are significant. Retail traders face issues such as inefficient operations, low technology adoption, and complex compliance requirements, leading to substantial financial losses and impacting the overall economy.
        </p>
        <p>
          KarobarAi is committed to bridging the gap between traditional retail practices and cutting-edge innovation. We have developed a comprehensive and user-friendly ERP solution that directly addresses these challenges. Our platform streamlines operations, boosts efficiency, and enhances profitability by offering features like AI-assisted order management, inventory management, cash flow tracking, and GST compliance.
        </p>
        <p>
          Founded with the goal of driving growth and innovation in the sector, KarobarAi stands at the forefront of empowering Indian retail traders, helping them to thrive in a rapidly evolving business environment. Through our technology, we are not only helping businesses succeed but also contributing to the broader economic development of the country.
        </p>
        <p>
          Join us on our journey as we revolutionize the Indian retail sector and create a brighter future for all stakeholders involved.
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
