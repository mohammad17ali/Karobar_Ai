import React from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faFacebookF, faTwitter, faLinkedinIn, faGithub } from '@fortawesome/free-brands-svg-icons';
import './Footer.css';

function Footer() {
  return (
    <footer className="footer">
      <div className="footer-content">
        <div className="social-media">
          <a href="https://facebook.com" aria-label="Facebook"><FontAwesomeIcon icon={faFacebookF} /></a>
          <a href="https://twitter.com" aria-label="Twitter"><FontAwesomeIcon icon={faTwitter} /></a>
          <a href="https://www.linkedin.com/company/karobar-ai/" aria-label="LinkedIn"><FontAwesomeIcon icon={faLinkedinIn} /></a>
          <a href="https://github.com" aria-label="Github"><FontAwesomeIcon icon={faGithub} /></a>
        </div>
        <div className="footer-links">
          <a href="#">Privacy Policy</a>
          <a href="#">Terms of Service</a>
          <a href="#">Support</a>
        </div>
        <div className="copyright">
          <p>Copyright © 2024 Karobar Ai - All Rights Reserved.</p>
        </div>
      </div>
    </footer>
  );
}

export default Footer;
