import React, { useRef } from 'react';
import { BrowserRouter as Router, Route, Routes, Link } from 'react-router-dom';
import './App.css';
import AboutUs from './AboutUs'; // Ensure AboutUs component is correctly imported
import ContactUs from './ContactUs'; // Ensure ContactUs component is correctly imported

function App() {
  const aboutUsRef = useRef(null);

  const handleDemoClick = () => {
    window.location.href = 'https://drive.google.com/file/d/13OCwZ73dFg3Z3br_nYG08jYemitLDcqY/view';
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
            <Link to="/about-us">About</Link>
            <Link to="#">Solutions</Link>
            <Link to="#">Resources</Link>
            <Link to="#">Download</Link>
          </div>
          <div className="right-links">
            <Link to="/contact-us">Contact us</Link>
            <button className="demo-btn" onClick={handleDemoClick}>Explore demo</button>
          </div>
        </div>

        <Routes>
          <Route path="/" element={
            <div className="main-section">
              <div className="text-content">
                <h1>
                  Revolutionizing<br />
                  retail with <br />
                  <span className="bold-text">Intelligent solutions.</span>
                </h1>
                <p>Empowering retailers with innovative technology solutions<br /> to enhance customer experiences and drive growth.</p>
                <div className="main-buttons">
                  <button className="explore-btn" onClick={handleDemoClick}>Explore demo</button>
                  <Link to="/contact-us"><button className="contact-btn">Contact us</button></Link>
                </div>
              </div>
              <div className="app-prototype">
                <img src={`${process.env.PUBLIC_URL}/ui-left.png`} alt="App Prototype" />
              </div>
            </div>
          } />
          <Route path="/about-us" element={<AboutUs />} />
          <Route path="/contact-us" element={<ContactUs />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
