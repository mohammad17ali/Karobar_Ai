import React, { useEffect } from 'react';
import './ContactUs.css';

function ContactUs() {
  useEffect(() => {
    document.body.classList.add('no-scroll');
    return () => {
      document.body.classList.remove('no-scroll');
    };
  }, []);

  return (
    <div className="contact-us">
      <div className="contact-us-content">
        <div className="contact-details">
          <div className="contact-card">
            <h2 className="fade-in">Contact Information</h2>
            <p><strong>Phone:</strong> +91 9906168015</p>
            <p><strong>Email:</strong> reach@karobar.info</p>
          </div>
          <div className="contact-card">
            <h2 className="fade-in">Office Address</h2>
            <p>X6PM+653,</p>
            <p>Indian Institute Of Technology,</p>
            <p>Chennai, Tamil Nadu 600036</p>
          </div>
        </div>
        <div className="map-card">
          <div className="map-container fade-in">
            <iframe
              title="IIT Chennai Location"
              src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3919.0555315940086!2d80.23761731474896!3d13.006753690826063!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3a5267d99d9d8c05%3A0xc6118bb4e3c4eeb5!2sIndian%20Institute%20of%20Technology%20Madras!5e0!3m2!1sen!2sin!4v1633001016748!5m2!1sen!2sin"
              width="100%"
              height="100%"
              style={{ border: 0 }}
              allowFullScreen=""
              loading="lazy"
            ></iframe>
          </div>
        </div>
      </div>
    </div>
  );
}

export default ContactUs;
