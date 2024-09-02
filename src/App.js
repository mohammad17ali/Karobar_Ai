import React, { useEffect, useRef } from 'react';
import { BrowserRouter as Router, Route, Routes, Link } from 'react-router-dom';
import AOS from 'aos';
import 'aos/dist/aos.css';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faArrowRight, faPhone, faEnvelope, faDownload, faCog, faRobot, faArrowUp } from '@fortawesome/free-solid-svg-icons';
import './App.css';
import AboutUs from './AboutUs';
import ContactUs from './ContactUs';
import Solutions from './Solutions';
import Footer from './Footer';

function App() {
  const solutionsRef = useRef(null);

  useEffect(() => {
    AOS.init({ duration: 1000 });
  }, []);

  const handleSolutionsClick = (e) => {
    e.preventDefault();
    if (solutionsRef.current) {
      solutionsRef.current.scrollIntoView({ behavior: 'smooth' });
    }
  };

  const handleDemoClick = () => {
    window.location.href = 'https://drive.google.com/file/d/13OCwZ73dFg3Z3br_nYG08jYemitLDcqY/view';
  };

  const handleScrollToTop = () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return (
    <Router>
      <div className="App">
        <div className="navbar">
          <div className="logo">
            <Link to="/">
              <img src={`${process.env.PUBLIC_URL}/Logo.png`} alt="Karobar Ai Logo" />
            </Link>
            <div className="logo-text">Intelligent Shop Solutions</div>
          </div>
          <div className="nav-links">
            <Link to="/about-us">
              <FontAwesomeIcon icon={faCog} /> About
            </Link>
            <a href="#solutions" onClick={handleSolutionsClick}>
              <FontAwesomeIcon icon={faRobot} /> Solutions
            </a>
            <Link to="#">
              <FontAwesomeIcon icon={faDownload} /> Download
            </Link>
          </div>
          <div className="right-links">
            <Link to="/contact-us">
              <FontAwesomeIcon icon={faPhone} /> Contact us
            </Link>
            <button className="demo-btn" onClick={handleDemoClick}>
              <FontAwesomeIcon icon={faArrowRight} /> Explore demo
            </button>
          </div>
        </div>

        <Routes>
          <Route path="/" element={
            <div>
              <div className="main-section" data-aos="fade-up">
                <div className="text-content">
                  <h1>
                    Revolutionizing<br />
                    retail with <br />
                    <span className="bold-text">Intelligent solutions.</span>
                  </h1>
                  <p>
                    Empowering retailers with innovative technology solutions<br />
                    to enhance customer experiences and drive growth.
                  </p>
                  <div className="main-buttons">
                    <button className="explore-btn" onClick={handleDemoClick}>
                      <FontAwesomeIcon icon={faArrowRight} /> Explore demo
                    </button>
                    <Link to="/contact-us">
                      <button className="contact-btn">
                        <FontAwesomeIcon icon={faEnvelope} /> Contact us
                      </button>
                    </Link>
                  </div>
                </div>
                <div className="app-prototype">
                  <img src={`${process.env.PUBLIC_URL}/ui-left.png`} alt="App Prototype" />
                </div>
              </div>
              <div ref={solutionsRef}>
                <Solutions />
              </div>
            </div>
          } />
          <Route path="/about-us" element={<AboutUs />} />
          <Route path="/contact-us" element={<ContactUs />} />
        </Routes>

        {/* Scroll to Top Button */}
        <button className="scroll-to-top" onClick={handleScrollToTop}>
          <FontAwesomeIcon icon={faArrowUp} />
        </button>

        <Footer />
      </div>
    </Router>
  );
}

export default App;
