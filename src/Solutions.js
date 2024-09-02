import React from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faRobot, faChartLine, faFileInvoiceDollar, faMobileAlt } from '@fortawesome/free-solid-svg-icons';

function Solutions() {
  return (
    <div className="solutions-container" id="solutions" data-aos="fade-up">
      <h2>Innovative Retail Solutions</h2>
      <p className="solutions-description">
        Unlock the power of AI and data-driven technologies to streamline operations, enhance customer experiences, and drive growth.
      </p>
      <div className="solutions-list">
        <div className="solution-card" data-aos="fade-right">
          <div className="image-container">
            <img src={`${process.env.PUBLIC_URL}/ai assistent.png`} alt="AI Shop Assistant" />
          </div>
          <h3>
            <FontAwesomeIcon icon={faRobot} /> AI Shop Assistant
          </h3>
          <p>
            Enhance customer interactions with AI-driven voice order processing, making every transaction smoother and more efficient.
          </p>
        </div>
        <div className="solution-card" data-aos="fade-left">
          <div className="image-container">
            <img src={`${process.env.PUBLIC_URL}/datadriven.png`} alt="Data-Driven Inventory Management" />
          </div>
          <h3>
            <FontAwesomeIcon icon={faChartLine} /> Data-Driven Inventory Management
          </h3>
          <p>
            Utilize real-time sales data to optimize inventory levels and ensure your shop is always ready to meet customer demand.
          </p>
        </div>
        <div className="solution-card" data-aos="fade-right">
          <div className="image-container">
            <img src={`${process.env.PUBLIC_URL}/gst.png`} alt="GST Bill Automation" />
          </div>
          <h3>
            <FontAwesomeIcon icon={faFileInvoiceDollar} /> GST Bill Automation
          </h3>
          <p>
            Simplify tax compliance with automatic GST bill generation and streamlined input tax credit calculations.
          </p>
        </div>
        <div className="solution-card" data-aos="fade-left">
          <div className="image-container">
            <img src={`${process.env.PUBLIC_URL}/ultimate.png`} alt="The Ultimate Mobile App" />
          </div>
          <h3>
            <FontAwesomeIcon icon={faMobileAlt} /> The Ultimate Mobile App
          </h3>
          <p>
            Manage your shop on the go with a mobile app that allows you to update inventory, track sales, and more from your fingertips.
          </p>
        </div>
      </div>
    </div>
  );
}

export default Solutions;
