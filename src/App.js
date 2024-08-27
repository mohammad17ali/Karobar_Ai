
import './App.css';

function App() {
  const aboutUsRef = useRef(null);

  const handleDemoClick = () => {
    window.location.href = 'https://drive.google.com/file/d/13OCwZ73dFg3Z3br_nYG08jYemitLDcqY/view';
  };

  const scrollToAboutUs = () => {
    aboutUsRef.current.scrollIntoView({ behavior: 'smooth' });
  };

  return (
    <div className="App">
      <div className="navbar">
        <div className="logo">
          <img src={`${process.env.PUBLIC_URL}/Logo.png`} alt="Karobar Ai Logo" />
          <div className="logo-text">Intelligent Shop Solutions</div>
        </div>
        <div className="nav-links">
          <a href="#" onClick={scrollToAboutUs}>About</a>
          <a href="#">Solutions</a>
          <a href="#">Resources</a>
          <a href="#">Download</a>
        </div>
        <div className="right-links">
          <a href="#">Contact us</a>
          <button className="demo-btn" onClick={handleDemoClick}>Explore demo</button>
        </div>
      </div>
      <div className="main-section">
        <h1>Revolutionizing<br />retail with intelligent<br />solutions.</h1>
        <p>Empowering retailers with innovative technology solutions<br /> to enhance customer experiences and drive growth.</p>
        <div className="main-buttons">
          <button className="explore-btn" onClick={handleDemoClick}>Explore demo</button>
          <button className="contact-btn">Contact us</button>
        </div>
      </div>
   </div>
    
  );
}

export default App;
