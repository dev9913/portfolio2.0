// import React from 'react';
// import ReactDOM from 'react-dom/client';
// import App from './App';
// import './styles.css'; // Import CSS here or in App.jsx

// // const root = ReactDOM.createRoot(document.getElementById('root'));
// // root.render(
// //   <React.StrictMode>
// //     <App />
// //   </React.StrictMode>
// // );

// import { HelmetProvider } from "react-helmet-async";

// root.render(
//   <HelmetProvider>
//     <App />
//   </HelmetProvider>
// );


import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './styles.css';
import { HelmetProvider } from "react-helmet-async";

const root = ReactDOM.createRoot(document.getElementById('root'));

root.render(
  <React.StrictMode>
    <HelmetProvider>
      <App />
    </HelmetProvider>
  </React.StrictMode>
);
